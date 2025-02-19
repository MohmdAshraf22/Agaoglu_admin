import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';
import 'package:tasks_admin/core/widgets/widgets.dart';
import 'package:tasks_admin/modules/user/ui/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageIcon(AssetImage("assets/icons/admin_panel_icon.jpeg")),
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
                              obscureText: false,
                              labelText: "email",
                              suffixIcon: Icon(
                                Icons.email,
                              ),
                            )),
                            Expanded(child: TextFormField()),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: DefaultButton(
                                  color: ColorManager.orange,
                                  textColor: ColorManager.white,
                                  onPressed: () {
                                    if (formKey.currentState!.mounted) {}
                                  },
                                  text: "login",
                                ),
                              ),
                            ),
                            FittedBox(
                              child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "forgot password?",
                                    style: TextStyle(
                                        color: ColorManager.white,
                                        decoration: TextDecoration.underline,
                                        decorationColor: ColorManager.white),
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
    );
  }
}
