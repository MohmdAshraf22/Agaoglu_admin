import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_admin/modules/task/cubit/task_cubit.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';
import 'package:tasks_admin/modules/task/data/repository/task_repo.dart';
import 'package:tasks_admin/modules/task/ui/screens/task_management_screen.dart';
import 'package:tasks_admin/core/services/service_locator.dart' as di;

class TaskManagementView extends StatelessWidget {
  final List<TaskModel> tasks;

  const TaskManagementView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskCubit>.value(
      value: TaskCubit(di.sl<TaskRepository>()),
      child: TaskManagementScreen(
        tasks: tasks,
      ),
    );
  }
}
