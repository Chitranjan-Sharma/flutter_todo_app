import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:todo_app/models/todo_item.dart';
import 'package:todo_app/widgets/input_text.dart';

import 'package:todo_app/widgets/todo_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('Todo App'),
      ),
      body: Column(
        children: [
          InputText(),
          Container(
            height: 1,
            color: Colors.black,
          ),
          TodoList()
        ],
      ),
    );
  }
}
