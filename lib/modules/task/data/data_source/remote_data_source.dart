import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:tasks_admin/core/utils/firebase_result_handler.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';

abstract class TaskDataSource {
  Stream<List<TaskModel>> getTasks();

  Future<Result<bool>> deleteFile(String url, String taskId);

  Future<Result<bool>> createTask(TaskModel task);

  Future<Result<bool>> updateTask(TaskModel task);

  Future<Result<bool>> deleteTask(TaskModel task);

  Future<Result<String>> uploadFile({
    required File file,
    required String storagePath,
  });
}

class TaskDataSourceImpl implements TaskDataSource {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _tasks = 'tasks';
  final String _dashboardDetails = 'dashboardDetails';

  @override
  Stream<List<TaskModel>> getTasks() {
    return _fireStore
        .collection(_tasks)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromDocument(doc)).toList();
    }).handleError((error) {});
  }

  @override
  Future<Result<bool>> createTask(TaskModel task) async {
    try {
      WriteBatch batch = _fireStore.batch();
      final collection = _fireStore.collection(_tasks);
      final id = collection.doc().id;
      DocumentReference dashboardRef =
          _fireStore.collection(_dashboardDetails).doc(_dashboardDetails);
      DocumentReference taskRef = collection.doc(id);
      batch.update(dashboardRef, {'pendingTasks': FieldValue.increment(1)});
      batch.set(taskRef, task.toMap(id));
      await batch.commit();
      return Result.success(true);
    } on FirebaseException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> deleteTask(TaskModel task) async {
    try {
      WriteBatch batch = _fireStore.batch();
      final collection = _fireStore.collection(_tasks);
      DocumentReference taskRef = collection.doc(task.id);
      DocumentReference dashboardRef =
          _fireStore.collection(_dashboardDetails).doc(_dashboardDetails);
      taskRef.delete();
      dashboardRef.update({'pendingTasks': FieldValue.increment(-1)});
      await batch.commit();
      if (task.voiceUrl != null) {
        _deleteFile(task.voiceUrl!);
      }
      for (String url in task.imagesUrl) {
        _deleteFile(url);
      }
      return Result.success(true);
    } on FirebaseException catch (e) {
      return Result.error(e);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> updateTask(TaskModel task) async {
    try {
      final collection = _fireStore.collection(_tasks);
      await collection.doc(task.id).update(task.toMap(task.id));
      return Result.success(true);
    } on FirebaseException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<String>> uploadFile({
    required File file,
    required String storagePath,
  }) async {
    try {
      final String uploadFileName = path.basename(file.path);
      final Reference storageReference =
          _storage.ref().child('$storagePath/$uploadFileName');
      final UploadTask uploadTask = storageReference.putFile(file);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      if (taskSnapshot.state == TaskState.success) {
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        return Result.success(downloadUrl);
      } else {
        return Result.error(Exception());
      }
    } on FirebaseException catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<bool>> deleteFile(String url, String taskId) async {
    try {
      final Reference storageReference = _storage.refFromURL(url);
      await storageReference.delete();
      if (url.contains("images")) {
        await _fireStore.collection(_tasks).doc(taskId).update({
          'imagesUrl': FieldValue.arrayRemove([url])
        });
      } else {
        await _fireStore
            .collection(_tasks)
            .doc(taskId)
            .update({'voiceUrl': null});
      }
      return Result.success(true);
    } on FirebaseException catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<bool>> _deleteFile(String url) async {
    try {
      final Reference storageReference = _storage.refFromURL(url);
      await storageReference.delete();

      return Result.success(true);
    } on FirebaseException catch (e) {
      return Result.error(e);
    }
  }
}
