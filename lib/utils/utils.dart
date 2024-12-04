import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/constrants.dart';

TextTheme createTextTheme(BuildContext context) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;

  TextTheme displayTextTheme =
      GoogleFonts.getTextTheme(fontFamilies[9], baseTextTheme);

  return displayTextTheme;
}
