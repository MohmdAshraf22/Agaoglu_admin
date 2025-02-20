import 'package:tasks_admin/core/utils/api_handler.dart';
import 'package:tasks_admin/modules/task/data/data_source/remote_data_source.dart';

import '../model/task.dart';

class TaskRepository {
  final TaskDataSource _taskDataSource;

  TaskRepository(this._taskDataSource);

  Stream<List<Task>> getTasks() {
    return _taskDataSource.getTasks();
  }

  Future<Result<bool>> assignTask(String taskId, List<String> workerIds) async {
    return await _taskDataSource.assignTask(taskId, workerIds);
  }

  Future<Result<bool>> deleteTask(String taskId) async {
    return await _taskDataSource.deleteTask(taskId);
  }

  Future<Result<bool>> updateTask(Task task) async {
    return await _taskDataSource.updateTask(task);
  }

  Future<Result<Task>> getTask(String taskId) async {
    return await _taskDataSource.getTask(taskId);
  }

  Future<Result<String>> createTask(Task task) async {
    return await _taskDataSource.createTask(task);
  }
}
