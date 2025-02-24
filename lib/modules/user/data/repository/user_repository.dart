import 'package:tasks_admin/core/utils/firebase_result_handler.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';
import 'package:tasks_admin/modules/user/data/models/worker_creation_form.dart';
import 'package:tasks_admin/modules/user/data/services/remote_user_services.dart';

class UserRepository {
  final RemoteUserServices _remoteUserServices = RemoteUserServices();

  Future<Result<Worker>> addWorker(
      WorkerCreationForm workerCreationForm) async {
    return await _remoteUserServices.addWorker(workerCreationForm);
  }

  Future<Result<void>> deleteWorker(String workerId) async {
    return await _remoteUserServices.deleteWorker(workerId);
  }

  Future<Result<List<Worker>>> getWorkers() async {
    return await _remoteUserServices.getWorkers();
  }

  Future<Result<Admin>> login(String email, String password) async {
    return await _remoteUserServices.login(email, password);
  }

  Future<Result<void>> resetPassword(String email) async {
    return await _remoteUserServices.resetPassword(email);
  }

  Future<Result<void>> logout() async {
    return await _remoteUserServices.logout();
  }

  Future<Result<void>> updateWorker(Worker worker) async {
    return await _remoteUserServices.updateWorker(worker);
  }
}
