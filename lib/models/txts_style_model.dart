import 'package:flutter/material.dart';
import 'package:myapp/views/subpages/screenshot_screen/editor/textStyle/text_case_selector.dart';

class TextStyleModel {
  final double? fontSize;
  final String? fontFamily;
  final Color? fontColor;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final FontCase? fontCase;

  TextStyleModel({
    this.fontSize,
    this.fontFamily,
    this.fontColor,
    this.textAlign,
    this.fontWeight,
    this.fontCase,
  });

  // Copy method to update specific properties
  TextStyleModel copyWith({
    double? fontSize,
    String? fontFamily,
    Color? fontColor,
    TextAlign? textAlign,
    FontWeight? fontWeight,
    FontCase? fontCase,
  }) {
    return TextStyleModel(
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontColor: fontColor,
        textAlign: textAlign,
        fontWeight: fontWeight,
        fontCase: fontCase);
  }
}
