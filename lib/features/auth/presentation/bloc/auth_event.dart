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

  const AuthUserSelected({required this.token});

  @override
  List<Object> get props => [token];
}

class AuthLogoutRequested extends AuthEvent {}
