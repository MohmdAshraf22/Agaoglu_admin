import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/error/exception_manager.dart';
import 'package:tasks_admin/core/routing/navigation_manager.dart';
import 'package:tasks_admin/core/utils/assets_manager.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/utils/text_styles_manager.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/generated/l10n.dart';
import 'package:tasks_admin/modules/user/cubit/user_cubit.dart';
import 'package:tasks_admin/modules/user/ui/widgets/widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    UserCubit cubit = UserCubit.get();
    return Scaffold(
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
                      AssetImage(AssetsManager.logo),
                      color: ColorManager.white,
                    ),
                  ),
                ),
                Text(
                  S.of(context).forgotPassword,
                  style: TextStylesManager.authTitle,
                ),
                Text(
                  S.of(context).enterEmail,
                  style: TextStyle(
                    color: ColorManager.white,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                AutofillGroup(
                  onDisposeAction: AutofillContextAction.commit,
                  child: Form(
                    key: formKey,
                    child: SemiTransparentContainer(
                      height: 30.h,
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
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: BlocConsumer<UserCubit, UserState>(
                                listener: (context, state) {
                                  if (state is ResetPasswordSuccessState) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title:
                                            Text(S.of(context).checkYourEmail),
                                        content: Text(S
                                            .of(context)
                                            .resetPasswordLinkSent),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              context.pop();
                                              context.pop();
                                            },
                                            child: Text(S.of(context).ok),
                                          ),
                                        ],
                                      ),
                                    );
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
                                    isLoading:
                                        state is ResetPasswordLoadingState,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit.resetPassword(
                                            emailController.text);
                                      }
                                    },
                                    text: S.of(context).sendResetLink,
                                  );
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: Text(
                                S.of(context).backToLogin,
                                style: TextStyle(
                                  color: ColorManager.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: ColorManager.white,
                                ),
                              ),
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
    );
  }
}
