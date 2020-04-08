import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';

class TileWhite extends StatelessWidget {
  final Widget child;
  final double bottomPadding;
  final double leftPadding;
  final double rightPadding;
  TileWhite(
      {@required this.child,
      this.bottomPadding = 25.0,
      this.leftPadding = 5.0,
      this.rightPadding = 5.0});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: 5.0,
        bottom: bottomPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: kShadowBox,
        color: kBackgroundLight,
      ),
      child: child,
    );
  }
}
