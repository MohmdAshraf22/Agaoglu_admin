import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/text_styles_manager.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/main/cubit/dashboard_cubit.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';
import 'package:tasks_admin/modules/task/ui/screens/task_management.dart';
import 'package:tasks_admin/modules/task/ui/screens/task_management_view.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late final DashboardCubit cubit = context.read<DashboardCubit>();

  @override
  void initState() {
    cubit.getDashboardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ), // Responsive padding
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 4.h),
              BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  return Skeletonizer(
                    enabled: state is DashboardDetailsLoading,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildStats(),
                        SizedBox(height: 4.h),
                        Text(
                          S.of(context).recentTasks,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp, // Responsive font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        _buildTaskList(),
                        SizedBox(height: 4.h),
                        _buildButtons(),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 6.w, // Responsive radius
          backgroundImage: AssetImage(
              'assets/icons/admin_panel_icon.png'), // Replace with your image
        ),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              S.of(context).welcomeBack,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
            Text(
              S.of(context).adminDashboard,
              style: TextStylesManager.authTitle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildStatCard('156', S.of(context).totalWorkers, Icons.people),
        _buildStatCard('43', S.of(context).pendingTasks, Icons.list),
        _buildStatCard('289', S.of(context).completedTasks, Icons.check_circle),
      ]
          .expand(
            (element) => [
              SizedBox(
                width: 2.w,
              ),
              element
            ],
          )
          .toList(),
    );
  }

  Widget _buildStatCard(String count, String label, IconData icon) {
    return Expanded(
      child: SemiTransparentContainer(
        height: 18.h,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Icon(icon, color: Colors.white, size: 8.w)),
              Expanded(
                child: Text(
                  count,
                  style: TextStylesManager.authTitle,
                ),
              ),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ]
                .expand(
                  (element) => [SizedBox(height: 1.h), element],
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return SizedBox(
      height: 15.h,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          width: 4.w,
        ),
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => _buildTaskCard('Website Redesign',
            'John Smith', TaskStatus.cancelled, 'Dec 15, 2023'),
      ),
    );
  }

  Widget _buildTaskCard(
    String title,
    String assignedTo,
    TaskStatus status,
    String date,
  ) {
    return SemiTransparentContainer(
      width: 60.w,
      height: 15.h,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStylesManager.authTitle.copyWith(
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 1.h),
            Text('Assigned to: $assignedTo',
                style:
                    TextStyle(color: ColorManager.greyLight, fontSize: 13.sp)),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: getStatusColor(status),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(getTaskStatusLanguage(status, context),
                      style: TextStyle(
                          color: ColorManager.white, fontSize: 12.sp)),
                ),
                Text(date,
                    style:
                        TextStyle(color: ColorManager.white, fontSize: 12.sp)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: DefaultButton(
              text: "View Workers ",
              onPressed: () {
                context.push(TaskManagementView());
              }),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: DefaultButton(
              text: "View Tasks ",
              onPressed: () {
                context.push(TaskManagementScreen());
              }),
        ),
      ],
    );
  }
}
