import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_todo_list/app/core/utils/keys.dart';
import 'package:getx_todo_list/app/data/model/task.dart';
import 'package:getx_todo_list/app/data/services/storage/services.dart';

class TaskProvider {
  final _storage = Get.find<StorageService>();

  List<Task> readTask() {
    var tasks = <Task>[];
    final jsonString = _storage.read(taskKey).toString();

    (jsonDecode(jsonString) as List<dynamic>).forEach(
      (e) => tasks.add(
        Task.fromJsom(e),
      ),
    );
    return tasks;
  }

  void writeTask(List<Task> tasks) {
    _storage.write(taskKey, jsonEncode(tasks));
  }
}
