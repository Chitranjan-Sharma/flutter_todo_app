class Todo {
  int? id;
  final String task;
  final DateTime time;
  bool isChecked;

  Todo(
      {this.id,
      required this.task,
      required this.time,
      required this.isChecked});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'time': time.toString(),
      'isChecked': isChecked ? 1 : 0
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Todo(id:$id, task:$task, time:$time, isChecked:$isChecked)';
  }
}
