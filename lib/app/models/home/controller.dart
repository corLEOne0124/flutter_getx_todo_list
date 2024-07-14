import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_todo_list/app/data/model/task.dart';
import 'package:getx_todo_list/app/data/services/storage/repository.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;
  final formKey = GlobalKey<FormState>();
  final editController = TextEditingController();
  final chipIndex = 0.obs;
  final tabIndex = 0.obs;
  final deleting = false.obs;
  final task = Rx<Task?>(null);
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

  HomeController({
    required this.taskRepository,
  });
  final tasks = <Task>[].obs;
  @override
  void onInit() {
    tasks.assignAll(
      taskRepository.readTasks(),
    );
    super.onInit();
    ever(tasks, (_) => taskRepository.writeTask(tasks));
  }

  void changeTodos(List<dynamic> select) {
    doingTodos.clear();
    doneTodos.clear();
    for (var i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void changeTask(Task? selectedTask) {
    task.value = selectedTask;
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }

  @override
  void onClose() {
    editController.dispose();
    super.onClose();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  taskUpdate(Task task, String title) {
    var todos = task.todos ?? [];
    if (containTodo(todos, title)) {
      return false;
    }
    var todo = {'title': title, 'done': false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    return true;
  }

  bool containTodo(List todos, String title) {
    return todos.any((e) => e['title'] == title);
  }

  bool addTodo(String title) {
    var todo = {'title': title, 'done': false};
    if (doingTodos.any(
      (element) => mapEquals<String, dynamic>(todo, element),
    )) {
      return false;
    }
    var doneTodo = {'title': title, 'done': true};
    if (doneTodos.any(
      (element) => mapEquals<String, dynamic>(todo, element),
    )) {
      return false;
    }
    doingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos,
    ]);

    final newTask = task.value!.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(task.value);
    tasks[oldIdx] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title) {
    var doingTodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere(
      (element) => mapEquals<String, dynamic>(doingTodo, element),
    );
    var doneTodo = {
      'title': title,
      'done': true,
    };
    doingTodos.removeAt(index);
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void deleteDoneTodo(dynamic doneTodo) {
    var index = doneTodos.indexWhere(
      (element) => mapEquals<String, dynamic>(doneTodo, element),
    );
    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  bool isTodoEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task) {
    var res = 0;
    for (var i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res += 1;
      }
    }
    return res;
  }

  int getTotalTask() {
    var res = 0;
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }

  int getTotalDoneTask() {
    var res = 0;
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (var j = 0; j < tasks[i].todos!.length; j++) {
          if (tasks[i].todos![j]['done'] == true) {
            res += 1;
          }
        }
      }
    }
    return res;
  }
}
