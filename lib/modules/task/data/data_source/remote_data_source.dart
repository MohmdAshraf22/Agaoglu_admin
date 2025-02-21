import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasks_admin/core/utils/api_handler.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';

abstract class TaskDataSource {
  Stream<List<Task>> getTasks();

  Future<Result<Task>> getTask(String taskId);

  Future<Result<String>> createTask(Task task);

  Future<Result<bool>> updateTask(Task task);

  Future<Result<bool>> deleteTask(String taskId);

  Future<Result<bool>> assignTask(String taskId, List<String> workerIds);
}

class TaskDataSourceImpl implements TaskDataSource {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String _collectionName = 'tasks';

  @override
  Stream<List<Task>> getTasks() {
    return _fireStore.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromDocument(doc)).toList();
    }).handleError((error) {
      debugPrint('Error getting tasks: $error');
    });
  }

  @override
  Future<Result<Task>> getTask(String taskId) async {
    try {
      final snapshot =
          await _fireStore.collection(_collectionName).doc(taskId).get();
      Task task = Task.fromDocument(snapshot);
      return Result.success(task);
    } on FirebaseException catch (e) {
      debugPrint('Firebase error getting task status: $e');
      return Result.error('Firebase error: ${e.message}');
    }
  }

  @override
  Future<Result<String>> createTask(Task task) async {
    try {
      final collection = _fireStore.collection(_collectionName);
      final id = collection.doc().id;
      await collection.doc(id).set(task.toMap());
      return Result.success("Task added successfully");
    } on FirebaseException catch (e) {
      debugPrint('Firebase error creating task status: $e');
      return Result.error('Firebase error: ${e.message}');
    } catch (e) {
      debugPrint('Error creating task status: $e');
      return Result.error('An unexpected error occurred.');
    }
  }

  @override
  Future<Result<bool>> deleteTask(String taskId) async {
    try {
      final collection = _fireStore.collection(_collectionName);
      await collection.doc(taskId).delete();
      return Result.success(true);
    } on FirebaseException catch (e) {
      debugPrint('Firebase error deleting task status: $e');
      return Result.error('Firebase error: ${e.message}');
    } catch (e) {
      debugPrint('Error deleting task status: $e');
      return Result.error('An unexpected error occurred.');
    }
  }

  @override
  Future<Result<bool>> updateTask(Task task) async {
    try {
      final collection = _fireStore.collection(_collectionName);
      await collection.doc(task.id).update(task.toMap());
      return Result.success(true);
    } on FirebaseException catch (e) {
      debugPrint('Firebase error updating task status: $e');
      return Result.error('Firebase error: ${e.message}');
    } catch (e) {
      debugPrint('Error updating task status: $e');
      return Result.error('An unexpected error occurred.');
    }
  }

  @override
  Future<Result<bool>> assignTask(String taskId, List<String> workerIds) async {
    try {
      final collection = _fireStore.collection(_collectionName);
      await collection.doc(taskId).update({'workerAssignedId': workerIds});
      return Result.success(true);
    } on FirebaseException catch (e) {
      debugPrint('Firebase error updating task status: $e');
      return Result.error('Firebase error: ${e.message}');
    } catch (e) {
      debugPrint('Error updating task status: $e');
      return Result.error('An unexpected error occurred.');
    }
  }
}

// // Example usage in a ViewModel (using ChangeNotifier)
// class TaskViewModel extends ChangeNotifier {
//   final TaskDataSource _taskDataSource;
//   List<Task> _tasks = [];
//
//   List<Task> get tasks => _tasks;
//   String? _errorMessage;
//
//   String? get errorMessage => _errorMessage;
//
//   TaskViewModel(this._taskDataSource) {
//     _loadTasks();
//   }
//
//   void _loadTasks() {
//     _taskDataSource.getTasks().listen((tasks) {
//       _tasks = tasks;
//       _errorMessage = null;
//       notifyListeners();
//     }, onError: (error) {
//       _errorMessage = 'Failed to load tasks: $error';
//       notifyListeners();
//     });
//   }
//
//   Future<void> acceptTask(String taskId) async {
//     final result = await _taskDataSource.acceptTask(taskId);
//     _handleResult(result, 'accept');
//   }
//
//   Future<void> cancelTask(String taskId) async {
//     final result = await _taskDataSource.cancelTask(taskId);
//     _handleResult(result, 'cancel');
//   }
//
//   Future<void> markTaskAsDone(String taskId) async {
//     final result = await _taskDataSource.markTaskAsDone(taskId);
//     _handleResult(result, 'mark as done');
//   }
//
//   void _handleResult(Result<bool> result, String action) {
//     if (result.data == true) {
//       debugPrint('Task $action successful');
//       _errorMessage = null;
//       // Optionally, you might want to refresh the task list here
//       // _loadTasks(); // Or just rely on the stream to update the UI
//     } else {
//       _errorMessage = 'Failed to $action task: ${result.errorMessage}';
//       debugPrint(_errorMessage);
//     }
//     notifyListeners();
//   }
// }
