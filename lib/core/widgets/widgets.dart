import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';

class SemiTransparentContainer extends StatelessWidget {
  final double opacity;
  final Widget child;
  final double height;
  final double width;
  final double borderRadius;

  const SemiTransparentContainer(
      {super.key,
      this.opacity = 0.4,
      this.borderRadius = 20,
      required this.child,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: ColorManager.white.withOpacity(opacity),
      ),
      child: child,
    );
  }
}

class DefaultButton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color color;
  final String text;
  final Color textColor;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool? isLoading;

  const DefaultButton({
    super.key,
    this.height,
    this.width,
    this.color = ColorManager.orange,
    required this.text,
    this.textColor = ColorManager.white,
    this.icon,
    required this.onPressed,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isLoading == true
              ? [
                  Center(
                    child: CircularProgressIndicator(
                      color: textColor,
                    ),
                  ),
                ]
              : [
                  if (icon != null) icon!,
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final int? maxLines;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;

  const DefaultTextField(
      {super.key,
      required this.controller,
      this.maxLines,
      this.labelText,
      this.hintText,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        fillColor: ColorManager.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorManager.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorManager.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: ColorManager.grey,
          ),
        ),
      ),
      validator: validator,
    );
  }
}

////
class DashedCirclePainter extends CustomPainter {
  final double radius;
  final double dashWidth;
  final double dashSpace;

  DashedCirclePainter({
    required this.radius,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorManager.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // Adjust stroke width as needed

    final center = Offset(size.width / 2, size.height / 2);
    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: radius));

    final dashLength = dashWidth;
    final spaceLength = dashSpace;
    final totalLength = dashLength + spaceLength;
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / totalLength).floor();

    for (int i = 0; i <= dashCount; i++) {
      final startAngle = (i * totalLength / circumference) * 2 * math.pi;
      final endAngle = startAngle + (dashLength / circumference) * 2 * math.pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Repaint only if properties change
  }
}

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded),
          Text(S.of(context).noDataFound),
        ],
      ),
    );
  }
}

Color getStatusColor(TaskStatus status) {
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

String getTaskStatusLanguage(TaskStatus status, BuildContext context) {
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
