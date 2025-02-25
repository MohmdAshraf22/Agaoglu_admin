import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tasks_admin/core/utils/firebase_result_handler.dart';
import 'package:tasks_admin/firebase_options.dart';
import 'package:tasks_admin/main.dart';
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
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instanceFor(app: FirebaseConstants.firebaseApp!);
  final FirebaseStorage _storage =
      FirebaseStorage.instanceFor(app: FirebaseConstants.firebaseApp!);
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  FirebaseApp? _app;
  FirebaseAuth? workerAuth;
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
      debugPrint(e.toString());
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
      debugPrint("add worker started...");
      String? imageUrl;

      if (workerCreationForm.image != null) {
        imageUrl = await _uploadImage(
          workerCreationForm.image!,
          workerCreationForm.email,
        );
        debugPrint("image uploaded..");
        debugPrint("$imageUrl");
      }
      debugPrint("add worker cloud functions started...");
      //
      // final result = await _functions.httpsCallable('createWorkerAuth').call({
      //   'email': workerCreationForm.email,
      //   'password': workerCreationForm.password,
      // }).then((v) {
      //   debugPrint(v.data);
      //   debugPrint(v.runtimeType.toString());
      //   debugPrint(v.hashCode.toString());
      // });

      final String id =
          await _signUp(workerCreationForm.email, workerCreationForm.password);
      debugPrint("add worker cloud functions ended...");
      debugPrint(id);

      final worker = workerCreationForm.toWorker(id: id, imageUrl: imageUrl);
      debugPrint("${worker.toJson()}");
      WriteBatch batch = _firestore.batch();

      DocumentReference workerRef =
          _firestore.collection("workers").doc(worker.id);
      batch.set(workerRef, worker.toJson());

      DocumentReference dashboardRef =
          _firestore.collection(_dashboardDetails).doc(_dashboardDetails);
      batch.update(dashboardRef, {'totalWorkers': FieldValue.increment(1)});

      await batch.commit();
      debugPrint("add worker cloud completed...");
      return Result.success(worker);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> deleteWorker(String workerId) async {
    try {
      // Delete Auth user using Cloud Function
      // await _functions.httpsCallable('deleteWorkerAuth').call({
      //   'workerId': workerId,
      // });
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
      debugPrint("add worker started...");
      String? imageUrl;

      if (editedWorker.image != null) {
        imageUrl = await _uploadImage(
          editedWorker.image!,
          editedWorker.email,
        );
        debugPrint("image uploaded..");
        debugPrint("$imageUrl");
      }
      if (editedWorker.password != null) {
        await _editPassword(editedWorker.id, editedWorker.password);
      }
      debugPrint("add worker cloud functions started...");
      //
      // final result = await _functions.httpsCallable('createWorkerAuth').call({
      //   'email': editedWorker.email,
      //   'password': editedWorker.password,
      // }).then((v) {
      //   debugPrint(v.data);
      //   debugPrint(v.runtimeType.toString());
      //   debugPrint(v.hashCode.toString());
      // });

      final worker = editedWorker.toWorker(imageUrl: imageUrl);
      debugPrint("${worker.toJson()}");
      await _firestore
          .collection("workers")
          .doc(worker.id)
          .set(worker.toJson());
      debugPrint("add worker cloud completed...");
      return Result.success(worker);
      // await _firestore
      //     .collection("workers")
      //     .doc(worker.id)
      //     .update(worker.toJson());
      // return Result.success(editedWorker.toWorker(id: id));
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
    final uploadTask =
        _storage.ref().child("workerImages/$imageName").putFile(image);
    return await uploadTask.snapshot.ref.getDownloadURL();
  }

  Future<String> _signUp(String email, String password) async {
    if (_app == null) {
      _app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
        name: "worker",
      );
      workerAuth = FirebaseAuth.instanceFor(app: _app!);
    }
    final userCredential = await workerAuth!
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user!.uid;
  }

  Future<void> _editPassword(String id, String? password) async {
    // final result = await _functions.httpsCallable('updateWorkerPassword').call({
    //   'email': editedWorker.email,
    //   'password': editedWorker.password,
    // }).then((v) {
    //   debugPrint(v.data);
    //   debugPrint(v.runtimeType.toString());
    //   debugPrint(v.hashCode.toString());
    // });
  }
}
