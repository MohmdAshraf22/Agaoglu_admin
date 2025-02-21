import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/constance_manger.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';
import 'package:tasks_admin/modules/task/presentation/cubit/task_cubit.dart';
import 'package:tasks_admin/modules/task/presentation/screens/custom_widgets/filter_button.dart';
import 'package:tasks_admin/modules/task/presentation/screens/dummy_data/dummy_data.dart';
import 'package:tasks_admin/modules/task/presentation/screens/edit_task_screen.dart';
import 'package:tasks_admin/modules/task/presentation/screens/custom_widgets/task_management_appbar.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  TaskStatus filterSelected = TaskStatus.all;
  late TaskCubit taskCubit;
  List<Task> tasks = DummyTasks.getTasks();
  List<Task> filteredTasks = [];

  @override
  void initState() {
    taskCubit = context.read<TaskCubit>();
    taskCubit.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TaskManagementAppBar(),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: ColorManager.white,
                ),
                hintText: 'Search tasks...',
                hintStyle: TextStyle(
                  color: ColorManager.white,
                ),
                fillColor: ColorManager.grey.withValues(alpha: 0.2),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: BlocConsumer<TaskCubit, TaskState>(
                listener: (context, state) {
                  if (state is ShowDeleteDialog) {
                    _showDeleteDialog(context, state.taskId);
                  }
                },
                builder: (context, state) {
                  if (state is TaskLoaded) {
                    filteredTasks = state.tasks;
                    tasks = state.tasks;
                  } else if (state is TaskError) {
                    tasks.clear();
                    filteredTasks.clear();
                  } else if (state is FilterTaskByStatus) {
                    filterSelected = state.status;
                    filteredTasks = state.tasks;
                  }
                  return Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: TaskStatus.values
                              .map((status) => FilterButton(
                                    status: status,
                                    isSelected: filterSelected == status,
                                    onPressed: () => taskCubit
                                        .filterTasksByStatus(status, tasks),
                                  ))
                              .toList(),
                        ),
                      ),
                      Expanded(
                        child: Skeletonizer(
                          enabled: state is TaskLoading,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>
                                _buildTaskCard(filteredTasks[index]),
                            itemCount: filteredTasks.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Padding(
          padding:
              EdgeInsetsDirectional.symmetric(horizontal: 4.w, vertical: 1.5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.description,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: .7.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(task.status),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      task.status.name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: task.workerPhoto == null
                        ? null
                        : NetworkImage(task.workerPhoto!),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    task.workerName ?? "Not Accepted yet",
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 2.w),
                      Text(
                        ConstanceManger.formatDateTime(task.createdAt),
                      ),
                    ],
                  ),
                  Spacer(),
                  _deleteEditTask(
                    color: ColorManager.red,
                    icon: Icons.delete,
                    onPressed: () => taskCubit.showDeleteDialog(task.id),
                  ),
                  SizedBox(width: 2.w),
                  _deleteEditTask(
                    color: ColorManager.orange,
                    icon: Icons.edit,
                    onPressed: () => context.push(EditTaskScreen()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _deleteEditTask({
    required Color color,
    required IconData icon,
    required void Function() onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: ColorManager.white,
          size: 20,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return ColorManager.yellow;
      case TaskStatus.approved:
        return ColorManager.green;
      case TaskStatus.inProgress:
        return ColorManager.blue;
      case TaskStatus.cancelled:
        return ColorManager.red;
      case TaskStatus.completed:
        return ColorManager.grey;
      default:
        return Colors.transparent;
    }
  }

  void _showDeleteDialog(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => context.pop(),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              taskCubit.deleteTask(taskId);
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
