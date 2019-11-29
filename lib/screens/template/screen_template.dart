import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/formats/colors.dart';

class ScreenTemplate extends StatelessWidget {
  final String screenTitle;
  final Widget child;
  ScreenTemplate({
    @required this.screenTitle,
    @required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenLight,
      appBar: AppBar(
        backgroundColor: kGreenDark,
        centerTitle: true,
        elevation: 20.0,
        title: Text(
          screenTitle,
          style: kAppBarTitle,
        ),
      ),
      body: child != null ? child : SizedBox(),
    );
  }
}
