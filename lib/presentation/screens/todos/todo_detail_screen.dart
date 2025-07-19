import 'package:flutter/material.dart';

/// Todo detail screen
class TodoDetailScreen extends StatelessWidget {
  const TodoDetailScreen({super.key, required this.todoId});

  final String todoId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo Detail')),
      body: Center(child: Text('Todo Detail Screen - ID: $todoId')),
    );
  }
}
