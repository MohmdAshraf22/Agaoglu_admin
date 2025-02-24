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
        labelStyle: TextStyle(color: ColorManager.white),
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
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: ColorManager.red,
            )),
        // suffix: suffixIcon,
        // prefix: prefixIcon,
        labelText: labelText,
        hintText: hintText,
      ),
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      autofillHints: autoFillHints,
      keyboardType: keyboardType,
      style: TextStyle(color: ColorManager.white),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final Widget? suffixIcon;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: ColorManager.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
