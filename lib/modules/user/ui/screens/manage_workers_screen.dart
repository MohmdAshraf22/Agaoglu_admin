import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tasks_admin/core/error/exception_manager.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/text_styles_manager.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/task/ui/custom_widgets/main_appbar.dart';
import 'package:tasks_admin/modules/user/cubit/user_cubit.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';
import 'package:tasks_admin/modules/user/ui/dummy_data/dummy_workers.dart';
import 'package:tasks_admin/modules/user/ui/screens/create_worker_screen.dart';
import 'package:tasks_admin/modules/user/ui/screens/edit_worker_screen.dart';

class ManageWorkersScreen extends StatelessWidget {
  const ManageWorkersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Worker> filteredWorkers = [];
    List<Worker> workers = [];

    UserCubit cubit = UserCubit.get()..getWorkers();
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: ColorManager.primary,
      //   elevation: 0,
      //   titleSpacing: 1,
      //   title: Padding(
      //     padding: EdgeInsetsDirectional.only(start: 5.w),
      //     child: Text(
      //       S.of(context).workersManagement,
      //       style: TextStyle(
      //         color: ColorManager.white,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ),
      //   actions: [
      //     Container(
      //       width: 10.w,
      //       margin: EdgeInsetsDirectional.only(end: 5.w),
      //       decoration: BoxDecoration(
      //         shape: BoxShape.circle,
      //         color: ColorManager.orange,
      //       ),
      //       child: IconButton(
      //         icon: Icon(Icons.add),
      //         color: ColorManager.white,
      //         onPressed: () {
      //           context.push(CreateWorkerScreen());
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      backgroundColor: ColorManager.primary,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MainAppBar(
              onSearched: (value) => cubit.searchWorkers(value),
              hintText: S.of(context).searchWorkers,
              onAdd: () {
                context.push(CreateWorkerScreen());
              },
              title: S.of(context).workersManagement,
            ),
            Expanded(
              child: BlocConsumer<UserCubit, UserState>(
                listener: (context, state) {
                  if (state is GetWorkersSuccessState) {
                    filteredWorkers = state.workers;
                    workers = state.workers;
                  } else if (state is UserErrorState) {
                    ExceptionManager.showMessage(state.exception);
                  } else if (state is SearchWorkersState) {
                    filteredWorkers = state.workers;
                  } else if (state is DeleteWorkerSuccessState) {
                    filteredWorkers
                        .removeWhere((element) => element.id == state.workerId);
                    workers
                        .removeWhere((element) => element.id == state.workerId);
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: filteredWorkers.isEmpty &&
                                state is! GetWorkersLoadingState
                            ? NoDataFoundWidget()
                            : Skeletonizer(
                                enabled: state is GetWorkersLoadingState,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) => state
                                          is GetWorkersLoadingState
                                      ? _buildWorkerCard(
                                          dummyWorkers[index], context, cubit)
                                      : _buildWorkerCard(filteredWorkers[index],
                                          context, cubit),
                                  itemCount: state is GetWorkersLoadingState
                                      ? dummyWorkers.length
                                      : filteredWorkers.length,
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerCard(
      Worker worker, BuildContext context, UserCubit cubit) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: SizedBox(
        height: 27.h,
        child: Card(
          elevation: 2,
          color: ColorManager.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.symmetric(vertical: 1.5.h),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
                horizontal: 4.w, vertical: 1.5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 7.w,
                        backgroundImage: worker.imageUrl != null
                            ? NetworkImage(worker.imageUrl!)
                            : AssetImage("assets/images/worker_avatar.png"),
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 3,
                            children: [
                              Text(
                                '${worker.name} ${worker.surname}',
                                style: TextStylesManager.cardTitle,
                              ),
                              FittedBox(
                                child: Text(
                                  worker.job,
                                  style: TextStylesManager.cardText,
                                ),
                              ),
                              FittedBox(
                                child: _buildDetails(
                                    worker.phoneNumber, Icons.phone),
                              ),
                              FittedBox(
                                child: _buildDetails(worker.email, Icons.email),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Skeleton.shade(
                  child: Row(
                    spacing: 2.w,
                    children: [
                      Expanded(
                          child: DefaultButton(
                              color: ColorManager.red,
                              text: S.of(context).delete,
                              onPressed: () {
                                _showDeleteDialog(worker.id, context, cubit);
                              })),
                      Expanded(
                          child: DefaultButton(
                              text: S.of(context).edit,
                              onPressed: () {
                                context.push(EditWorkerScreen(worker: worker));
                              })),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(String title, IconData icon) {
    return Row(
      spacing: 5,
      children: [
        Skeleton.leaf(
          child: Icon(
            icon,
            color: ColorManager.descriptionGrey,
          ),
        ),
        Text(
          title,
          style: TextStylesManager.cardText,
        ),
      ],
    );
  }

  void _showDeleteDialog(String workerId, context, UserCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteWorker),
        content: Text(S.of(context).deleteWorkerConfirmation),
        actions: [
          TextButton(
            child: Text(S.of(context).cancel),
            onPressed: () => context.pop(),
          ),
          BlocConsumer<UserCubit, UserState>(
            listener: (context, state) {
              if (state is DeleteWorkerSuccessState ||
                  state is UserErrorState) {
                context.pop();
              }
            },
            buildWhen: (previous, current) =>
                current is DeleteWorkerLoadingState,
            builder: (context, state) {
              return state is DeleteWorkerLoadingState &&
                      state.workerId == workerId
                  ? CircularProgressIndicator()
                  : TextButton(
                      child: Text(S.of(context).delete),
                      onPressed: () async {
                        cubit.deleteWorker(workerId);
                      },
                    );
            },
          ),
        ],
      ),
    );
  }
}
