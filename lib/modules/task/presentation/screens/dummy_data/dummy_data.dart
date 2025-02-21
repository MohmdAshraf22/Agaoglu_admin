import 'package:tasks_admin/modules/task/data/model/task.dart';

class DummyTasks {
  static List<Task> getTasks() => [
        Task(
          id: "id",
          description: "description",
          status: TaskStatus.pending,
          createdAt: DateTime.now(),
        ),
        Task(
          id: "id",
          description: "description",
          status: TaskStatus.cancelled,
          createdAt: DateTime.now(),
        ),
        Task(
          id: "id",
          description: "description",
          status: TaskStatus.approved,
          createdAt: DateTime.now(),
        ),
      ];
}
