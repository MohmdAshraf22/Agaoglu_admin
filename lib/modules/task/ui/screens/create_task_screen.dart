import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tasks_admin/core/error/exception_manager.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/constance_manger.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';
import 'package:tasks_admin/modules/task/cubit/task_cubit.dart';
import 'package:tasks_admin/modules/task/ui/custom_widgets/create_task_appbar.dart';
import 'package:tasks_admin/modules/task/ui/custom_widgets/location_builder.dart';
import 'package:tasks_admin/modules/task/ui/custom_widgets/media_selection_builder.dart';
import 'package:tasks_admin/modules/user/cubit/user_cubit.dart';
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
  String? _site, _block, _flat;
  List<String> imagesUrl = [];
  String? audioUrl;
  late final TaskCubit taskCubit;
  Worker? _selectedWorker;
  String? _selectedJob;
  List<Worker> _workers = [], _filteredWorkers = [];
  List<String> _jobs = [];
  DateTime? _dueDate;

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  initState() {
    taskCubit = context.read<TaskCubit>();
    context.read<UserCubit>().getWorkers();
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
          TaskAppbar(
            title: S.of(context).create_task,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTaskTitleField(),
                    _buildTaskDescriptionField(),
                    _buildJobDropdown(),
                    _buildWorkerDropdown(),
                    _buildDueDateSelector(),
                    LocationBuilder(
                      block: _block,
                      flat: _flat,
                      site: _site,
                    ),
                    MediaSelectionBuilder(
                      imagesUrl: [],
                      taskId: '',
                    ),
                    BlocConsumer<TaskCubit, TaskState>(
                      listener: (context, state) {
                        if (state is CreateTaskSuccess) {
                          context.pop();
                        } else if (state is CreateTaskError) {
                          ExceptionManager.showMessage(state.errorMessage);
                        } else if (state is UploadFileError) {
                          ExceptionManager.showMessage(state.errorMessage);
                        } else if (state is SelectLocationState) {
                          if (state.type == LocationType.block) {
                            _block = state.location;
                          } else {
                            _flat = state.location;
                          }
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
                                  block: _block,
                                  flat: _flat,
                                  site: _site,
                                  workerId: _selectedWorker?.id,
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

  Widget _buildJobDropdown() {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is SelectWorkerJobState) {
          _filterWorkersByJob(state.job);
        }
        return DropdownButtonFormField(
          value: _selectedJob,
          decoration: InputDecoration(
            labelText: S.of(context).select_job,
            hintText: S.of(context).select_job,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          items: _jobs.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? job) {
            if (job == null) return;
            taskCubit.selectWorkerJob(job);
          },
          validator: (value) {
            if (value == null) {
              return S.of(context).please_select_a_job;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildWorkerDropdown() {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is GetWorkersSuccessState) {
          _workers = state.workers;
          _jobs = state.workers.map((worker) => worker.job).toSet().toList();
          if (_selectedJob != null) {
            _filterWorkersByJob(_selectedJob);
          }
        }
        return BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is SelectWorkerState) {
              _selectedWorker = state.workerId;
            }
            return DropdownButtonFormField(
              value: _selectedWorker,
              decoration: InputDecoration(
                labelText: S.of(context).select_worker,
                hintText: S.of(context).choose_a_worker,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _filteredWorkers
                  .map<DropdownMenuItem<Worker>>((Worker value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
              onChanged: (Worker? newValue) {
                if (newValue == null) return;
                taskCubit.selectWorker(newValue);
              },
              validator: (value) {
                if (value == null && _filteredWorkers.isNotEmpty) {
                  return S.of(context).please_select_a_worker;
                }
                return null;
              },
              disabledHint: Text(_selectedJob == null
                  ? S.of(context).select_job_first
                  : _filteredWorkers.isEmpty
                      ? S.of(context).no_workers_for_job
                      : S.of(context).choose_a_worker),
            );
          },
        );
      },
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

  void _filterWorkersByJob(String? selectedJob) {
    _selectedWorker = null;
    _filteredWorkers =
        _workers.where((worker) => worker.job == selectedJob).toList();
  }
}
