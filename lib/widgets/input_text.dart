import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/models/db_model.dart';
import 'package:todo_app/models/todo_item.dart';

// ignore: must_be_immutable
class InputText extends StatelessWidget {
  var db = DatabaseConnect();

  InputText({super.key});
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                  hintText: 'Type something...', border: InputBorder.none),
            ),
          )),
          GestureDetector(
            onTap: () async {
              if (textController.text.trim() != "") {
                await db.insertTodo(Todo(
                    task: textController.text,
                    time: DateTime.now().toLocal(),
                    isChecked: false));
                textController.text = '';
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please type something ?')));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              child: const CircleAvatar(
                child: Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
    );
  }
}
