import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';
import 'package:tasks_admin/modules/user/data/models/worker_creation_form.dart';

abstract class BaseRemoteUserServices {
  Future<Either<Exception, Admin>> login(String email, String password);
  Future<Either<Exception, List<Worker>>> getWorkers(
      String email, String password);
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
  @override
  Future<Either<Exception, Admin>> login(String email, String password) async {
    try {
      late Admin admin;

      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => value.user!);
      await _firestore
          .collection("admins")
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) {
        admin = Admin.fromJson(value.data() as Map<String, dynamic>);
      });
      return Right(admin);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<Worker>>> getWorkers(
      String email, String password) async {
    try {
      List<Worker> workers = [];
      var response = await _firestore.collection("workers").get();

      response.docs.map((e) {
        workers.add(Worker.fromJson(e));
      });
      return Right(workers);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Worker>> addWorker(
      WorkerCreationForm workerCreationForm) async {
    try {
      // initialize future operations
      Future<String?>? uploadImageFuture;
      late Future<UserCredential> signUpFuture;

      if (workerCreationForm.image != null) {
        uploadImageFuture =
            _uploadImage(workerCreationForm.image!, workerCreationForm.email);
      }
      signUpFuture =
          _signUp(workerCreationForm.email, workerCreationForm.password);

      // wait for all futures
      final results = await Future.wait([
        signUpFuture,
        if (uploadImageFuture != null) uploadImageFuture,
      ]);
// create worker
      final userCredential = results[0] as UserCredential;
      final imageUrl = uploadImageFuture != null ? results[1] as String : null;
      final worker = workerCreationForm.toWorker(
        id: userCredential.user!.uid,
        imageUrl: imageUrl,
      );

      await _setWorkerData(worker);

      return Right(worker);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> deleteWorker(String workerId) async {
    try {
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
      _auth.signOut();
      return const Right(unit);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  /// private methods
  Future<UserCredential> _signUp(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  Future<String?> _uploadImage(File image, String imageName) async {
    var uploadTask =
        _storage.ref().child("workerImages/$imageName").putFile(image);
    return await uploadTask.snapshot.ref.getDownloadURL();
  }

  Future<void> _setWorkerData(Worker worker) async {
    await _firestore.collection("workers").doc(worker.id).set(worker.toJson());
  }
}
