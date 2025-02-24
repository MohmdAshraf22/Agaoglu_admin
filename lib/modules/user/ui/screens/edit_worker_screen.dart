import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/error/exception_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/constance_manger.dart';
import 'package:tasks_admin/core/utils/text_styles_manager.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/user/cubit/user_cubit.dart';
import 'package:tasks_admin/modules/user/data/models/user.dart';
import 'package:tasks_admin/modules/user/data/models/worker_edition_form.dart';
import 'package:tasks_admin/modules/user/ui/screens/create_worker_screen.dart';
import 'package:tasks_admin/modules/user/ui/widgets/widgets.dart';

class EditWorkerScreen extends StatelessWidget {
  final Worker worker;

  const EditWorkerScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController nameController =
        TextEditingController(text: worker.name);
    TextEditingController phoneController =
        TextEditingController(text: worker.phoneNumber);
    TextEditingController emailController =
        TextEditingController(text: worker.email);
    TextEditingController passwordController = TextEditingController();
    TextEditingController surnameController =
        TextEditingController(text: worker.surname);
    UserCubit cubit = UserCubit.get()..selectJobTitle(worker.job);
    bool isPasswordAppears = false;

    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        backgroundColor: ColorManager.primaryDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorManager.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            S.of(context).editWorker,
            style: TextStylesManager.authTitle,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 2.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            return Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorManager.grey.withOpacity(0.3),
                              ),
                              child: state is ImageSelectedState &&
                                      state.image != null
                                  ? ClipOval(
                                      child: Image.file(
                                        state.image!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : worker.imageUrl != null
                                      ? ClipOval(
                                          child: Image.network(
                                            worker.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                              Icons.person_outline,
                                              size: 15.w,
                                              color: ColorManager.grey,
                                            ),
                                          ),
                                        )
                                      : Icon(
                                          Icons.person_outline,
                                          size: 15.w,
                                          color: ColorManager.grey,
                                        ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => cubit.pickImage(),
                            child: CircleAvatar(
                              radius: 5.w,
                              backgroundColor: ColorManager.orange,
                              child: Icon(
                                Icons.camera_alt,
                                color: ColorManager.white,
                                size: 6.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  LabelText(text: S.of(context).name),
                  Row(
                    spacing: 2.w,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: nameController,
                          hintText: S.of(context).name,
                          prefixIcon: Icon(Icons.person_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).enterName;
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: surnameController,
                          hintText: S.of(context).surName,
                          prefixIcon: Icon(Icons.person_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).enterSurname;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  LabelText(text: S.of(context).jobTitle),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorManager.white,
                          prefixIcon: Icon(Icons.work_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        value: cubit.selectedJobTitle,
                        hint: Text(S.of(context).selectJob),
                        items:
                            ConstanceManger.jobsInTurkish.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          cubit.selectJobTitle(value!);
                        },
                        validator: (value) {
                          if (value == null) {
                            return S.of(context).selectJob;
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  LabelText(text: S.of(context).phoneNumber),
                  CustomTextField(
                    controller: phoneController,
                    hintText: "(XXX) XXX-XXXX",
                    prefixIcon: Icon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).enterPhone;
                      }
                      return null;
                    },
                  ),
                  LabelText(text: S.of(context).email),
                  CustomTextField(
                    controller: emailController,
                    hintText: "worker@company.com",
                    prefixIcon: Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).enterEmail;
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return S.of(context).enterValidEmail;
                      }
                      return null;
                    },
                  ),
                  LabelText(text: S.of(context).newPassword),
                  BlocBuilder<UserCubit, UserState>(
                    bloc: cubit,
                    builder: (context, state) {
                      return CustomTextField(
                        controller: passwordController,
                        hintText: S.of(context).leaveEmptyToKeepCurrent,
                        obscureText: isPasswordAppears,
                        suffixIcon: IconButton(
                          onPressed: () {
                            cubit.changePasswordAppearance(isPasswordAppears);
                          },
                          icon: Icon(isPasswordAppears
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        prefixIcon: Icon(Icons.lock_outlined),
                        keyboardType: TextInputType.visiblePassword,
                      );
                    },
                  ),
                  SizedBox(height: 2.h),
                  BlocConsumer<UserCubit, UserState>(
                    listener: (context, state) {
                      if (state is UpdateWorkerSuccessState) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: S.of(context).workerUpdatedSuccessfully);
                      }
                      if (state is ChangePasswordAppearanceState) {
                        isPasswordAppears = state.isPasswordVisible;
                      }
                      if (state is UserErrorState) {
                        ExceptionManager.showMessage(state.exception);
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        spacing: 2.h,
                        children: [
                          DefaultButton(
                            text: S.of(context).save,
                            isLoading: state is UpdateWorkerLoadingState,
                            onPressed: () {
                              if (formKey.currentState!.validate() &&
                                  cubit.selectedJobTitle != null) {
                                cubit.updateWorker(
                                  WorkerEditionForm(
                                      id: worker.id,
                                      name: nameController.text,
                                      surname: surnameController.text,
                                      email: emailController.text,
                                      password: passwordController
                                                  .text.isEmpty ||
                                              passwordController.text ==
                                                  S
                                                      .of(context)
                                                      .leaveEmptyToKeepCurrent ||
                                              passwordController.text == ''
                                          ? null
                                          : passwordController.text,
                                      job: cubit.selectedJobTitle!,
                                      phoneNumber: phoneController.text),
                                );
                              }
                            },
                          ),
                          DefaultButton(
                            text: S.of(context).cancel,
                            color: ColorManager.grey.withOpacity(0.3),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
