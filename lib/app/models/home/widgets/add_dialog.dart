import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getx_todo_list/app/core/utils/extensions.dart';
import 'package:getx_todo_list/app/models/home/controller.dart';

class AddDialog extends StatelessWidget {
  AddDialog({super.key});
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Form(
          key: homeController.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeController.editController.clear();
                        homeController.changeTask(null);
                      },
                      icon: const Icon(Icons.close),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                      onPressed: () {
                        if (homeController.formKey.currentState!.validate()) {
                          if (homeController.task == null) {
                            EasyLoading.showError(
                                'Please select the task type');
                          } else {
                            var success = homeController.taskUpdate(
                              homeController.task.value!,
                              homeController.editController.text,
                            );
                            if (success) {
                              EasyLoading.showSuccess(
                                  'Todo item added successfully');
                              Get.back();
                              homeController.changeTask(null);
                            } else {
                              EasyLoading.showError('Todo item already exists');
                            }
                            homeController.editController.clear();
                          }
                        }
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 14.0.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: Text(
                  'New Task',
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: TextFormField(
                  controller: homeController.editController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[400]!,
                      ),
                    ),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your todo item';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 5.0.wp,
                  left: 5.0.wp,
                  right: 5.0.wp,
                  bottom: 2.0.wp,
                ),
                child: Text(
                  'Add to',
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
              ...homeController.tasks.map(
                (e) => Obx(
                  () => InkWell(
                    onTap: () {
                      homeController.changeTask(e);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 3.0.wp,
                        horizontal: 5.0.wp,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            IconData(
                              e.icon,
                              fontFamily: 'MaterialIcons',
                            ),
                            color: HexColor.fromHex(
                              e.color,
                            ),
                          ),
                          SizedBox(
                            width: 3.0.wp,
                          ),
                          Text(
                            e.title,
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (homeController.task.value == e)
                            const Icon(
                              Icons.check,
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
