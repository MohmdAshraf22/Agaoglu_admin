part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

final class DashboardDetailsLoading extends DashboardState {
  @override
  List<Object?> get props => [];
}

final class DashboardDetailsSuccess extends DashboardState {
  final DashboardDetails dashboardDetails;

  const DashboardDetailsSuccess({required this.dashboardDetails});

  @override
  List<Object?> get props => [dashboardDetails];
}

final class DashboardDetailsError extends DashboardState {
  final String errorMessage;

  const DashboardDetailsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
