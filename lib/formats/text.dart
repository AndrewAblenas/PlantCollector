import 'package:flutter/material.dart';

//Scaling Constant
const double kTextScale = 0.0025;

//Size
class AppTextSize {
  static const double tiny = 10.0 * kTextScale;
  static const double small = 15.0 * kTextScale;
  static const double medium = 20.0 * kTextScale;
  static const double large = 25.0 * kTextScale;
  static const double huge = 30.0 * kTextScale;
  static const double gigantic = 60.0 * kTextScale;
}

//Weight
class AppTextWeight {
  static const FontWeight light = FontWeight.w100;
  static const FontWeight medium = FontWeight.w300;
  static const FontWeight heavy = FontWeight.w500;
}

//Color
class AppTextColor {
  static const Color white = Color(0xFFFFFFFF);
  static const Color light = Color(0xFFbebebe);
  static const Color medium = Color(0xFF656565);
  static const Color dark = Color(0xFF494949);
  static const Color black = Color(0xFF222222);
}

//AppBar
const TextStyle kAppBarTitle = TextStyle(
  color: Colors.white,
  fontSize: 25.0,
  fontWeight: FontWeight.w300,
);
//Header
const TextStyle kHeaderText = TextStyle(
  color: Colors.black,
  fontSize: 24.0,
  fontWeight: FontWeight.w300,
);
//Text
const TextStyle kBodyText = TextStyle(
  color: Colors.black,
  fontSize: 18.0,
  fontWeight: FontWeight.w300,
);
