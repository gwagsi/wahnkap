import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../domain/usecases/authorize_user.dart';
import '../../domain/usecases/handle_oauth_callback.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/start_oauth_flow.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final StartOAuthFlow _startOAuthFlow;
  final HandleOAuthCallback _handleOAuthCallback;
  final AuthorizeUser _authorizeUser;
  final Logout _logout;
  final IAuthRepository _repository;

  AuthBloc({
    required StartOAuthFlow startOAuthFlow,
    required HandleOAuthCallback handleOAuthCallback,
    required AuthorizeUser authorizeUser,
    required Logout logout,
    required IAuthRepository repository,
  }) : _startOAuthFlow = startOAuthFlow,
       _handleOAuthCallback = handleOAuthCallback,
       _authorizeUser = authorizeUser,
       _logout = logout,
       _repository = repository,
       super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginStarted>(_onAuthLoginStarted);
    on<AuthLoginCompleted>(_onAuthLoginCompleted);
    on<AuthOAuthCallbackReceived>(_onAuthOAuthCallbackReceived);
    on<AuthUserSelected>(_onAuthUserSelected);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('🔍 AuthBloc: Checking authentication status...');
    emit(AuthLoading());

    try {
      // Check if user is already authenticated
      final isAuthenticated = await _repository.isAuthenticated();
      if (isAuthenticated) {
        debugPrint(
          '✅ AuthBloc: User is authenticated, getting current user...',
        );
        final result = await _repository.getCurrentUser();
        result.fold(
          (failure) {
            debugPrint(
              '❌ AuthBloc: Failed to get current user - ${failure.message}',
            );
            emit(AuthUnauthenticated());
          },
          (user) {
            if (user != null) {
              debugPrint('✅ AuthBloc: User loaded - ${user.email}');
              emit(AuthAuthenticated(user: user));
            } else {
              debugPrint('❌ AuthBloc: No user found');
              emit(AuthUnauthenticated());
            }
          },
        );
      } else {
        debugPrint('❌ AuthBloc: User not authenticated');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      debugPrint('❌ AuthBloc: Error checking authentication - $e');
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginStarted(
    AuthLoginStarted event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('🔐 AuthBloc: Starting OAuth login...');
    emit(AuthLoginInProgress());

    final result = await _startOAuthFlow(NoParams());

    result.fold(
      (failure) {
        debugPrint('❌ AuthBloc: OAuth flow failed - ${failure.message}');
        emit(AuthError(message: failure.message));
      },
      (sessions) {
        debugPrint(
          '✅ AuthBloc: OAuth flow completed with ${sessions.length} sessions',
        );
        emit(AuthSessionsReceived(sessions: sessions));
      },
    );
  }

  Future<void> _onAuthLoginCompleted(
    AuthLoginCompleted event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint(
      '✅ AuthBloc: Login completed with ${event.sessions.length} sessions',
    );
    emit(AuthSessionsReceived(sessions: event.sessions));
  }

  Future<void> _onAuthOAuthCallbackReceived(
    AuthOAuthCallbackReceived event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint('📨 AuthBloc: OAuth callback received - ${event.redirectUrl}');
    emit(AuthLoading());

    final result = await _handleOAuthCallback(
      HandleOAuthCallbackParams(redirectUrl: event.redirectUrl),
    );

    result.fold(
      (failure) {
        debugPrint('❌ AuthBloc: OAuth callback failed - ${failure.message}');
        emit(AuthError(message: failure.message));
      },
      (sessions) {
        debugPrint(
          '✅ AuthBloc: OAuth callback succeeded with ${sessions.length} sessions',
        );
        emit(AuthSessionsReceived(sessions: sessions));
      },
    );
  }

  Future<void> _onAuthUserSelected(
    AuthUserSelected event,
    Emitter<AuthState> emit,
  ) async {
    debugPrint(
      '👤 AuthBloc: User selected token: ${event.token.substring(0, 10)}...',
    );
    emit(AuthLoading());

    try {
      // First, store all OAuth sessions with the selected token as primary
      debugPrint(
        '💾 AuthBloc: Storing ${event.allSessions.length} OAuth sessions...',
      );
      final storeResult = await _repository.storeOAuthSessions(
        event.allSessions,
        event.token,
      );

      await storeResult.fold(
        (failure) async {
          debugPrint(
            '❌ AuthBloc: Failed to store sessions - ${failure.message}',
          );
          emit(
            AuthError(message: 'Failed to store sessions: ${failure.message}'),
          );
        },
        (_) async {
          debugPrint('✅ AuthBloc: Sessions stored, now authorizing user...');

          // Then authorize the user with the selected token
          final authResult = await _authorizeUser(
            AuthorizeUserParams(token: event.token),
          );

          authResult.fold(
            (failure) {
              debugPrint(
                '❌ AuthBloc: User authorization failed - ${failure.message}',
              );
              emit(AuthError(message: failure.message));
            },
            (user) {
              debugPrint(
                '✅ AuthBloc: User authorized successfully - ${user.email}',
              );
              emit(AuthAuthenticated(user: user));
            },
          );
        },
      );
    } catch (e) {
      debugPrint('❌ AuthBloc: Unexpected error during user selection - $e');
      emit(AuthError(message: 'Unexpected error: $e'));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _logout(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
