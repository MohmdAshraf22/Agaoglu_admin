import 'package:tasks_admin/core/utils/firebase_result_handler.dart';
import 'package:tasks_admin/modules/main/data/models/dashboard_details.dart';
import 'package:tasks_admin/modules/main/data/services/remote_data_source.dart';

class DashboardRepo {
  final DashboardDataSource _taskDataSource = DashboardDataSourceImpl();

  Future<Result<DashboardDetails>> getDashboardDetails() async {
    return await _taskDataSource.getDashboardDetails();
  }
}
