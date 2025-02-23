import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';

class WorkerCreationForm extends Equatable {
  final File? image;
  final String name;
  final String surname;
  final String email;
  final String password;
  final String job;
  final String phoneNumber;

  const WorkerCreationForm({
    this.image,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.job,
    required this.phoneNumber,
  });

  Worker toWorker({required String id, String? imageUrl}) => Worker(
        name: name,
        email: email,
        job: job,
        imageUrl: imageUrl,
        id: id,
        surname: surname,
        phoneNumber: phoneNumber,
      );

  @override
  List<Object?> get props =>
      [image, name, surname, email, password, job, phoneNumber];
}
