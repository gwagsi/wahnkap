import '../../domain/entities/deriv_account.dart';

class DerivAccountModel extends DerivAccount {
  const DerivAccountModel({
    required super.loginId,
    required super.accountType,
    required super.currency,
    required super.balance,
    required super.isVirtual,
    required super.isDisabled,
    super.landingCompanyName,
    super.createdAt,
  });

  factory DerivAccountModel.fromJson(Map<String, dynamic> json) {
    return DerivAccountModel(
      loginId: json['loginId'] as String,
      accountType: json['accountType'] as String,
      currency: json['currency'] as String,
      balance: (json['balance'] as num).toDouble(),
      isVirtual: json['isVirtual'] as bool,
      isDisabled: json['isDisabled'] as bool,
      landingCompanyName: json['landingCompanyName'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loginId': loginId,
      'accountType': accountType,
      'currency': currency,
      'balance': balance,
      'isVirtual': isVirtual,
      'isDisabled': isDisabled,
      'landingCompanyName': landingCompanyName,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory DerivAccountModel.fromApiResponse(Map<String, dynamic> json) {
    return DerivAccountModel(
      loginId: json['loginid'] as String,
      accountType: json['account_type'] as String,
      currency: json['currency'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isVirtual: json['is_virtual'] == 1,
      isDisabled: json['is_disabled'] == 1,
      landingCompanyName: json['landing_company_name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['created_at'] as int) * 1000,
            )
          : null,
    );
  }
}
