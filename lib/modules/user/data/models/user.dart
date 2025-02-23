import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

sealed class AppUser extends Equatable {
  final String id;
  final String name;
  final String email;

  const AppUser({required this.id, required this.name, required this.email});
}

class Admin extends AppUser {
  const Admin({required super.id, required super.name, required super.email});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
  @override
  List<Object?> get props => [];
}

class Worker extends AppUser {
  final String job;
  final String surname;
  final String phoneNumber;
  final String? imageUrl;

  const Worker({
    required super.id,
    required super.name,
    required super.email,
    required this.job,
    required this.surname,
    required this.phoneNumber,
    this.imageUrl,
  });

  factory Worker.fromJson(DocumentSnapshot document) {
    final Map<String, dynamic> json = document.data() as Map<String, dynamic>;
    return Worker(
      imageUrl: json['imageUrl'],
      surname: json['surname'],
      phoneNumber: json['phoneNumber'],
      id: document.id,
      name: json['name'],
      email: json['email'],
      job: json['job'] ?? json["categoryId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'job': job,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl
    };
  }

  Worker copyWith({
    String? name,
    String? email,
    String? job,
    String? surname,
    String? phoneNumber,
    String? imageUrl,
  }) {
    return Worker(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      job: job ?? this.job,
      surname: surname ?? this.surname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [id];
}
