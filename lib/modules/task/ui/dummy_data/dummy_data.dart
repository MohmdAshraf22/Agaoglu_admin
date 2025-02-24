import 'package:tasks_admin/modules/main/data/models/dashboard_details.dart';
import 'package:tasks_admin/modules/task/data/model/task.dart';

class DummyTasks {
  static List<TaskModel> getTasks() => [
        TaskModel(
          id: "id",
          title: "title",
          imagesUrl: [],
          voiceUrl: null,
          description: "description",
          status: TaskStatus.cancelled,
          createdAt: DateTime.now(),
        ),
      ];

  static DashboardDetails getDashboardTasks() => DashboardDetails(
      totalWorkers: 1, tasks: [], pendingTasks: 2, completedTasks: 3);
}
