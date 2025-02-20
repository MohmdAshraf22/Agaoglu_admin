import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus {
  pending,
  all,
  inProgress,
  approved,
  cancelled,
  completed,
}

class Task {
  final String id;
  final String description;
  final String? workerAssignedId;
  final TaskStatus status;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.description,
    required this.status,
    required this.workerAssignedId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'workerAssignedId': workerAssignedId,
      'status': status.name,
      'createdAt': createdAt,
    };
  }

  factory Task.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      workerAssignedId: data['workerAssignedId'],
      description: data['description'] ?? '',
      status: TaskStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => TaskStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
