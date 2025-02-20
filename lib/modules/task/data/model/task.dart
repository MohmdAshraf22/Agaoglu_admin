import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum TaskStatus {
  all,
  pending,
  inProgress,
  approved,
  cancelled,
  completed,
}

class Task extends Equatable {
  final String id;
  final String description;
  final String? workerName;
  final String? workerPhoto;
  final TaskStatus status;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.description,
    required this.status,
    this.workerName,
    this.workerPhoto,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'workerName': workerName,
      'workerPhoto': workerPhoto,
      'status': status.name,
      'createdAt': createdAt,
    };
  }

  factory Task.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      workerName: data['workerName'],
      workerPhoto: data['workerPhoto'],
      description: data['description'],
      status: TaskStatus.values.byName(data['status']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object?> get props =>
      [id, description, workerName, workerPhoto, status, createdAt];
}
