import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/todo_controller.dart';
import '../model/todo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoController todoController = Get.put(TodoController());
  final todoMessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    todoController.fetchAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ----- Appbar ------------ ///
      appBar: AppBar(
        title: Text(
          "TODOS",
          style: Get.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 27,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.vertical(
            bottom: Radius.circular(22),
          ),
        ),
      ),

      /// ------ Body ----- ////
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(height: 4),

            /// ---- Progress bar section ---- ///
            Obx(() {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(21),
                  border: BoxBorder.all(width: 1, color: Colors.blue),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2,
                      offset: Offset(1.0, 1.5),
                    ),
                  ],
                  color: Colors.blue.shade50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: Get.width * 0.2,
                            width: Get.width * 0.2,
                            child: CircularProgressIndicator(
                              value: todoController.percentageCompleted,
                              backgroundColor: Colors.grey[300],
                              color: Colors.blue,
                              strokeWidth: 8,
                            ),
                          ),

                          Text(
                            "${todoController.percentageCompleted == 0 ? 0 : (todoController.percentageCompleted * 100).toInt()} %",
                            style: Get.textTheme.titleLarge!.copyWith(
                              color: Colors.blue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        /// Total Todos
                        children: [
                          Text(
                            "Total : ${todoController.totalTodos}",
                            style: Get.textTheme.bodyLarge!.copyWith(
                              fontFamily: "primary",
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          /// ---- Completed ----
                          Text(
                            "Completed : ${todoController.completedTodos}",
                            style: Get.textTheme.bodyLarge!.copyWith(
                              fontFamily: "primary",
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: 20),

            Expanded(
              child: Obx(() {
                if (todoController.todoList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/assets/image/empty.png",
                          height: 150,
                          fit: BoxFit.cover,
                        ),

                        Text(
                          "Todos is Empty",
                          style: Get.textTheme.titleLarge!.copyWith(
                            fontSize: 21,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 6),

                        Text(
                          "Click on + button to add Todos",
                          style: Get.textTheme.titleLarge!.copyWith(
                            fontSize: 21,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: todoController.todoList.length,
                  itemBuilder: (context, index) {
                    /// todos message
                    final todoMessage = todoController.todoList[index];
                    return Card(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              todoMessage.todoMessage,
                              style: Get.textTheme.titleMedium,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Divider(
                              color: Colors.grey.shade300,
                              thickness: 2,
                            ),
                          ),
                          SizedBox(height: 6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              /// ---- Check box --- ///
                              Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green.shade50,
                                  border: BoxBorder.all(
                                    width: 1.5,
                                    color: Colors.green.shade400,
                                  ),
                                ),
                                child: Checkbox(
                                  value: todoMessage.isDone == 1,
                                  onChanged: (value) {
                                    todoController.toggleTodoStatus(
                                      todoMessage,
                                    );
                                    todoController.fetchAllTodos();
                                  },
                                  checkColor: Colors.white,
                                  activeColor: Colors.blue,
                                ),
                              ),

                              ///------- Edit Button ----- //
                              InkWell(
                                onTap: () {
                                  todoMessageController.text =
                                      todoMessage.todoMessage;
                                  showUpdateBottomSheet(
                                    context: context,
                                    todoModel: todoMessage,
                                  );
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green.shade50,
                                    border: BoxBorder.all(
                                      width: 1.5,
                                      color: Colors.green.shade400,
                                    ),
                                  ),
                                  child: Icon(Icons.edit, color: Colors.green),
                                ),
                              ),

                              /// ---- Delete Button ---- ///
                              InkWell(
                                onTap: () {
                                  todoController.deleteTodos(todoMessage.sNo!);
                                  todoController.fetchAllTodos();
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.shade50,
                                    border: BoxBorder.all(
                                      width: 1.5,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                  child: Icon(Icons.delete, color: Colors.red),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 6),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            /// -------------- Add Button -------------- ///
            SizedBox(
              width: Get.width * 0.9,
              child: ElevatedButton(
                onPressed: () {
                  showBottomSheet(context: context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 28),
                      SizedBox(width: 6),

                      Text(
                        "Add Todos",
                        style: Get.textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Add todos
  void showBottomSheet({required BuildContext context}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: Get.height * 0.7,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusGeometry.vertical(
              top: Radius.circular(28),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade200,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 21),
              Text(
                "Add TODOS",
                style: Get.textTheme.titleLarge!.copyWith(
                  color: Colors.grey.shade800,
                ),
              ),

              SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: todoMessageController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hint: Text(
                      "Here Write your Todos",
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    fillColor: Colors.grey.shade100.withValues(alpha: 0.7),
                    filled: true,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(21),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.5, color: Colors.grey.shade700),
                    ),
                    child: Text(
                      "Cancel",
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final newTodos = TodoModel(
                        todoMessage: todoMessageController.text,
                        isDone: 0,
                      );
                      todoController.addTodos(newTodos);
                      todoController.fetchAllTodos();
                      Get.back();
                      todoMessageController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      "Add Todo",
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Edit Todos
  void showUpdateBottomSheet({
    required BuildContext context,
    required TodoModel todoModel,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: Get.height * 0.7,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusGeometry.vertical(
              top: Radius.circular(28),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade200,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 21),
              Text(
                "Update TODOS",
                style: Get.textTheme.titleLarge!.copyWith(
                  color: Colors.grey.shade800,
                ),
              ),

              SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: todoMessageController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hint: Text(
                      "Here Write your Todos",
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    fillColor: Colors.grey.shade100.withValues(alpha: 0.7),
                    filled: true,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(21),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(21),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },

                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 1.5, color: Colors.grey.shade700),
                    ),
                    child: Text(
                      "Cancel",
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (todoMessageController.text.isNotEmpty) {
                        todoController.updateTodos(
                          TodoModel(
                            sNo: todoModel.sNo,
                            todoMessage: todoMessageController.text,
                            isDone: todoModel.isDone,
                          ),
                        );
                        todoController.fetchAllTodos();
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      "Update Todo",
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
