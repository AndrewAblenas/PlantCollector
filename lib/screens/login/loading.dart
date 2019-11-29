import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:plant_collector/screens/login/route.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: RouteScreen(),
      backgroundColor: kGreenLight,
      loaderColor: kGreenDark,
      image: Image.asset('assets/images/app_icon_white_512.png'),
      photoSize: 120.0,
    );
  }
}
