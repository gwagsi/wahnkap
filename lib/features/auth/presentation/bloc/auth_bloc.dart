import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
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

  AuthBloc({
    required StartOAuthFlow startOAuthFlow,
    required HandleOAuthCallback handleOAuthCallback,
    required AuthorizeUser authorizeUser,
    required Logout logout,
  }) : _startOAuthFlow = startOAuthFlow,
       _handleOAuthCallback = handleOAuthCallback,
       _authorizeUser = authorizeUser,
       _logout = logout,
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
    emit(AuthLoading());

    // TODO: Check if user is already authenticated
    // For now, emit unauthenticated
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthLoginStarted(
    AuthLoginStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoginInProgress());

    final result = await _startOAuthFlow(NoParams());

    result.fold((failure) => emit(AuthError(message: failure.message)), (
      oauthUrl,
    ) {
      // The OAuth URL has been launched
      // We'll wait for the callback through AuthLoginCompleted
    });
  }

  Future<void> _onAuthLoginCompleted(
    AuthLoginCompleted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthSessionsReceived(sessions: event.sessions));
  }

  Future<void> _onAuthOAuthCallbackReceived(
    AuthOAuthCallbackReceived event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _handleOAuthCallback(
      HandleOAuthCallbackParams(redirectUrl: event.redirectUrl),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (sessions) => emit(AuthSessionsReceived(sessions: sessions)),
    );
  }

  Future<void> _onAuthUserSelected(
    AuthUserSelected event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _authorizeUser(
      AuthorizeUserParams(token: event.token),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
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
