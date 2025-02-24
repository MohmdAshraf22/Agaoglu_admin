import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';

class LocationBuilder extends StatefulWidget {
  final TextEditingController siteController, blockController, flatController;

  const LocationBuilder(
      {super.key,
      required this.siteController,
      required this.blockController,
      required this.flatController});

  @override
  State<LocationBuilder> createState() => _LocationBuilderState();
}

class _LocationBuilderState extends State<LocationBuilder> {
  // @override
  // dispose() {
  //   widget.siteController.dispose();
  //   widget.blockController.dispose();
  //   widget.flatController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: ColorManager.greyLight,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationTitle(),
          SizedBox(height: 1.h),
          _buildLocationField(
              label: S.of(context).add_site, controller: widget.siteController),
          _buildLocationField(
              label: S.of(context).add_block,
              controller: widget.blockController),
          _buildLocationField(
              label: S.of(context).add_flat, controller: widget.flatController),
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: ColorManager.primary,
          ),
        ),
        SizedBox(height: 1.h),
        DefaultTextField(
          controller: controller,
          labelText: label,
        ),
        SizedBox(height: 1.h),
      ],
    );
  }

  Widget _buildLocationTitle() => Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: ColorManager.primary,
          ),
          SizedBox(width: 2.w),
          Text(
            S.of(context).location,
            style: TextStyle(
              fontSize: 18.sp,
              color: ColorManager.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}
