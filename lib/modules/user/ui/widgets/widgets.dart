import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? labelText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  const AuthTextField(
      {super.key,
      this.hintText,
      this.validator,
      required this.controller,
      required this.obscureText,
      this.keyboardType,
      this.labelText,
      this.suffixIcon,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        suffix: suffixIcon,
        prefix: prefixIcon,
        labelText: labelText,
        hintText: hintText,
      ),
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
