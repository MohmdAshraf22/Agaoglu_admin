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
  @override
  List<Object> get props => [];
}

final class CreateWorkerLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

final class CreateWorkerSuccessState extends UserState {
  @override
  List<Object> get props => [];
}
