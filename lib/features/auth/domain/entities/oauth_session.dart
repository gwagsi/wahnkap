import 'package:equatable/equatable.dart';

class OAuthSession extends Equatable {
  final String account;
  final String token;
  final String currency;

  const OAuthSession({
    required this.account,
    required this.token,
    required this.currency,
  });

  @override
  List<Object> get props => [account, token, currency];
}
