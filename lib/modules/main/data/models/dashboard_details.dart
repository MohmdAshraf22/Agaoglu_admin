import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';

class DashboardDetails extends Equatable {
  final String id;
  final String description;
  final String title;
  final String? workerName;
  final TaskStatus status;
  final DateTime createdAt;
  final int totalWorkers;
  final int pendingTasks;
  final int completedTasks;

  const DashboardDetails(
      {required this.id,
      required this.description,
      required this.title,
      required this.workerName,
      required this.status,
      required this.createdAt,
      required this.totalWorkers,
      required this.pendingTasks,
      required this.completedTasks});

  factory DashboardDetails.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DashboardDetails(
      id: doc.id,
      workerName: data['workerName'],
      totalWorkers: data['totalWorkers'],
      pendingTasks: data['pendingTasks'],
      completedTasks: data['completedTasks'],
      title: data['title'],
      description: data['description'],
      status: TaskStatus.values.byName(data['status']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        description,
        workerName,
        status,
        createdAt,
        title,
        totalWorkers,
        pendingTasks,
        completedTasks
      ];
}
