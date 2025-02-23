import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';

class FilterButton extends StatefulWidget {
  final TaskStatus status;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.5.w),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.isSelected
              ? ColorManager.orange
              : ColorManager.grey.withAlpha(51),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          _getTaskStatusLanguage(widget.status),
          style: TextStyle(
            color: ColorManager.white,
          ),
        ),
      ),
    );
  }

  String _getTaskStatusLanguage(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return S.of(context).pending;
      case TaskStatus.approved:
        return S.of(context).approved;
      case TaskStatus.inProgress:
        return S.of(context).in_progress;
      case TaskStatus.cancelled:
        return S.of(context).cancelled;
      case TaskStatus.completed:
        return S.of(context).completed;
      case TaskStatus.all:
        return S.of(context).all;
    }
  }
}
