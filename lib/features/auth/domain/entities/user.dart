import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? profileImageUrl;
  final DateTime createdAt;
  final bool isVerified;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.profileImageUrl,
    required this.createdAt,
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    profileImageUrl,
    createdAt,
    isVerified,
  ];
}
