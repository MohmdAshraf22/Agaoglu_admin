part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();
}

final class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

final class UserErrorState extends UserState {
  final Exception exception;
  const UserErrorState(this.exception);
  @override
  List<Object> get props => [exception];
}

final class LoginLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

final class LoginSuccessState extends UserState {
  final Admin admin;
  const LoginSuccessState(this.admin);
  @override
  List<Object> get props => [admin];
}

final class ResetPasswordSuccessState extends UserState {
  @override
  List<Object> get props => [];
}

final class ResetPasswordLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

final class GetWorkersLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

final class GetWorkersSuccessState extends UserState {
  final List<Worker> workers;
  const GetWorkersSuccessState(this.workers);
  @override
  List<Object> get props => [workers];
}

final class AddWorkerLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

final class AddWorkerSuccessState extends UserState {
  final Worker worker;
  const AddWorkerSuccessState(this.worker);
  @override
  List<Object> get props => [];
}

final class UpdateWorkerLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

final class UpdateWorkerSuccessState extends UserState {
  final Worker worker;
  const UpdateWorkerSuccessState(this.worker);
  @override
  List<Object> get props => [];
}

final class DeleteWorkerLoadingState extends UserState {
  final String workerId;
  const DeleteWorkerLoadingState(this.workerId);
  @override
  List<Object> get props => [workerId];
}

final class DeleteWorkerSuccessState extends UserState {
  final String workerId;
  const DeleteWorkerSuccessState(this.workerId);
  @override
  List<Object> get props => [workerId];
}

final class LogoutLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

final class LogoutSuccessState extends UserState {
  @override
  List<Object> get props => [];
}

class ChangePasswordAppearanceState extends UserState {
  final bool isPasswordVisible;
  const ChangePasswordAppearanceState(this.isPasswordVisible);
  @override
  List<Object> get props => [isPasswordVisible];
}

class SearchWorkersState extends UserState {
  final List<Worker> workers;
  const SearchWorkersState(this.workers);
  @override
  List<Object> get props => [workers];
}
