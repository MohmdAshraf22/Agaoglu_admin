import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/error/exception_manager.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/text_styles_manager.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/main/ui/screens/dashboard_screen.dart';
import 'package:tasks_admin/modules/user/cubit/user_cubit.dart';
import 'package:tasks_admin/modules/user/ui/screens/forgot_password_screen.dart';
import 'package:tasks_admin/modules/user/ui/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isPasswordAppears = false;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    UserCubit cubit = UserCubit.get();
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                gradient: ColorManager.primaryGradient,
              ),
            )),
            Align(
              alignment: Alignment.center,
              child: Column(
                spacing: 3.h,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SemiTransparentContainer(
                    height: 13.w,
                    width: 13.w,
                    borderRadius: 12,
                    child: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: ImageIcon(
                        AssetImage("assets/icons/admin_panel_icon.png"),
                        color: ColorManager.white,
                      ),
                    ),
                  ),
                  Text(
                    S.of(context).admin_panel,
                    style: TextStylesManager.authTitle,
                  ),
                  AutofillGroup(
                    onDisposeAction: AutofillContextAction.commit,
                    child: Form(
                      key: formKey,
                      child: SemiTransparentContainer(
                        height: 35.h,
                        width: 80.w,
                        opacity: .4,
                        child: Padding(
                          padding: EdgeInsets.all(5.w),
                          child: Column(
                            spacing: 2.h,
                            children: [
                              Expanded(
                                  child: AuthTextField(
                                controller: emailController,
                                prefixIcon: Icon(Icons.email),
                                autoFillHints: [
                                  AutofillHints.email,
                                ],
                                obscureText: false,
                                labelText: S.of(context).email,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return S.of(context).enterEmail;
                                  }
                                  final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (!emailRegex.hasMatch(value)) {
                                    return S.of(context).enterValidEmail;
                                  }

                                  return null;
                                },
                              )),
                              Expanded(child: BlocBuilder<UserCubit, UserState>(
                                builder: (context, state) {
                                  return AuthTextField(
                                    controller: passwordController,
                                    prefixIcon: Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        cubit.changePasswordAppearance(
                                            isPasswordAppears);
                                      },
                                      icon: Icon(isPasswordAppears
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    autoFillHints: [
                                      AutofillHints.password,
                                    ],
                                    obscureText: isPasswordAppears,
                                    keyboardType: TextInputType.visiblePassword,
                                    labelText: S.of(context).password,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return S.of(context).enterPassword;
                                      }
                                      return null;
                                    },
                                  );
                                },
                              )),
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: BlocConsumer<UserCubit, UserState>(
                                    listener: (context, state) {
                                      if (state is LoginSuccessState) {
                                        context.push(AdminDashboard());
                                      }
                                      if (state
                                          is ChangePasswordAppearanceState) {
                                        isPasswordAppears =
                                            state.isPasswordVisible;
                                      }
                                      if (state is UserErrorState) {
                                        ExceptionManager.showMessage(
                                            state.exception);
                                      }
                                    },
                                    bloc: cubit,
                                    builder: (context, state) {
                                      return DefaultButton(
                                        color: ColorManager.orange,
                                        textColor: ColorManager.white,
                                        isLoading: state is LoginLoadingState,
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            cubit.login(emailController.text,
                                                passwordController.text);
                                          }
                                        },
                                        text: S.of(context).signIn,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              FittedBox(
                                child: TextButton(
                                    onPressed: () {
                                      context.push(ForgotPasswordScreen());
                                    },
                                    child: Text(
                                      S.of(context).forgotPassword,
                                      style:
                                          TextStylesManager.authUnderLineText,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
