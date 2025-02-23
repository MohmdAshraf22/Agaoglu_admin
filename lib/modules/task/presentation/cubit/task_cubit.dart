import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_admin/core/utils/api_handler.dart';
import 'package:tasks_admin/modules/task/data/repository/task_repo.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';
import '../../data/model/task.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository _taskRepository; // Change

  TaskCubit(this._taskRepository) : super(TaskInitial());

  final ImagePicker _picker = ImagePicker();

  void getTasks() {
    emit(TaskLoading());
    _taskRepository.getTasks().listen(
      (tasks) {
        emit(TaskLoaded(tasks: tasks));
      },
      onError: (error) {
        emit(TaskError(errorMessage: 'Failed to load tasks: $error'));
      },
    );
  }

  Future<void> deleteTask(String taskId) async {
    emit(DeleteTaskLoading());
    final result = await _taskRepository.deleteTask(taskId);
    if (result is Success<bool>) {
      emit(DeleteTaskSuccess());
    } else if (result is Error<bool>) {
      emit(DeleteTaskError(errorMessage: result.errorMessage!));
    }
  }

  Future<void> updateTask(TaskModel task) async {
    emit(UpdateTaskLoading());
    final result = await _taskRepository.updateTask(task);
    if (result is Success<bool>) {
      emit(UpdateTaskSuccess());
    } else if (result is Error<bool>) {
      emit(UpdateTaskError(errorMessage: result.errorMessage!));
    }
  }

  Future<void> createTask(TaskModel task) async {
    emit(CreateTaskLoading());
    final result = await _taskRepository.createTask(task);
    if (result is Success<String>) {
      emit(CreateTaskSuccess());
    } else if (result is Error<String>) {
      emit(CreateTaskError(errorMessage: result.errorMessage!));
    }
  }

  Future<void> uploadFile({
    required File file,
    required String storagePath,
  }) async {
    emit(UploadFileLoading());
    final result = await _taskRepository.uploadFile(
      file: file,
      storagePath: storagePath,
    );
    if (result is Success<String>) {
      emit(UploadFileSuccess(
        downloadUrl: result.data,
        storagePath: storagePath,
      ));
    } else if (result is Error<String>) {
      emit(UploadFileError(errorMessage: result.errorMessage!));
    }
  }

  void filterTasksByStatus(TaskStatus status, List<TaskModel> tasks) {
    if (status == TaskStatus.all) {
      emit(FilterTaskByStatus(status, tasks));
    } else {
      List<TaskModel> filteredTasks =
          tasks.where((task) => task.status == status).toList();
      emit(FilterTaskByStatus(status, filteredTasks));
    }
  }

  void showDeleteDialog(String taskId) {
    emit(ShowDeleteDialog(taskId));
    emit(CloseDeleteDialog());
  }

  void selectWorker(Worker workerId) {
    emit(SelectWorkerState(workerId));
  }

  void selectDateTime(DateTime dateTime) {
    emit(SelectDateTimeState(dateTime));
  }

  List<File> selectedImages = [];

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImages.add(File(image.path));
      // uploadFile(
      //   file: File(image.path),
      //   storagePath: "images",
      // );
      emit(MediaImageSelected(List.from(selectedImages)));
    }
  }

  void pressRecordingButton(bool isPressed) {
    bool isRecording = !isPressed;
    emit(IsPressedRecordingState(isRecording));
  }

  Future<void> completeRecording(String? audioPath) async {
    if (audioPath == null) return;
    await uploadFile(
      file: File(audioPath),
      storagePath: "audios",
    );
    emit(CompleteRecordingState());
  }

  void deleteImageFile(File imageFile) {
    selectedImages.remove(imageFile);
    emit(MediaImageSelected(List.from(selectedImages)));
  }

  Future<void> deleteFile(String url) async {
    emit(DeleteFileLoading());
    final result = await _taskRepository.deleteFile(url);
    if (result is Success<bool>) {
      emit(DeleteFileSuccess(url));
    } else if (result is Error<bool>) {
      emit(DeleteFileError(errorMessage: result.errorMessage!));
    }
  }
}
