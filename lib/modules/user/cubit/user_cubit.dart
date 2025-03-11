import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasks_admin/core/utils/firebase_result_handler.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';
import 'package:tasks_admin/modules/user/data/models/worker_creation_form.dart';
import 'package:tasks_admin/modules/user/data/models/worker_edition_form.dart';
import 'package:tasks_admin/modules/user/data/repository/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  final UserRepository _userRepository = UserRepository();
  List<Worker> workers = [];
  List<Worker> filteredWorkers = [];

  Future<void> login(String email, String password) async {
    emit(LoginLoadingState());
    final result = await _userRepository.login(email, password);
    if (result is Success<Admin>) {
      emit(LoginSuccessState(result.data));
    } else if (result is Error<Admin>) {
      emit(UserErrorState(result.exception));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(ResetPasswordLoadingState());
    final result = await _userRepository.resetPassword(email);
    if (result is Success<void>) {
      emit(ResetPasswordSuccessState());
    } else if (result is Error<void>) {
      emit(UserErrorState(result.exception));
    }
  }

  Future<void> logout() async {
    emit(LogoutLoadingState());
    final result = await _userRepository.logout();
    if (result is Success<void>) {
      emit(LogoutSuccessState());
    } else if (result is Error<void>) {
      emit(UserErrorState(result.exception));
    }
  }

  Future<void> getWorkers() async {
    emit(GetWorkersLoadingState());
    final result = await _userRepository.getWorkers();
    if (result is Success<List<Worker>>) {
      workers = result.data;
      emit(GetWorkersSuccessState(result.data));
    } else if (result is Error<List<Worker>>) {
      emit(UserErrorState(result.exception));
    }
  }

  Future<void> addWorker(WorkerCreationForm workerCreationForm) async {
    emit(AddWorkerLoadingState());
    final result = await _userRepository.addWorker(workerCreationForm);
    if (result is Success<Worker>) {
      workers.add(result.data);
      emit(AddWorkerSuccessState(result.data));
    } else if (result is Error<Worker>) {
      emit(UserErrorState(result.exception));
    }
  }

  Future<void> updateWorker(WorkerEditionForm worker) async {
    emit(UpdateWorkerLoadingState());
    final result = await _userRepository.updateWorker(worker);
    if (result is Success<Worker>) {
      emit(UpdateWorkerSuccessState(result.data));
    } else if (result is Error<Worker>) {
      emit(UserErrorState(result.exception));
    }
  }

  Future<void> deleteWorker(String workerId) async {
    emit(DeleteWorkerLoadingState(workerId));
    final result = await _userRepository.deleteWorker(workerId);
    if (result is Success<void>) {
      emit(DeleteWorkerSuccessState(workerId));
    } else if (result is Error<void>) {
      emit(UserErrorState(result.exception));
    }
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

  File? selectedImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      emit(ImageSelectedState(selectedImage));
    }
  }

  static UserCubit? _cubit;
  static UserCubit get() => _cubit ??= UserCubit();

  String? selectedJobTitle;
  void selectJobTitle(String s) {
    selectedJobTitle = s;
    emit(SelectJobTitleState(s));
  }
}
