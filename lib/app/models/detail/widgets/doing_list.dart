import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_todo_list/app/core/utils/extensions.dart';
import 'package:getx_todo_list/app/models/home/controller.dart';

class DoingList extends StatelessWidget {
  DoingList({super.key});
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          homeController.doingTodos.isEmpty && homeController.doneTodos.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/task.jpg',
                      fit: BoxFit.cover,
                      width: 65.0.wp,
                    ),
                    Text(
                      'Add Task',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              : ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    ...homeController.doingTodos.map(
                      (element) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.0.wp,
                          horizontal: 9.0.wp,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: Checkbox(
                                fillColor: WidgetStateProperty.resolveWith(
                                  (states) => Colors.white,
                                ),
                                value: element['done'],
                                onChanged: (value) {
                                  homeController.doneTodo(element['title']);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.0.wp,
                              ),
                              child: Text(
                                element['title'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (homeController.doingTodos.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                        child: const Divider(
                          thickness: 2,
                        ),
                      ),
                  ],
                ),
    );
  }
}
