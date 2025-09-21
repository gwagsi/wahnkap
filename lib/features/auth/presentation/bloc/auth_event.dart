import 'package:equatable/equatable.dart';
import '../../domain/entities/oauth_session.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginStarted extends AuthEvent {}

class AuthLoginCompleted extends AuthEvent {
  final List<OAuthSession> sessions;

  const AuthLoginCompleted({required this.sessions});

  @override
  List<Object> get props => [sessions];
}

class AuthUserSelected extends AuthEvent {
  final String token;
  final List<OAuthSession> allSessions;

  const AuthUserSelected({
    required this.token,
    required this.allSessions,
  });

  @override
  List<Object> get props => [token, allSessions];
}

class AuthOAuthCallbackReceived extends AuthEvent {
  final String redirectUrl;

  const AuthOAuthCallbackReceived({required this.redirectUrl});

  @override
  List<Object> get props => [redirectUrl];
}

class AuthLogoutRequested extends AuthEvent {}
