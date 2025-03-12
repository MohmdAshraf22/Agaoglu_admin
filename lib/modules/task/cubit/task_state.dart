part of 'task_cubit.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskInitial extends TaskState {}

/// Get Task

final class GetTaskLoading extends TaskState {}

final class GetTaskLoaded extends TaskState {
  final List<TaskModel> tasks;

  const GetTaskLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

final class GetTaskError extends TaskState {
  final Exception errorMessage;

  const GetTaskError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

/// Delete Task
final class DeleteTaskLoading extends TaskState {}

final class DeleteTaskSuccess extends TaskState {}

final class DeleteTaskError extends TaskState {
  final Exception errorMessage;

  const DeleteTaskError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

/// Update Task
final class UpdateTaskLoading extends TaskState {}

final class UpdateTaskSuccess extends TaskState {}

final class UpdateTaskError extends TaskState {
  final Exception errorMessage;

  const UpdateTaskError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

/// Create Task
final class CreateTaskLoading extends TaskState {}

final class CreateTaskSuccess extends TaskState {}

final class CreateTaskError extends TaskState {
  final Exception errorMessage;

  const CreateTaskError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

/// Delete file
final class DeleteFileLoading extends TaskState {}

final class DeleteFileSuccess extends TaskState {
  final String url;

  const DeleteFileSuccess(this.url);
}

final class DeleteFileError extends TaskState {
  final Exception errorMessage;

  const DeleteFileError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

/// Upload file
final class UploadFileLoading extends TaskState {}

final class UploadFileSuccess extends TaskState {
  final String downloadUrl;
  final String storagePath;

  const UploadFileSuccess(
      {required this.downloadUrl, required this.storagePath});
}

final class UploadFileError extends TaskState {
  final Exception errorMessage;

  const UploadFileError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class FilterTaskByStatus extends TaskState {
  final TaskStatus status;
  final List<TaskModel> tasks;

  const FilterTaskByStatus(this.status, this.tasks);

  @override
  List<Object> get props => [status, tasks];
}

final class ShowDeleteDialog extends TaskState {
  final TaskModel task;

  const ShowDeleteDialog(this.task);

  @override
  List<Object> get props => [task];
}

final class SelectDateTimeState extends TaskState {
  final DateTime dateTime;

  const SelectDateTimeState(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

final class SelectWorkerState extends TaskState {
  final Worker workerId;

  const SelectWorkerState(this.workerId);

  @override
  List<Object> get props => [workerId];
}

final class CloseDeleteDialog extends TaskState {}

final class MediaImageSelected extends TaskState {
  final List<File> selectedImages;

  const MediaImageSelected(this.selectedImages);

  @override
  List<Object> get props => [selectedImages];
}

final class ImagesUrlState extends TaskState {
  final List<String> imagesUrl;

  const ImagesUrlState(this.imagesUrl);

  @override
  List<Object> get props => [imagesUrl];
}

final class IsPressedRecordingState extends TaskState {
  final bool isPressedRecording;

  const IsPressedRecordingState(this.isPressedRecording);

  @override
  List<Object> get props => [isPressedRecording];
}

final class CompleteRecordingState extends TaskState {}

class SearchTasksState extends TaskState {
  final List<TaskModel> tasks;

  const SearchTasksState(this.tasks);

  @override
  List<Object> get props => [tasks];
}
