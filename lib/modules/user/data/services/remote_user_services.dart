import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';

abstract class BaseRemoteUserServices {
  Future<Either<Exception, Admin>> login(String email, String password);
}

class RemoteUserServices implements BaseRemoteUserServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Exception, Admin>> login(String email, String password) async {
    try {
      late Admin admin;

      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => value.user!);
      await _firestore
          .collection("users")
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
}
