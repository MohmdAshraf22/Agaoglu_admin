

import 'package:get_it/get_it.dart';
import 'package:tasks_admin/modules/task/data/data_source/remote_data_source.dart';
import 'package:tasks_admin/modules/task/data/repository/task_repo.dart';

final sl = GetIt.instance; // sl is a common abbreviation for service locator

Future<void> init() async {
  // Data sources
  sl.registerLazySingleton<TaskDataSource>(() => TaskDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<TaskRepository>(() => TaskRepository(sl()));
}