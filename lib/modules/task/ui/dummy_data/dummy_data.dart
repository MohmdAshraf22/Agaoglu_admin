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
}
