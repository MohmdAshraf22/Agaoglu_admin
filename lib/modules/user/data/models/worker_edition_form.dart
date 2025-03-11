import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';

class WorkerEditionForm extends Equatable {
  final File? image;
  final String name;
  final String surname;
  final String email;
  final String? password;
  final String job;
  final String phoneNumber;
  final String id;
  final String? imageUrl;
  const WorkerEditionForm({
    this.image,
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.password,
    required this.job,
    required this.phoneNumber,
    this.imageUrl,
  });

  Worker toWorker({String? imageUrl}) => Worker(
        name: name,
        email: email,
        job: job,
        imageUrl: imageUrl ?? this.imageUrl,
        id: id,
        surname: surname,
        phoneNumber: phoneNumber,
      );

  @override
  List<Object?> get props =>
      [image, name, surname, email, password, job, phoneNumber, id, imageUrl];
}
