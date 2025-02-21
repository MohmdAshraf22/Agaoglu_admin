import 'package:flutter/material.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';

class AuthTextField extends StatelessWidget {
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<String>? autoFillHints;
  final bool? enabled;
  const AuthTextField({
    super.key,
    this.hintText,
    this.validator,
    required this.controller,
    required this.obscureText,
    this.keyboardType,
    this.labelText,
    this.suffixIcon,
    this.prefixIcon,
    this.autoFillHints,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(color: ColorManager.white),
        fillColor: ColorManager.white,
        prefixIconColor: ColorManager.white,
        suffixIconColor: ColorManager.white,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        focusColor: ColorManager.white,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: ColorManager.white,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: ColorManager.white,
            )),
        suffix: suffixIcon,
        prefix: prefixIcon,
        labelText: labelText,
        hintText: hintText,
      ),
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      autofillHints: autoFillHints,
      keyboardType: keyboardType,
    );
  }
}
