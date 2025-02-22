import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/task/presentation/cubit/task_cubit.dart';
import 'package:tasks_admin/modules/task/presentation/screens/custom_widgets/voice_builder.dart';

class MediaSelectionBuilder extends StatelessWidget {
  const MediaSelectionBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return _MediaSelectionContent();
  }
}

class _MediaSelectionContent extends StatefulWidget {
  @override
  State<_MediaSelectionContent> createState() => _MediaSelectionContentState();
}

class _MediaSelectionContentState extends State<_MediaSelectionContent> {
  late final TaskCubit cubit = context.read<TaskCubit>();
  bool isPressedRecording = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).additional_files,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            color: ColorManager.greyLight,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMediaButton(
                icon: Icons.add_circle_outline,
                label: S.of(context).add_image,
                onPressed: () => cubit.pickImage(),
              ),
              _buildMediaButton(
                icon: Icons.mic_none_outlined,
                label: S.of(context).add_voice,
                onPressed: () => cubit.pressRecordingButton(isPressedRecording),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              print(state);

              if (state is IsPressedRecordingState) {
                isPressedRecording = state.isPressedRecording;
              }
              return isPressedRecording ? AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                switchInCurve: Curves.bounceInOut,
                child: VoiceBuilder(
                  onRecordComplete: (value) {
                    cubit.completeRecording(value!.path);
                  },
                ),
              )
                  : const SizedBox.shrink();
            },
          ),
        SizedBox(height: 2.h),
        BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is MediaImageSelected) {
              return _buildSelectedImages(state.selectedImages);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 3.5.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DashedCircle(
              radius: 32,
              iconData: icon,
            ),
            SizedBox(height: 1.h),
            Text(label, style: const TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImages(List<File> images) {
    return SizedBox(
      height: 20.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Image.file(
              width: 30.w,
              images[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

class DashedCircle extends StatelessWidget {
  final double radius;
  final IconData iconData;
  final double iconSize;

  const DashedCircle({
    super.key,
    required this.radius,
    required this.iconData,
    this.iconSize = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorManager.white,
          ),
          child: CustomPaint(
            size: Size(radius * 2, radius * 2),
            painter: DashedCirclePainter(
              radius: radius,
              dashWidth: 4,
              dashSpace: 3,
            ),
          ),
        ),
        Icon(
          iconData,
          size: iconSize,
          color: ColorManager.primary,
        ),
      ],
    );
  }
}
