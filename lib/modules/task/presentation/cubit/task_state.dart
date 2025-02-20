part of 'task_cubit.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

final class TaskError extends TaskState {
  final String errorMessage;

  const TaskError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

/// Get Task
final class GetTaskLoading extends TaskState {}

final class GetTaskSuccess extends TaskState {}

final class GetTaskError extends TaskState {
  final String errorMessage;

  const GetTaskError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

/// Delete Task
final class DeleteTaskLoading extends TaskState {}

final class DeleteTaskSuccess extends TaskState {}

final class DeleteTaskError extends TaskState {
  final String errorMessage;

  const DeleteTaskError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

/// Update Task
final class UpdateTaskLoading extends TaskState {}

final class UpdateTaskSuccess extends TaskState {}

final class UpdateTaskError extends TaskState {
  final String errorMessage;

  const UpdateTaskError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

/// Create Task
final class CreateTaskLoading extends TaskState {}

final class CreateTaskSuccess extends TaskState {}

final class CreateTaskError extends TaskState {
  final String errorMessage;

  const CreateTaskError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class FilterTaskByStatus extends TaskState {
  final TaskStatus status;

  const FilterTaskByStatus(this.status);
}
