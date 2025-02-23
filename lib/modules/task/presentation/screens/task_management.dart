import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/constance_manger.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';
import 'package:tasks_admin/modules/task/presentation/cubit/task_cubit.dart';
import 'package:tasks_admin/modules/task/presentation/screens/create_task_screen.dart';
import 'package:tasks_admin/modules/task/presentation/screens/custom_widgets/filter_button.dart';
import 'package:tasks_admin/modules/task/presentation/screens/custom_widgets/voice_builder.dart';
import 'package:tasks_admin/modules/task/presentation/screens/dummy_data/dummy_data.dart';
import 'package:tasks_admin/modules/task/presentation/screens/edit_task_screen.dart';
import 'package:tasks_admin/modules/task/presentation/screens/custom_widgets/main_appbar.dart';

import 'custom_widgets/image_builder.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  TaskStatus filterSelected = TaskStatus.all;
  late TaskCubit taskCubit = context.read<TaskCubit>();

  List<TaskModel> tasks = [], filteredTasks = [];

  @override
  void initState() {
    tasks = DummyTasks.getTasks();
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
            onSearched: (value) {},
            hintText: S.of(context).search_tasks,
          ),
          Expanded(
            child: BlocConsumer<TaskCubit, TaskState>(
              listenWhen: (previous, current) => current is ShowDeleteDialog,
              listener: (context, state) {
                if (state is ShowDeleteDialog) {
                  _showDeleteDialog(state.taskId);
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
                      task.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      getTaskStatusLanguage(task.status,context),
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
              SizedBox(height: 2.h),
              if (task.imagesUrl.isNotEmpty)
                Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 2.h),
                  child: ImageBuilder(imagesUrl: task.imagesUrl),
                ),
              if (task.voiceUrl != null)
                AudioPlayerBuilder(audioUrl: task.voiceUrl!
                    // 'https://firebasestorage.googleapis.com/v0/b/masheed-d942d.appspot.com/o/audios%2FZVSbJCtVxaTg8xKr1202XUwFNrH2%2Faudio6565445721400773739.m4a?alt=media&token=4bce69e7-3a88-4282-a155-dd5b09fd9c5c',
                    ),
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
                    onPressed: () => context.push(EditTaskScreen(
                      task: task,
                    )),
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

  void _showDeleteDialog(String taskId) {
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
              taskCubit.deleteTask(taskId);
              context.pop();
            },
          ),
        ],
      ),
    );
  }

}
