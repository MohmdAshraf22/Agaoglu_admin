import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';

class DashboardDetails extends Equatable {
  final int totalWorkers;
  final int pendingTasks;
  final int completedTasks;
  final List<TaskModel> tasks;

  const DashboardDetails(
      {required this.totalWorkers,
      required this.tasks,
      required this.pendingTasks,
      required this.completedTasks});

  factory DashboardDetails.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DashboardDetails(
      totalWorkers: data['totalWorkers'],
      pendingTasks: data['pendingTasks'],
      completedTasks: data['completedTasks'],
      tasks: [],
    );
  }

  DashboardDetails copyWith({
    int? totalWorkers,
    int? pendingTasks,
    int? completedTasks,
    List<TaskModel>? tasks,
  }) {
    return DashboardDetails(
      totalWorkers: totalWorkers ?? this.totalWorkers,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props =>
      [totalWorkers, pendingTasks, completedTasks, tasks];
}
