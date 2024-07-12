import 'package:getx_todo_list/app/data/model/task.dart';
import 'package:getx_todo_list/app/data/providers/task/provider.dart';

class TaskRepository {
  TaskProvider taskProvider;
  TaskRepository({
    required this.taskProvider,
  });

  List<Task> readTasks() => TaskProvider().readTask();
  void writeTask(List<Task> tasks) => TaskProvider().writeTask(tasks);
}
