import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasks_admin/core/utils/firebase_result_handler.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';
import 'package:tasks_admin/modules/task/data/repository/task_repo.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository _taskRepository; // Change

  TaskCubit(this._taskRepository) : super(TaskInitial());

  final ImagePicker _picker = ImagePicker();

  void getTasks() {
    _taskRepository.getTasks().listen(
      (tasks) {
        emit(GetTaskLoading());
        emit(GetTaskLoaded(tasks: tasks));
      },
      onError: (error) {
        emit(GetTaskError(errorMessage: error));
      },
    );
  }

  Future<void> deleteTask(TaskModel task) async {
    emit(DeleteTaskLoading());
    final result = await _taskRepository.deleteTask(task);
    if (result is Success<bool>) {
      emit(DeleteTaskSuccess());
    } else if (result is Error<bool>) {
      emit(DeleteTaskError(errorMessage: result.exception));
    }
  }

  Future<void> updateTask(TaskModel task) async {
    emit(UpdateTaskLoading());
    TaskModel taskModel = await _uploadFiles(task);
    final result = await _taskRepository.updateTask(taskModel);
    if (result is Success<bool>) {
      emit(UpdateTaskSuccess());
    } else if (result is Error<bool>) {
      emit(UpdateTaskError(errorMessage: result.exception));
    }
  }

  Future<void> createTask(TaskModel task) async {
    emit(CreateTaskLoading());
    TaskModel taskModel = await _uploadFiles(task);
    final result = await _taskRepository.createTask(taskModel);
    if (result is Success<bool>) {
      emit(CreateTaskSuccess());
    } else if (result is Error<bool>) {
      emit(CreateTaskError(errorMessage: result.exception));
    }
  }

  Future<String?> uploadFile({
    required File file,
    required String storagePath,
  }) async {
    // emit(UploadFileLoading());
    final result = await _taskRepository.uploadFile(
      file: file,
      storagePath: storagePath,
    );
    if (result is Success<String>) {
      return result.data;
    } else if (result is Error<String>) {
      emit(UploadFileError(errorMessage: result.exception));
    }
    return null;
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

  void showDeleteDialog(TaskModel task) {
    emit(ShowDeleteDialog(task));
    emit(CloseDeleteDialog());
  }

  void selectWorker(Worker workerId) {
    emit(SelectWorkerState(workerId));
  }

  void selectDateTime(DateTime dateTime) {
    emit(SelectDateTimeState(dateTime));
  }

  List<File> selectedImages = [];
  String? audioFile;

  Future<void> pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (image != null) {
      selectedImages.add(File(image.path));
      emit(MediaImageSelected(List.from(selectedImages)));
    }
  }

  void pressRecordingButton(bool isPressed) {
    bool isRecording = !isPressed;
    emit(IsPressedRecordingState(isRecording));
  }

  Future<void> completeRecording(String? audioPath) async {
    if (audioPath == null) return;
    audioFile = audioPath;
    emit(CompleteRecordingState());
  }

  void deleteImageFile(File imageFile) {
    selectedImages.remove(imageFile);
    emit(MediaImageSelected(List.from(selectedImages)));
  }

  Future<void> deleteFile(String url, String taskId) async {
    emit(DeleteFileLoading());
    final result = await _taskRepository.deleteFile(url, taskId);
    if (result is Success<bool>) {
      emit(DeleteFileSuccess(url));
    } else if (result is Error<bool>) {
      emit(DeleteFileError(errorMessage: result.exception));
    }
  }

  void searchTasks(String query, List<TaskModel> tasks) {
    List<TaskModel> filteredWorkers = tasks
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(SearchTasksState(filteredWorkers));
  }

  Future<TaskModel> _uploadFiles(TaskModel task) async {
    List<String> imagesUrl = task.imagesUrl;
    String? audioUrl = task.voiceUrl;
    for (File file in selectedImages) {
      final String? res = await uploadFile(file: file, storagePath: "images");
      imagesUrl.add(res!);
    }
    if (audioFile != null) {
      final String? res =
          await uploadFile(file: File(audioFile!), storagePath: "audios");
      audioUrl = res;
    }
    task = task.copyWith(imagesUrl: imagesUrl, voiceUrl: audioUrl);
    selectedImages.clear();
    audioUrl = null;
    audioFile = null;
    return task;
  }
}
