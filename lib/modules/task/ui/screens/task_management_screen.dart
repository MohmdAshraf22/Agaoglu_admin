import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/error/exception_manager.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/constance_manger.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';
import 'package:tasks_admin/modules/task/cubit/task_cubit.dart';
import 'package:tasks_admin/modules/task/ui/screens/create_task_screen.dart';
import 'package:tasks_admin/modules/task/ui/custom_widgets/filter_button.dart';
import 'package:tasks_admin/modules/task/ui/custom_widgets/voice_builder.dart';
import 'package:tasks_admin/modules/task/ui/custom_widgets/image_builder.dart';
import 'package:tasks_admin/modules/task/ui/screens/edit_task_screen.dart';
import 'package:tasks_admin/modules/task/ui/custom_widgets/main_appbar.dart';

class TaskManagementScreen extends StatefulWidget {
  final List<TaskModel> tasks;

  const TaskManagementScreen({super.key, required this.tasks});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  TaskStatus filterSelected = TaskStatus.all;
  late TaskCubit taskCubit = context.read<TaskCubit>();

  List<TaskModel> tasks = [], filteredTasksByStatus = [], filteredTasks = [];

  @override
  void initState() {
    tasks = widget.tasks;
    taskCubit.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainAppBar(
            title: S.of(context).task_management,
            onAdd: () {
              context.push(CreateTaskScreen());
            },
            onSearched: (value) {
              taskCubit.searchTasks(value, filteredTasksByStatus);
            },
            hintText: S.of(context).search_tasks,
          ),
          Expanded(
            child: BlocConsumer<TaskCubit, TaskState>(
              listenWhen: (previous, current) => current is ShowDeleteDialog,
              listener: (context, state) {
                if (state is ShowDeleteDialog) {
                  _showDeleteDialog(state.task);
                }
              },
              builder: (context, state) {
                _handleBuildState(state);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
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
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              _buildTaskCard(filteredTasks[index]),
                          itemCount: filteredTasks.length,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return Card(
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
                    task.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 1.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: .7.h),
                  decoration: BoxDecoration(
                    color: getStatusColor(task.status),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    getTaskStatusLanguage(task.status, context),
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
                  task.workerName ?? S.of(context).not_accepted_yet,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              task.description,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _getTaskAddressDetails(task),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.h),
            if (task.imagesUrl.isNotEmpty)
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 2.h),
                child: ImageBuilder(imagesUrl: task.imagesUrl),
              ),
            if (task.voiceUrl != null)
              AudioPlayerBuilder(audioUrl: task.voiceUrl!),
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
                  onPressed: () => taskCubit.showDeleteDialog(task),
                ),
                SizedBox(width: 2.w),
                _deleteEditTask(
                  color: ColorManager.orange,
                  icon: Icons.edit,
                  onPressed: () => context.push(EditTaskScreen(
                    task: task,
                  )),
                ),
              ],
            ),
          ],
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

  void _showDeleteDialog(TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).delete_task),
        content: Text(S.of(context).are_you_sure_you_want_to_delete_this_task),
        actions: [
          TextButton(
            child: Text(S.of(context).cancel),
            onPressed: () => context.pop(),
          ),
          TextButton(
            child: Text(S.of(context).delete),
            onPressed: () {
              taskCubit.deleteTask(task);
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  void _handleBuildState(TaskState state) {
    if (state is GetTaskLoaded) {
      filteredTasksByStatus = state.tasks;
      filteredTasks = state.tasks;
      tasks = state.tasks;
    } else if (state is GetTaskError) {
      tasks.clear();
      filteredTasksByStatus.clear();
      filteredTasks.clear();
         ExceptionManager.showMessage(state.errorMessage);
    } else if (state is FilterTaskByStatus) {
      filterSelected = state.status;
      filteredTasksByStatus = state.tasks;
      filteredTasks = state.tasks;
    } else if (state is SearchTasksState) {
      filteredTasks = state.tasks;
    }
  }

  String _getTaskAddressDetails(TaskModel task) {
    List<String> addressParts = [];

    if (task.site?.isNotEmpty ?? false) {
      addressParts.add(task.site!);
    }
    if (task.block?.isNotEmpty ?? false) {
      addressParts.add(task.block!);
    }
    if (task.flat?.isNotEmpty ?? false) {
      addressParts.add(task.flat!);
    }
    return addressParts.join(', ');
  }
}
