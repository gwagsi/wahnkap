import 'package:equatable/equatable.dart';

enum TransactionType {
  deposit,
  withdrawal,
  transfer,
}

enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}

class Transaction extends Equatable {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String currency;
  final TransactionStatus status;
  final String? description;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? referenceId;

  const Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    this.description,
    required this.createdAt,
    this.completedAt,
    this.referenceId,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        amount,
        currency,
        status,
        description,
        createdAt,
        completedAt,
        referenceId,
      ];
}