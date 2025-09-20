import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/oauth_session.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthLoginInProgress extends AuthState {}

class AuthSessionsReceived extends AuthState {
  final List<OAuthSession> sessions;

  const AuthSessionsReceived({required this.sessions});

  @override
  List<Object> get props => [sessions];
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}
