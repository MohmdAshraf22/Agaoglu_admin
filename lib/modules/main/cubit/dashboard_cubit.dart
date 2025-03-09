import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_admin/core/utils/firebase_result_handler.dart';
import 'package:tasks_admin/modules/main/data/models/dashboard_details.dart';
import 'package:tasks_admin/modules/main/data/repository/dashboard_repo.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());
  final DashboardRepo _dashboardRepo = DashboardRepo();

  Future<void> getDashboardDetails() async {
    emit(DashboardDetailsLoading());
    final result = await _dashboardRepo.getDashboardDetails();
    if (result is Success<DashboardDetails>) {
      emit(DashboardDetailsSuccess(dashboardDetails: result.data));
    } else if (result is Error<DashboardDetails>) {
      emit(DashboardDetailsError(errorMessage: result.exception));
    }
  }
}
