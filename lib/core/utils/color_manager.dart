import 'package:flutter/material.dart';

final class ColorManager {
  static const Color primary = Color(0xFF1E3A8A);
  static const Color primaryLight = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1A2238);
  static const Color grey = Color(0xFF9095A0);
  static const Color greyLight = Color(0xFFF3F4F6);
  static const Color descriptionGrey = Color(0xFF4B5563);

  static const Color yellow = Color(0xFFFACC15);
  static const Color green = Color(0xFF4ADE80);
  static const Color red = Color(0xFFE74C3C);
  static const Color blue = Color(0xFF1E90FF);

  static const Color secondary = Color(0xFF000000);
  static const Color orange = Color(0xffF97316);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color error = Color(0xFFE61F34);
  static Gradient primaryGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      ColorManager.primary,
      ColorManager.primaryLight,
      ColorManager.primary,
    ],
  );
}
