import 'package:flutter/material.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';

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

  const DefaultButton({
    super.key,
    this.height,
    this.width,
    this.color = ColorManager.orange,
    required this.text,
    this.textColor = ColorManager.white,
    this.icon,
    required this.onPressed,
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
          children: [
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
