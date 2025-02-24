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
import 'package:tasks_admin/modules/task/presentation/screens/custom_widgets/create_task_appbar.dart';
import 'package:tasks_admin/modules/task/presentation/screens/custom_widgets/location_builder.dart';
import 'package:tasks_admin/modules/task/presentation/screens/custom_widgets/media_selection_builder.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _siteController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _flatController = TextEditingController();
  List<String> imagesUrl = [];
  String? audioUrl;
  late final TaskCubit taskCubit;
  Worker? _selectedWorker;
  DateTime? _dueDate;
  final List<Worker> _workers = [
    Worker(
      imageUrl: null,
      id: "id",
      name: "name",
      email: "email",
      job: "job",
      surname: "surname",
      phoneNumber: "phoneNumber",
    )
  ];

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  initState() {
    taskCubit = context.read<TaskCubit>();
    super.initState();
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Column(
        children: [
          const CreateTaskAppbar(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTaskTitleField(),
                    _buildTaskDescriptionField(),
                    _buildWorkerDropdown(),
                    _buildDueDateSelector(),
                    LocationBuilder(
                      blockController: _blockController,
                      flatController: _flatController,
                      siteController: _siteController,
                    ),
                    MediaSelectionBuilder(
                      imagesUrl: [],
                    ),
                    BlocConsumer<TaskCubit, TaskState>(
                      listener: (context, state) {
                        if (state is UploadFileSuccess) {
                          if (state.storagePath == "audios") {
                            audioUrl = state.downloadUrl;
                          } else {
                            imagesUrl.add(state.downloadUrl);
                          }
                        } else if (state is CreateTaskSuccess) {
                          context.pop();
                        }
                      },
                      builder: (context, state) {
                        return Skeletonizer(
                          enabled: state is CreateTaskLoading,
                          child: DefaultButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                taskCubit.createTask(TaskModel(
                                  id: "id",
                                  title: _taskTitleController.text,
                                  description: _taskDescriptionController.text,
                                  status: TaskStatus.pending,
                                  createdAt: _dueDate ?? DateTime.now(),
                                  workerName: _selectedWorker?.name,
                                  workerPhoto: _selectedWorker?.imageUrl,
                                  imagesUrl: imagesUrl,
                                  voiceUrl: audioUrl,
                                  block: _blockController.text,
                                  flat: _flatController.text,
                                  site: _siteController.text,
                                ));
                              }
                            },
                            text: S.of(context).submit_task,
                            textColor: ColorManager.white,
                            icon: Padding(
                              padding: EdgeInsetsDirectional.only(end: 1.w),
                              child: Icon(Icons.check,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        );
                      },
                    ),
                    DefaultButton(
                        onPressed: () {
                          context.pop();
                        },
                        text: S.of(context).cancel,
                        textColor: ColorManager.grey,
                        color: ColorManager.greyLight),
                  ]
                      .expand(
                        (element) => [
                          element,
                          SizedBox(height: 2.h),
                        ],
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTitleField() {
    return DefaultTextField(
      controller: _taskTitleController,
      labelText: S.of(context).task_title,
      hintText: S.of(context).enter_task_title,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).please_enter_task_title;
        }
        return null;
      },
    );
  }

  Widget _buildTaskDescriptionField() {
    return DefaultTextField(
      controller: _taskDescriptionController,
      maxLines: 3,
      labelText: S.of(context).task_description,
      hintText: S.of(context).enter_task_description,
    );
  }

  Widget _buildWorkerDropdown() {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is SelectWorkerState) {
          _selectedWorker = state.workerId;
        }
        return DropdownButtonFormField<Worker>(
          value: _selectedWorker,
          decoration: InputDecoration(
            labelText: S.of(context).select_worker,
            hintText: S.of(context).choose_a_worker,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          items: _workers.map<DropdownMenuItem<Worker>>((Worker value) {
            return DropdownMenuItem<Worker>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
          onChanged: (Worker? newValue) {
            if (newValue == null) return;
            taskCubit.selectWorker(newValue);
          },
          validator: (value) {
            if (value == null) {
              return S.of(context).please_select_a_worker;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildDueDateSelector() {
    return BlocBuilder<TaskCubit, TaskState>(
      buildWhen: (previous, current) => current is SelectDateTimeState,
      builder: (context, state) {
        if (state is SelectDateTimeState) {
          _dueDate = state.dateTime;
        }
        return InkWell(
          onTap: () async {
            var picked = await _selectDate(context);
            if (picked != null && picked != _dueDate) {
              taskCubit.selectDateTime(picked);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: S.of(context).due_date,
              hintText: S.of(context).select_date,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            child: Text(
              _dueDate == null
                  ? S.of(context).select_date
                  : ConstanceManger.formatDateTime(_dueDate!),
            ),
          ),
        );
      },
    );
  }
}
