import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';

class TaskManagementAppBar extends StatelessWidget {
  const TaskManagementAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorManager.primary,
      elevation: 0,
      titleSpacing: 1,
      title: Text(
        'Task Management',
        style: TextStyle(
          color: ColorManager.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Container(
          width: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorManager.orange,
          ),
          child: IconButton(
            icon: Icon(Icons.add),
            color: ColorManager.white,
            onPressed: () {
              // Handle add task
            },
          ),
        ),
      ],
    );
  }
}
