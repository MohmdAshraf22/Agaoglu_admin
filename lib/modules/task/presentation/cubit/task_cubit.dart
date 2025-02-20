import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_admin/core/utils/api_handler.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';
import 'package:tasks_admin/modules/task/data/repository/task_repo.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository _taskRepository; // Change

  TaskCubit(this._taskRepository) : super(TaskInitial()) {
    _loadTasks();
  }

  void _loadTasks() {
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

  Future<void> getTask(String taskId) async {
    emit(GetTaskLoading());
    final result = await _taskRepository.getTask(taskId);
    if (result is Success<Task>) {
      emit(GetTaskSuccess());
    } else if (result is Error<Task>) {
      emit(GetTaskError(errorMessage: result.errorMessage!));
    }
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

  Future<void> updateTask(Task task) async {
    emit(UpdateTaskLoading());
    final result = await _taskRepository.updateTask(task);
    if (result is Success<bool>) {
      emit(UpdateTaskSuccess());
    } else if (result is Error<bool>) {
      emit(UpdateTaskError(errorMessage: result.errorMessage!));
    }
  }

  filterTasksByStatus(TaskStatus status) {
    emit(FilterTaskByStatus(status));
  }

}
