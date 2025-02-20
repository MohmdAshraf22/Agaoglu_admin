import 'package:flutter/material.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';

class CreateTaskAppbar extends StatelessWidget {
  const CreateTaskAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      shadowColor: ColorManager.grey,
      backgroundColor: ColorManager.white,
      title: Text('Create Task'),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
