import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getx_todo_list/app/core/utils/extensions.dart';
import 'package:getx_todo_list/app/data/model/task.dart';
import 'package:getx_todo_list/app/models/home/controller.dart';
import 'package:getx_todo_list/app/models/home/widgets/add_card.dart';
import 'package:getx_todo_list/app/models/home/widgets/add_dialog.dart';
import 'package:getx_todo_list/app/models/home/widgets/task_card.dart';
import 'package:getx_todo_list/app/models/report/view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.0.wp),
                    child: Text(
                      'My List',
                      style: TextStyle(
                        fontSize: 24.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(
                    () => GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        ...controller.tasks.map(
                          (task) => LongPressDraggable(
                            data: task,
                            onDragStarted: () =>
                                controller.changeDeleting(true),
                            onDraggableCanceled: (velocity, offset) =>
                                controller.changeDeleting(false),
                            onDragEnd: (details) =>
                                controller.changeDeleting(false),
                            feedback: Opacity(
                              opacity: 0.8,
                              child: TaskCard(task: task),
                            ),
                            child: TaskCard(task: task),
                          ),
                        ),
                        AddCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ReportPage(),
          ],
        ),
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (context, candidateData, rejectedData) {
          return Obx(
            () => FloatingActionButton(
              backgroundColor:
                  controller.deleting.value ? Colors.red : Colors.blue,
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(
                    AddDialog(),
                    transition: Transition.downToUp,
                  );
                } else {
                  EasyLoading.showInfo('Please ccreate your task type');
                }
              },
              child: Icon(
                controller.deleting.value ? Icons.delete : Icons.add,
              ),
            ),
          );
        },
        onAccept: (task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess('Delete success');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: Obx(
          ()=> BottomNavigationBar(
            onTap: (int value) => controller.changeTabIndex(value),
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(right: 15.0.wp),
                  child: const Icon(
                    Icons.apps,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(left: 15.0.wp),
                  child: const Icon(
                    Icons.data_usage,
                  ),
                ),
                label: 'Report',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
