import 'package:equatable/equatable.dart';

/// Todo domain entity
class Todo extends Equatable {
  const Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isCompleted,
    createdAt,
    updatedAt,
  ];
}
