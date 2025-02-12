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
  final String categoryId;

  const Worker(
      {required super.id,
      required super.name,
      required super.email,
      required this.categoryId});

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'categoryId': categoryId,
    };
  }

  @override
  List<Object?> get props => [id];
}
