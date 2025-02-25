import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/constance_manger.dart';
import 'package:tasks_admin/core/utils/text_styles_manager.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/main/cubit/dashboard_cubit.dart';
import 'package:tasks_admin/modules/main/data/models/dashboard_details.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';
import 'package:tasks_admin/modules/task/ui/dummy_data/dummy_data.dart';
import 'package:tasks_admin/modules/task/ui/screens/task_management_view.dart';
import 'package:tasks_admin/modules/user/ui/screens/manage_workers_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late final DashboardCubit cubit = context.read<DashboardCubit>();
  late DashboardDetails dashboardDetails;

  @override
  void initState() {
    dashboardDetails = DummyTasks.getDashboardTasks();
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
                  print(state);
                  if (state is DashboardDetailsSuccess) {
                    dashboardDetails = state.dashboardDetails;
                  }
                  return Skeletonizer(
                    enabled: state is DashboardDetailsLoading,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildStats(dashboardDetails),
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
                        _buildTaskList(dashboardDetails),
                        SizedBox(height: 4.h),
                      ],
                    ),
                  );
                },
              ),
              _buildButtons(),
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

  Widget _buildStats(DashboardDetails dashboardDetails) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildStatCard(dashboardDetails.totalWorkers,
            S.of(context).totalWorkers, Icons.people),
        _buildStatCard(dashboardDetails.pendingTasks,
            S.of(context).pendingTasks, Icons.list),
        _buildStatCard(dashboardDetails.completedTasks,
            S.of(context).completedTasks, Icons.check_circle),
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

  Widget _buildStatCard(int count, String label, IconData icon) {
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
                  count.toString(),
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

  Widget _buildTaskList(DashboardDetails dashboardDetails) {
    List<TaskModel> recentTasks = dashboardDetails.tasks.take(5).toList();
    return SizedBox(
      height: 15.h,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          width: 4.w,
        ),
        itemCount: recentTasks.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => _buildTaskCard(recentTasks[index]),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
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
              task.title,
              style: TextStylesManager.authTitle.copyWith(
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 1.h),
            Text('Assigned to: ${task.workerName}',
                style:
                    TextStyle(color: ColorManager.greyLight, fontSize: 13.sp)),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: getStatusColor(task.status),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(getTaskStatusLanguage(task.status, context),
                      style: TextStyle(
                          color: ColorManager.white, fontSize: 12.sp)),
                ),
                Text(ConstanceManger.formatDateTime(task.createdAt),
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
                context.push(ManageWorkersScreen());
              }),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: DefaultButton(
              text: "View Tasks ",
              onPressed: () {
                context.push(TaskManagementView(tasks: dashboardDetails.tasks));
              }),
        ),
      ],
    );
  }
}
