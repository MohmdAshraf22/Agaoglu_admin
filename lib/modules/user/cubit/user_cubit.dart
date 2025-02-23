import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';
import 'package:tasks_admin/modules/user/data/models/worker_creation_form.dart';
import 'package:tasks_admin/modules/user/data/repository/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  final UserRepository _userRepository = UserRepository();
  List<Worker> workers = [];

  Future<void> login(String email, String password) async {
    emit(LoginLoadingState());

    final result = await _userRepository.login(email, password);

    result.fold(
        (l) => emit(UserErrorState(l)), (r) => emit(LoginSuccessState(r)));
  }

  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoadingState());
    final result = await _userRepository.resetPassword(email);
    result.fold((l) => emit(UserErrorState(l)),
        (r) => emit(ResetPasswordSuccessState()));
  }

  Future<void> logout() async {
    emit(LogoutLoadingState());
    final result = await _userRepository.logout();
    result.fold(
        (l) => emit(UserErrorState(l)), (r) => emit(LogoutSuccessState()));
  }

  Future<void> getWorkers() async {
    if (workers.isEmpty) {
      emit(GetWorkersLoadingState());
      final result = await _userRepository.getWorkers();
      result.fold((l) => emit(UserErrorState(l)), (r) {
        workers = r;
        emit(GetWorkersSuccessState(r));
      });
    } else {
      emit(GetWorkersSuccessState(workers));
    }
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
    emit(DeleteWorkerLoadingState(workerId));
    final result = await _userRepository.deleteWorker(workerId);
    result.fold((l) => emit(UserErrorState(l)),
        (r) => emit(DeleteWorkerSuccessState(workerId)));
  }

  void changePasswordAppearance(bool currentState) {
    emit(ChangePasswordAppearanceState(!currentState));
  }

  void searchWorkers(String query) {
    List<Worker> filteredWorkers = workers
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(SearchWorkersState(filteredWorkers));
  }

  static UserCubit? _cubit;
  static UserCubit get() => _cubit ??= UserCubit();
}
