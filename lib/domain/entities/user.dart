import 'package:equatable/equatable.dart';

/// User domain entity
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.isEmailVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String name;
  final String? avatar;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    avatar,
    isEmailVerified,
    createdAt,
    updatedAt,
  ];
}
