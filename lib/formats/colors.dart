import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';

//COLOURS

//Greens
const Color kGreenDark = Color(0xFF207561);
const Color kGreenMedium = Color(0xFF589167);
const Color kGreenMediumOpacity = Color(0x99589167);
const Color kGreenLight = Color(0xFFA0cc78);
const Color kGreyDark = Color(0xFF222222);
const Color kGrey = Color(0xFF555555);
const Color kLight = Color(0xFFDDDDDD);

//const Color kGreenDark = Color(0xFF16563A);
//const Color kGreenMedium = Color(0xFF316F26);
//const Color kGreenLight = Color(0xFF9CD473);
//Blue
const Color kBlue = Color(0xFF3CA3C6);
const Color kBlueGreen = Color(0xFF12B5A0);
const Color kBlueGreener = Color(0xFF28E98A);
//Other
const Color kButtonAccept = Color(0xFFbcdba0);
const Color kButtonCancel = Color(0xFFffcccc);
//Accents
const Color kBackgroundLight = Colors.white;
//Group Colors
const List<Color> kGroupColors = [
  Colors.red,
  Colors.deepOrangeAccent,
  Colors.orange,
  Colors.yellow,
  kGreenDark,
  kGreenMedium,
  kGreenLight,
  Colors.greenAccent,
  Colors.indigo,
  Colors.indigoAccent,
  Colors.blueAccent,
  Colors.blue,
  Colors.deepPurple,
  Colors.purple,
  Colors.purpleAccent,
  Colors.pinkAccent,
  kGreyDark,
  kGrey,
  Colors.brown,
  kLight,
];
//Convert DB RGB color to color opacity isn't stored so set to 1
Color convertColor({@required List<dynamic> storedColor}) {
  return (storedColor == null || storedColor.length != 3)
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
//  boxShadow: kShadowBox,
  image: DecorationImage(
    image: AssetImage('assets/images/default.png'),
    fit: BoxFit.cover,
  ),
);

//Background gradient decoration
const Gradient kBackgroundGradient = LinearGradient(
  colors: [kGreenDark, kGreenLight],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

const Gradient kBackgroundGradientReversed = LinearGradient(
  colors: [kGreenDark, kGreenLight],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const Gradient kBackgroundGradientMid = LinearGradient(
  colors: [kGreenDark, kGreenMedium],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

const Gradient kBackgroundGradientMidReversed = LinearGradient(
  colors: [kGreenDark, kGreenMedium],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const Gradient kBackgroundGradientSolidDark = LinearGradient(
  colors: [kGreenDark, kGreenDark],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

const Gradient kBackgroundGradientSolidLight = LinearGradient(
  colors: [kGreenLight, kGreenLight],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

const Gradient kBackgroundGradientSolidGrey = LinearGradient(
  colors: [AppTextColor.light, AppTextColor.light],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

const Gradient kBackgroundGradientBlues = LinearGradient(
  colors: [kBlue, kBlueGreen, kBlueGreener],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);
