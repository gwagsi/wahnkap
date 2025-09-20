import 'package:equatable/equatable.dart';
import 'deriv_account.dart';

class AuthUser extends Equatable {
  final String userId;
  final String email;
  final String fullName;
  final String country;
  final String preferredLanguage;
  final List<String> scopes;
  final List<DerivAccount> accounts;
  final DerivAccount? currentAccount;

  const AuthUser({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.country,
    required this.preferredLanguage,
    required this.scopes,
    required this.accounts,
    this.currentAccount,
  });

  AuthUser copyWith({
    DerivAccount? currentAccount,
    List<DerivAccount>? accounts,
  }) {
    return AuthUser(
      userId: userId,
      email: email,
      fullName: fullName,
      country: country,
      preferredLanguage: preferredLanguage,
      scopes: scopes,
      accounts: accounts ?? this.accounts,
      currentAccount: currentAccount ?? this.currentAccount,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    email,
    fullName,
    country,
    preferredLanguage,
    scopes,
    accounts,
    currentAccount,
  ];
}
