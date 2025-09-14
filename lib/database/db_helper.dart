import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_with_getx_and_sqlite/model/todo_model.dart';

class DBHelper {
  /// --- private Singleton
  DBHelper._();

  /// Single instance of DBHelper
  static final DBHelper db = DBHelper._();

  static final dataBaseName = "todo.db";
  static final todoTableName = "myTodos";
  static final columTodoSno = "todoSno";
  static final columnTodoMessage = "todoMessage";
  static final columnIsDone = "isDone";

  static Database? _database;

  Future<Database> get myDataBase async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dataBaseName);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $todoTableName(
      $columTodoSno INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnTodoMessage TEXT ,
      $columnIsDone INTEGER 
      )
      ''');
  }

  /// add todos
  Future<int> addTodos(TodoModel todosModel) async {
    final db = await myDataBase;
    return await db.insert(todoTableName, todosModel.toMap());
  }

  /// fetch All todos
  Future<List<TodoModel>> getAllTodos() async {
    final db = await myDataBase;
    final List<Map<String, dynamic>> maps = await db.query(todoTableName);
    return List.generate(maps.length, (index) {
      return TodoModel.fromMap(maps[index]);
    });
  }

  /// delete todos
  Future<void> deleteTodos(int sno) async {
    final db = await myDataBase;
    await db.delete(
      todoTableName,
      where: '$columTodoSno = ?',
      whereArgs: [sno],
    );
  }

  /// edit todos
  Future<void> updateTodos(TodoModel todosModel) async {
    final db = await myDataBase;
    await db.update(
      todoTableName,
      todosModel.toMap(),
      where: '$columTodoSno = ?',
      whereArgs: [todosModel.sNo],
    );
  }
}
