import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';
import 'package:tasks_admin/modules/user/data/models/worker_creation_form.dart';

abstract class BaseRemoteUserServices {
  Future<Either<Exception, Admin>> login(String email, String password);
  Future<Either<Exception, List<Worker>>> getWorkers();
  Future<Either<Exception, Worker>> addWorker(
      WorkerCreationForm workerCreationForm);
  Future<Either<Exception, Unit>> updateWorker(Worker worker);
  Future<Either<Exception, Unit>> deleteWorker(String workerId);
  Future<Either<Exception, Unit>> logout();
}

class RemoteUserServices implements BaseRemoteUserServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  @override
  Future<Either<Exception, Admin>> login(String email, String password) async {
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
      return Right(admin);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Worker>>> getWorkers() async {
    try {
      final response = await _firestore.collection("workers").get();
      final workers = response.docs.map((doc) => Worker.fromJson(doc)).toList();

      return Right(workers);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Worker>> addWorker(
      WorkerCreationForm workerCreationForm) async {
    try {
      String? imageUrl;

      // Upload image if provided
      if (workerCreationForm.image != null) {
        imageUrl = await _uploadImage(
          workerCreationForm.image!,
          workerCreationForm.email,
        );
      }

      // Create Auth user using Cloud Function
      final authResult =
          await _functions.httpsCallable('createWorkerAuth').call({
        'email': workerCreationForm.email,
        'password': workerCreationForm.password,
      });

      final String workerId = authResult.data['uid'];

      // Create worker document in Firestore directly
      final worker = workerCreationForm.toWorker(
        id: workerId,
        imageUrl: imageUrl,
      );

      await _firestore.collection("workers").doc(workerId).set(worker.toJson());

      return Right(worker);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteWorker(String workerId) async {
    try {
      // Delete Auth user using Cloud Function
      await _functions.httpsCallable('deleteWorkerAuth').call({
        'workerId': workerId,
      });

      // Delete worker document from Firestore directly
      await _firestore.collection("workers").doc(workerId).delete();

      return const Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> updateWorker(Worker worker) async {
    try {
      await _firestore
          .collection("workers")
          .doc(worker.id)
          .update(worker.toJson());
      return const Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> logout() async {
    try {
      await _auth.signOut();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  Future<String?> _uploadImage(File image, String imageName) async {
    final uploadTask =
        _storage.ref().child("workerImages/$imageName").putFile(image);
    return await uploadTask.snapshot.ref.getDownloadURL();
  }
}
