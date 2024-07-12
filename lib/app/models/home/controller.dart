import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_todo_list/app/data/model/task.dart';
import 'package:getx_todo_list/app/data/services/storage/repository.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;
  final formKey = GlobalKey<FormState>();
  final editController = TextEditingController();
  final chipIndex = 0.obs;
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

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }
}
