import 'dart:io';

import 'package:tasks_admin/core/utils/firebase_result_handler.dart';
import 'package:tasks_admin/modules/task/data/data_source/remote_data_source.dart';

import '../model/task.dart';

class TaskRepository {
  final TaskDataSource _taskDataSource;

  TaskRepository(this._taskDataSource);

  Stream<List<TaskModel>> getTasks() {
    return _taskDataSource.getTasks();
  }

  Future<Result<bool>> deleteTask(TaskModel task) async {
    return await _taskDataSource.deleteTask(task);
  }

  Future<Result<bool>> updateTask(TaskModel task) async {
    return await _taskDataSource.updateTask(task);
  }

  Future<Result<bool>> createTask(TaskModel task) async {
    return await _taskDataSource.createTask(task);
  }

  Future<Result<bool>> deleteFile(String url, String taskId) async {
    return await _taskDataSource.deleteFile(url, taskId);
  }

  Future<Result<String>> uploadFile({
    required File file,
    required String storagePath,
  }) async {
    return await _taskDataSource.uploadFile(
      file: file,
      storagePath: storagePath,
    );
  }
}
