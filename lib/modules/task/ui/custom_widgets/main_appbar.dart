import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';

class MainAppBar extends StatelessWidget {
  final String title;
  final String hintText;
  final VoidCallback onAdd;
  final void Function(String)? onSearched;

  const MainAppBar({
    super.key,
    required this.title,
    required this.hintText,
    required this.onSearched,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            end: 4.w,
          ),
          child: AppBar(
            backgroundColor: ColorManager.primary,
            elevation: 0,
            titleSpacing: 1,
            title: Text(
              title,
              style: TextStyle(
                color: ColorManager.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: ColorManager.white,
              onPressed: () => context.pop(),
            ),
            actions: [
              Container(
                width: 10.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.orange,
                ),
                child: IconButton(
                  icon: Icon(Icons.add),
                  color: ColorManager.white,
                  onPressed: onAdd,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
          ),
          child: TextField(
            onChanged: onSearched,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: ColorManager.white,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                color: ColorManager.white,
              ),
              focusColor: ColorManager.white,
              fillColor: ColorManager.grey.withValues(alpha: 0.2),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
