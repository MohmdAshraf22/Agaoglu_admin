import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_admin/modules/task/cubit/task_cubit.dart';
import 'package:tasks_admin/modules/task/data/repository/task_repo.dart';
import 'package:tasks_admin/modules/task/ui/screens/task_management.dart';
import 'package:tasks_admin/core/services/service_locator.dart' as di;

class TaskManagementView extends StatelessWidget {
  const TaskManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskCubit>.value(
      value: TaskCubit(di.sl<TaskRepository>()),
      child: TaskManagementScreen(),
    );
  }
}
