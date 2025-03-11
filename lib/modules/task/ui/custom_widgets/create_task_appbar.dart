import 'package:flutter/material.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';

class TaskAppbar extends StatelessWidget {
  final String title;
  const TaskAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      shadowColor: ColorManager.grey,
      backgroundColor: ColorManager.white,
      title: Text(title,
          style: TextStyle(color: ColorManager.primary)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: ColorManager.primary,
        ),
        onPressed: () => context.pop(),
      ),
    );
  }
}
