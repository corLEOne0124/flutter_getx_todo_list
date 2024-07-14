import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_todo_list/app/core/utils/extensions.dart';
import 'package:getx_todo_list/app/data/model/task.dart';
import 'package:getx_todo_list/app/models/detail/view.dart';
import 'package:getx_todo_list/app/models/home/controller.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TaskCard extends StatelessWidget {
  TaskCard({super.key, required this.task});
  final Task task;
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    final squareWidth = Get.width - 12.0.wp;
    final color = HexColor.fromHex(task.color);
    return GestureDetector(
      onTap: () {
        homeController.changeTask(task);
        homeController.changeTodos(task.todos ?? []);
        Get.to(DetailPage());
      },
      child: Container(
        width: squareWidth / 2,
        height: squareWidth / 2,
        margin: EdgeInsets.all(3.0.wp),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 7,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepProgressIndicator(
              totalSteps:
                  homeController.isTodoEmpty(task) ? 1 : task.todos!.length,
              currentStep: homeController.isTodoEmpty(task)
                  ? 0
                  : homeController.getDoneTodo(task),
              size: 5,
              padding: 0,
              selectedGradientColor: LinearGradient(
                colors: [color.withOpacity(0.5), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              unselectedGradientColor: const LinearGradient(
                colors: [Colors.grey, Colors.grey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.0.wp),
              child: Icon(
                color: color,
                IconData(
                  task.icon,
                  fontFamily: 'MaterialIcons',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6.0.wp),
              child: Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 1.0.wp,
                  ),
                  Text(
                    '${task.todos?.length ?? 0} Task',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
