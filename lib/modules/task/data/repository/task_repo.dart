import 'dart:io';

import 'package:tasks_admin/core/utils/api_handler.dart';
import 'package:tasks_admin/modules/task/data/data_source/remote_data_source.dart';

import '../model/task.dart';

class TaskRepository {
  final TaskDataSource _taskDataSource;

  TaskRepository(this._taskDataSource);

  Stream<List<TaskModel>> getTasks() {
    return _taskDataSource.getTasks();
  }

  Future<Result<bool>> assignTask(String taskId, List<String> workerIds) async {
    return await _taskDataSource.assignTask(taskId, workerIds);
  }

  Future<Result<bool>> deleteTask(String taskId) async {
    return await _taskDataSource.deleteTask(taskId);
  }

  Future<Result<bool>> updateTask(TaskModel task) async {
    return await _taskDataSource.updateTask(task);
  }

  Future<Result<String>> createTask(TaskModel task) async {
    return await _taskDataSource.createTask(task);
  }

  Future<Result<String>> uploadFile(
      {required File file,
      required String storagePath}) async {
    return await _taskDataSource.uploadFile(
        file: file, storagePath: storagePath,);
  }
}
