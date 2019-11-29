import 'package:flutter/material.dart';

//COLOURS

//Greens
const Color kGreenDark = Color(0xFF207561);
const Color kGreenMedium = Color(0xFF589167);
const Color kGreenLight = Color(0xFFA0cc78);
//Accents
const Color kBackgroundLight = Colors.white;
const Color kDialogBackground = kGreenLight;
//Group Colors
const List<Color> kGroupColors = [
  kGreenDark,
  kGreenMedium,
  kGreenLight,
  Colors.blueAccent,
  Colors.lightBlue,
  Colors.cyan,
  Colors.deepOrangeAccent,
  Colors.orange,
  Colors.orangeAccent,
];
//Convert DB RGB color to color opacity isn't stored so set to 1
Color convertColor({@required List<dynamic> storedColor}) {
  return storedColor == null
      ? kGreenDark
      : Color.fromRGBO(storedColor[0], storedColor[1], storedColor[2], 1);
}

//SHADOWS

//Box Shadow
const Color kShadowColor = Color(0x66000000);
const List<Shadow> kShadowText = [Shadow(color: kShadowColor, blurRadius: 5.0)];
const List<BoxShadow> kShadowBox = [
  BoxShadow(
    color: kShadowColor,
    blurRadius: 3.0,
    offset: Offset(
      0.0,
      2.0,
    ),
  ),
];

//Standard Box Decoration
const BoxDecoration kButtonBoxDecoration = BoxDecoration(
  boxShadow: kShadowBox,
  image: DecorationImage(
    image: AssetImage('assets/images/default.png'),
    fit: BoxFit.cover,
  ),
);
