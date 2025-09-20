import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final DateTime lastUpdated;

  const Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [
        id,
        userId,
        balance,
        currency,
        lastUpdated,
      ];
}