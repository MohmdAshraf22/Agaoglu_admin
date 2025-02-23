import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tasks_admin/core/utils/color_manager.dart';

class TextStylesManager {
  static TextStyle authTitle = TextStyle(
    color: ColorManager.white,
    fontWeight: FontWeight.w700,
    fontSize: 16.spa,
  );
  static TextStyle cardTitle = TextStyle(
    color: ColorManager.black,
    fontWeight: FontWeight.w700,
    fontSize: 14.spa,
  );
  static TextStyle cardText = TextStyle(
      color: ColorManager.descriptionGrey,
      fontWeight: FontWeight.normal,
      fontSize: 12.spa);
  static TextStyle authUnderLineText = TextStyle(
      color: ColorManager.white,
      decoration: TextDecoration.underline,
      decorationColor: ColorManager.white);
}
