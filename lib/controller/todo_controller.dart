import 'package:get/get.dart';

import '../database/db_helper.dart';
import '../model/todo_model.dart';

class TodoController extends GetxController {
  final DBHelper dbHelper = DBHelper.db;
  var todoList = <TodoModel>[].obs;

  /// fetchAllTodos
  void fetchAllTodos() async {
    todoList.value = await dbHelper.getAllTodos();
  }

  /// delete todos
  void deleteTodos(int sno) async {
    await dbHelper.deleteTodos(sno);
  }

  /// update todos
  void updateTodos(TodoModel todosModel) async {
    await dbHelper.updateTodos(todosModel);
  }

  /// add todos
  void addTodos(TodoModel todosModel) async {
    await dbHelper.addTodos(todosModel);
  }

  /// --- toggle staus --- ///
  void toggleTodoStatus(TodoModel todoModel) async {
    todoModel.isDone = todoModel.isDone == 0 ? 1 : 0;
    await dbHelper.updateTodos(todoModel);
    fetchAllTodos();
  }

  /// get total todos
  int get totalTodos => todoList.length;

  int get completedTodos =>
      todoList.where((element) => element.isDone == 1).length;

  double get percentageCompleted {
    if (totalTodos == 0) return 0;
    return (completedTodos / totalTodos);
  }

}
