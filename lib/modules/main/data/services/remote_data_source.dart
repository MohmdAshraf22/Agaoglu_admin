import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasks_admin/core/utils/firebase_result_handler.dart';
import 'package:tasks_admin/modules/main/data/models/dashboard_details.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';

abstract class DashboardDataSource {
  Future<Result<DashboardDetails>> getDashboardDetails();
}

class DashboardDataSourceImpl implements DashboardDataSource {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String _dashboardDetails = 'dashboardDetails';
  final String _tasks = 'tasks';

  @override
  Future<Result<DashboardDetails>> getDashboardDetails() async {
    try {
      final snapshot = await _fireStore
          .collection(_dashboardDetails)
          .doc(_dashboardDetails)
          .get();
      final tasks = await _getTasks();
      DashboardDetails? dashboardDetails;
      dashboardDetails = DashboardDetails.fromDocument(snapshot);
      dashboardDetails.tasks = tasks;
      return Result.success(dashboardDetails);
    } on FirebaseException catch (e) {
      debugPrint('Firebase error getting task status: $e');
      return Result.error(e);
    }
  }

  Future<List<TaskModel>> _getTasks() async {
    final data = await _fireStore.collection(_tasks).orderBy('createdAt').get();
    return data.docs.map((doc) => TaskModel.fromDocument(doc)).toList();
  }
}
