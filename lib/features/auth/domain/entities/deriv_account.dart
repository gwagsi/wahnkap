import 'package:equatable/equatable.dart';

class DerivAccount extends Equatable {
  final String loginId;
  final String accountType;
  final String currency;
  final double balance;
  final bool isVirtual;
  final bool isDisabled;
  final String? landingCompanyName;
  final DateTime? createdAt;

  const DerivAccount({
    required this.loginId,
    required this.accountType,
    required this.currency,
    required this.balance,
    required this.isVirtual,
    required this.isDisabled,
    this.landingCompanyName,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    loginId,
    accountType,
    currency,
    balance,
    isVirtual,
    isDisabled,
    landingCompanyName,
    createdAt,
  ];
}
