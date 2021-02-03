import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';

class TileWhite extends StatelessWidget {
  final Widget child;
  final double bottomPadding;
  final double topPadding;
  final double leftPadding;
  final double rightPadding;
  TileWhite(
      {@required this.child,
      this.bottomPadding = 1.0,
      this.topPadding = 1.0,
      this.leftPadding = 1.0,
      this.rightPadding = 1.0});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      margin: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: kShadowBox,
        color: kBackgroundLight,
      ),
      child: child,
    );
  }
}
