import '../../domain/entities/auth_user.dart';
import 'deriv_account_model.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.userId,
    required super.email,
    required super.fullName,
    required super.country,
    required super.preferredLanguage,
    required super.scopes,
    required super.accounts,
    super.currentAccount,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final accountList = json['accounts'] as List<dynamic>? ?? [];
    final accounts = accountList
        .map(
          (account) =>
              DerivAccountModel.fromJson(account as Map<String, dynamic>),
        )
        .toList();

    return AuthUserModel(
      userId: json['userId'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      country: json['country'] as String,
      preferredLanguage: json['preferredLanguage'] as String,
      scopes: (json['scopes'] as List<dynamic>).cast<String>(),
      accounts: accounts,
      currentAccount: json['currentAccount'] != null
          ? DerivAccountModel.fromJson(
              json['currentAccount'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'fullName': fullName,
      'country': country,
      'preferredLanguage': preferredLanguage,
      'scopes': scopes,
      'accounts': accounts
          .map((account) => (account as DerivAccountModel).toJson())
          .toList(),
      'currentAccount': currentAccount != null
          ? (currentAccount! as DerivAccountModel).toJson()
          : null,
    };
  }

  factory AuthUserModel.fromApiResponse(Map<String, dynamic> json) {
    final accountList = json['account_list'] as List<dynamic>? ?? [];
    final accounts = accountList
        .map(
          (account) => DerivAccountModel.fromApiResponse(
            account as Map<String, dynamic>,
          ),
        )
        .toList();

    return AuthUserModel(
      userId: json['user_id'].toString(),
      email: json['email'] as String,
      fullName: json['fullname'] as String,
      country: json['country'] as String,
      preferredLanguage: json['preferred_language'] as String,
      scopes: (json['scopes'] as List<dynamic>?)?.cast<String>() ?? [],
      accounts: accounts,
      currentAccount: accounts.isNotEmpty
          ? accounts.firstWhere(
              (account) => account.loginId == json['loginid'],
              orElse: () => accounts.first,
            )
          : null,
    );
  }
}
