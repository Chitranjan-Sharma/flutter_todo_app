import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:todo_app/models/db_model.dart';
import 'package:todo_app/models/todo_item.dart';
import 'package:todo_app/widgets/input_text.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  var db = DatabaseConnect();
  List<Todo> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    list = [];
  }

  @override
  Widget build(BuildContext context) {
    fetchTodoList();
    TextEditingController controller = TextEditingController();
    return Expanded(
        child: list.length == 0
            ? Center(
                child: Text('Add new todo'),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, i) {
                  return Card(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            value: list[i].isChecked,
                            onChanged: (value) async {
                              await db.markCompleted(list[i]);
                              fetchTodoList();
                            },
                          ),
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              list[i].task,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              list[i]
                                  .time
                                  .toString()
                                  .substring(0, 19)
                                  .split(' ')
                                  .reversed
                                  .join(' '),
                              textAlign: TextAlign.end,
                            )
                          ],
                        )),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                controller.text = list[i].task;
                              });
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  content: TextField(
                                    controller: controller,
                                  ),
                                  actions: <Widget>[
                                    IconButton(
                                        onPressed: () async {
                                          Todo todo = new Todo(
                                              id: list[i].id,
                                              task: controller.text,
                                              time: DateTime.now(),
                                              isChecked: list[i].isChecked);
                                          await db.updateTodo(todo);
                                          controller.text = '';
                                          fetchTodoList();

                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.done))
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              db.deleteTodo(list[i].id!);
                              fetchTodoList();
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  );
                }));
  }

  void fetchTodoList() {
    db.getTodo().then((value) => {
          setState(() {
            list = value.toList();
          })
        });
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Center(
                  child: Text(
                    'Login',
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  decoration: InputDecoration(hintText: 'enter email'),
                  autofocus: true,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(hintText: 'enter password'),
                  autofocus: true,
                ),
                SizedBox(height: 10),
              ],
            )));
  }
}

// ignore: must_be_immutable
