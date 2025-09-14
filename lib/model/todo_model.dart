import 'package:todo_app_with_getx_and_sqlite/database/db_helper.dart';

class TodoModel {
  int? sNo;
  String todoMessage;
  int isDone; // -> 0 = not done 1 -> Done

  TodoModel({this.sNo, required this.todoMessage, this.isDone = 0});

  /// ----- From Map ------- ///

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      sNo: map[DBHelper.columTodoSno],
      todoMessage: map[DBHelper.columnTodoMessage],
      isDone: map[DBHelper.columnIsDone],
    );
  }

  /// ----- to Map ------- ///
  Map<String, dynamic> toMap() {
    return {
      DBHelper.columTodoSno: sNo,
      DBHelper.columnTodoMessage: todoMessage,
      DBHelper.columnIsDone: isDone,
    };
  }
}
