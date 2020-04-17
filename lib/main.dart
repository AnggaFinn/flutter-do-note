import 'package:flutter/material.dart';
import 'package:todo_app/ui/todo_list.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: TodoList(),
    );
  }
}