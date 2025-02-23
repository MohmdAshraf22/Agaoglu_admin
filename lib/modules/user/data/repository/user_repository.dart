import 'package:dartz/dartz.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';
import 'package:tasks_admin/modules/user/data/models/worker_creation_form.dart';
import 'package:tasks_admin/modules/user/data/services/remote_user_services.dart';

class UserRepository {
  RemoteUserServices _remoteUserServices = RemoteUserServices();
  Future<Either<Exception, Worker>> addWorker(
      WorkerCreationForm workerCreationForm) {
    return _remoteUserServices.addWorker(workerCreationForm);
  }

  Future<Either<Exception, Unit>> deleteWorker(String workerId) {
    return _remoteUserServices.deleteWorker(workerId);
  }

  Future<Either<Exception, List<Worker>>> getWorkers() {
    return _remoteUserServices.getWorkers();
  }

  Future<Either<Exception, Admin>> login(String email, String password) {
    return _remoteUserServices.login(email, password);
  }

  Future<Either<Exception, Unit>> resetPassword(String email) {
    return _remoteUserServices.resetPassword(email);
  }

  Future<Either<Exception, Unit>> logout() {
    return _remoteUserServices.logout();
  }

  Future<Either<Exception, Unit>> updateWorker(Worker worker) {
    return _remoteUserServices.updateWorker(worker);
  }
}
