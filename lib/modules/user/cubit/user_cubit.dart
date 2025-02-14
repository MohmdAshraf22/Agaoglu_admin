import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';
import 'package:tasks_admin/modules/user/data/models/worker_creation_form.dart';
import 'package:tasks_admin/modules/user/data/repository/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  final UserRepository _userRepository = UserRepository();

  Future<void> login(String email, String password) async {
    emit(LoginLoadingState());

    final result = await _userRepository.login(email, password);

    result.fold(
        (l) => emit(UserErrorState(l)), (r) => emit(LoginSuccessState(r)));
  }

  Future<void> logout() async {
    emit(LogoutLoadingState());
    final result = await _userRepository.logout();
    result.fold(
        (l) => emit(UserErrorState(l)), (r) => emit(LogoutSuccessState()));
  }

  Future<void> getWorkers(String email, String password) async {
    emit(GetWorkersLoadingState());
    final result = await _userRepository.getWorkers(email, password);
    result.fold(
        (l) => emit(UserErrorState(l)), (r) => emit(GetWorkersSuccessState(r)));
  }

  Future<void> addWorker(WorkerCreationForm workerCreationForm) async {
    emit(AddWorkerLoadingState());
    final result = await _userRepository.addWorker(workerCreationForm);
    result.fold(
        (l) => emit(UserErrorState(l)), (r) => emit(AddWorkerSuccessState(r)));
  }

  Future<void> updateWorker(Worker worker) async {
    emit(UpdateWorkerLoadingState());
    final result = await _userRepository.updateWorker(worker);
    result.fold((l) => emit(UserErrorState(l)),
        (r) => emit(UpdateWorkerSuccessState(worker)));
  }

  Future<void> deleteWorker(String workerId) async {
    emit(DeleteWorkerLoadingState());
    final result = await _userRepository.deleteWorker(workerId);
    result.fold((l) => emit(UserErrorState(l)),
        (r) => emit(DeleteWorkerSuccessState(workerId)));
  }
}
/*



 */
