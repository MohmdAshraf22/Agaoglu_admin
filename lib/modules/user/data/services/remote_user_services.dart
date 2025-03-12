import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tasks_admin/core/utils/firebase_result_handler.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';
import 'package:tasks_admin/modules/user/data/models/worker_creation_form.dart';
import 'package:tasks_admin/modules/user/data/models/worker_edition_form.dart';

abstract class BaseRemoteUserServices {
  Future<Result<Admin>> login(String email, String password);
  Future<Result<List<Worker>>> getWorkers();
  Future<Result<Worker>> addWorker(WorkerCreationForm workerCreationForm);
  Future<Result<Worker>> updateWorker(WorkerEditionForm editedWorker);
  Future<Result<void>> deleteWorker(String workerId);
  Future<Result<void>> logout();
  Future<Result<void>> resetPassword(String email);
}

class RemoteUserServices implements BaseRemoteUserServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final String _dashboardDetails = 'dashboardDetails';

  @override
  Future<Result<Admin>> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final adminDoc = await _firestore
          .collection("admins")
          .doc(userCredential.user!.uid)
          .get();

      final admin = Admin.fromJson(adminDoc.data() as Map<String, dynamic>);
      return Result.success(admin);
    } on Exception catch (e) {
            return Result.error(e);
    }
  }

  @override
  Future<Result<void>> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<Worker>>> getWorkers() async {
    try {
      final response = await _firestore.collection("workers").get();
      final workers = response.docs.map((doc) => Worker.fromJson(doc)).toList();

      return Result.success(workers);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<Worker>> addWorker(
      WorkerCreationForm workerCreationForm) async {
    try {
      String? imageUrl;

      if (workerCreationForm.image != null) {
        imageUrl = await _uploadImage(
          workerCreationForm.image!,
          "${workerCreationForm.email}${workerCreationForm.image?.path.split(".").last}",
        );
      }

      
      final HttpsCallableResult callableResult =
          await _functions.httpsCallable('createWorkerAuth').call({
        'email': workerCreationForm.email,
        'password': workerCreationForm.password,
      });
      final String id = callableResult.data['uid'];

      final worker = workerCreationForm.toWorker(id: id, imageUrl: imageUrl);
      
      WriteBatch batch = _firestore.batch();
      DocumentReference workerRef =
          _firestore.collection("workers").doc(worker.id);
      batch.set(workerRef, worker.toJson());

      DocumentReference dashboardRef =
          _firestore.collection(_dashboardDetails).doc(_dashboardDetails);
      batch.update(dashboardRef, {'totalWorkers': FieldValue.increment(1)});

      await batch.commit();
      return Result.success(worker);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> deleteWorker(String workerId) async {
    try {
      await _functions.httpsCallable('deleteWorkerAuth').call({
        'workerId': workerId,
      });
      WriteBatch batch = _firestore.batch();
      DocumentReference workerRef = _firestore.doc("workers/$workerId");
      batch.delete(workerRef);

      DocumentReference dashboardRef =
          _firestore.collection(_dashboardDetails).doc(_dashboardDetails);
      batch.update(dashboardRef, {'totalWorkers': FieldValue.increment(-1)});
      await batch.commit();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<Worker>> updateWorker(WorkerEditionForm editedWorker) async {
    try {
            String? imageUrl;

      if (editedWorker.image != null) {
        imageUrl = await _uploadImage(
          editedWorker.image!,
          editedWorker.email,
        );
                      }
      if (editedWorker.password != null) {
        await _editPassword(editedWorker.id, editedWorker.password!);
      }

      final worker = editedWorker.toWorker(imageUrl: imageUrl);
            await _firestore
          .collection("workers")
          .doc(worker.id)
          .update(worker.toJson());
            return Result.success(worker);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _auth.signOut();
      return Result.success(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<String?> _uploadImage(File image, String imageName) async {
    String? imageUrl;

    final Reference storageReference =
        _storage.ref().child('workers/$imageName');
    final UploadTask uploadTask = storageReference.putFile(image);

    await uploadTask.then((v) async {
      imageUrl = await v.ref.getDownloadURL();
    });

    return imageUrl;
  }

  Future<void> _editPassword(String id, String password) async {
    await _functions.httpsCallable('updateWorkerPassword').call({
      'workerId': id,
      'newPassword': password,
    }).then((v) {
                });
  }
}
