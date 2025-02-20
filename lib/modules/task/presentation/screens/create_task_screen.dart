import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/constance_manger.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/modules/task/presentation/screens/custom_widgets/create_task_appbar.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleController = TextEditingController();
  String? _selectedWorker;
  DateTime? _dueDate;
  final List<String> _workers = [
    'Worker 1',
    'Worker 2',
    'Worker 3'
  ]; // Replace with your list of workers

  @override
  void dispose() {
    _taskTitleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilt");
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
                    _buildTaskDescriptionField(),
                    _buildWorkerDropdown(),
                    _buildDueDateSelector(context),
                    DefaultButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                      text: "Submit Task",
                      textColor: ColorManager.white,
                      icon: Padding(
                        padding: EdgeInsetsDirectional.only(end: 1.w),
                        child: Icon(Icons.check, color: Colors.white, size: 16),
                      ),
                    ),
                    DefaultButton(
                      onPressed: () {
                        context.pop();
                      },
                      text: "Cancel",
                      textColor: ColorManager.grey,
                      color: ColorManager.grey
                          .withValues(red: 20, green: 20, blue: 20),
                    ),
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

  Widget _buildTaskDescriptionField() {
    return TextFormField(
      controller: _taskTitleController,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: 'Task Description',
        hintText: 'Enter task title',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter task title';
        }
        return null;
      },
    );
  }

  Widget _buildWorkerDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedWorker,
      decoration: InputDecoration(
        labelText: 'Select Worker',
        hintText: 'Choose a worker',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: _workers.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedWorker = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a worker';
        }
        return null;
      },
    );
  }

  Widget _buildDueDateSelector(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Due Date',
          hintText: 'Select date',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          _dueDate == null
              ? 'Select date'
              : ConstanceManger.formatDateTime(_dueDate!),
        ),
      ),
    );
  }
}
