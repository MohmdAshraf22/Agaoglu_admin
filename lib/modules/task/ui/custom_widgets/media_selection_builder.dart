import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/task/cubit/task_cubit.dart';
import 'package:tasks_admin/modules/task/ui/custom_widgets/voice_builder.dart';

class MediaSelectionBuilder extends StatelessWidget {
  final List<String> imagesUrl;
  final String? audioUrl;

  const MediaSelectionBuilder(
      {super.key, required this.imagesUrl, this.audioUrl});

  @override
  Widget build(BuildContext context) {
    return _MediaSelectionContent(imagesUrl: imagesUrl, audioUrl: audioUrl);
  }
}

class _MediaSelectionContent extends StatefulWidget {
  final List<String> imagesUrl;
  final String? audioUrl;

  const _MediaSelectionContent({required this.imagesUrl, this.audioUrl});

  @override
  State<_MediaSelectionContent> createState() => _MediaSelectionContentState();
}

class _MediaSelectionContentState extends State<_MediaSelectionContent> {
  late final TaskCubit cubit = context.read<TaskCubit>();
  late bool isPressedRecording = widget.audioUrl != null;

  List<File> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    List<String> imagesUrl = widget.imagesUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).additional_files,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold, //qnb cip
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
            if (state is IsPressedRecordingState) {
              isPressedRecording = state.isPressedRecording;
            }
            return isPressedRecording
                ? AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    switchInCurve: Curves.bounceInOut,
                    child: VoiceBuilder(
                      audioUrl: widget.audioUrl,
                      // "",
                      // 'https://firebasestorage.googleapis.com/v0/b/masheed-d942d.appspot.com/o/audios%2FZVSbJCtVxaTg8xKr1202XUwFNrH2%2Faudio6565445721400773739.m4a?alt=media&token=4bce69e7-3a88-4282-a155-dd5b09fd9c5c',
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
              selectedImages = state.selectedImages;
            }
            return selectedImages.isNotEmpty
                ? _buildSelectedImages(selectedImages, [])
                : const SizedBox.shrink();
          },
        ),
        SizedBox(height: 2.h),
        if (imagesUrl.isNotEmpty)
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state is DeleteFileSuccess) {
                if (imagesUrl.contains(state.url)) {
                  imagesUrl.remove(state.url);
                }
              }
              return _buildSelectedImages([], imagesUrl);
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

  Widget _buildSelectedImages(List<File> imagesFile, List<String> imagesUrl) {
    print("%%%%%%%%%%%%%%%%%%%");
    print(imagesUrl);
    print(imagesFile);
    print("%%%%%%%%%%%%%%%%%%%");
    return SizedBox(
      height: 20.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagesUrl.isEmpty ? imagesFile.length : imagesUrl.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: imagesUrl.isEmpty
                    ? Image.file(
                        width: 30.w,
                        imagesFile[index],
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        width: 30.w,
                        imagesUrl[index],
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    if (imagesUrl.isEmpty) {
                      cubit.deleteImageFile(imagesFile[index]);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.7),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 4.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
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
