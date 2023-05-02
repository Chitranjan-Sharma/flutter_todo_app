import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/models/todo_item.dart';

class DatabaseConnect {
  Database? _database;

  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    final dbName = 'todo.db';
    final path = join(dbPath, dbName);

    _database = await openDatabase(path, version: 1, onCreate: _createDB);

    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE todo(id INTEGER PRIMARY KEY AUTOINCREMENT,
task TEXT,
time TEXT,
isChecked INTEGER)

''');
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await database;

    await db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> markCompleted(Todo todo) async {
    final db = await database;

    todo.isChecked = !todo.isChecked;

    await db.update('todo', todo.toMap(), where: 'id==?', whereArgs: [todo.id]);
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update('todo', todo.toMap(), where: 'id==?', whereArgs: [todo.id]);
  }

  Future<void> deleteTodo(int id) async {
    final db = await database;

    await db.delete('todo', where: 'id==?', whereArgs: [id]);
  }

  Future<List<Todo>> getTodo() async {
    final db = await database;

    List<Map<String, dynamic>> items =
        await db.query('todo', orderBy: 'id DESC');

    return List.generate(
        items.length,
        (i) => Todo(
            id: items[i]['id'],
            task: items[i]['task'],
            time: DateTime.parse(items[i]['time']),
            isChecked: items[i]['isChecked'] == 1 ? true : false));
  }
}
