import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasks_admin/core/utils/api_handler.dart';
import 'package:tasks_admin/modules/main/data/models/dashboard_details.dart';

abstract class DashboardDataSource {
  Future<Result<DashboardDetails>> getDashboardDetails();
}

class DashboardDataSourceImpl implements DashboardDataSource {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String _dashboardDetails = 'DashboardDetails';

  @override
  Future<Result<DashboardDetails>> getDashboardDetails() async {
    try {
      final snapshot = await _fireStore
          .collection(_dashboardDetails)
          .doc("DashboardDetails")
          .get();
      DashboardDetails dashboardDetails = DashboardDetails.fromDocument(snapshot);
      return Result.success(dashboardDetails);
    } on FirebaseException catch (e) {
      debugPrint('Firebase error getting task status: $e');
      return Result.error('Firebase error: ${e.message}');
    }
  }
}
