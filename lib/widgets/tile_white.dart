import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';

class TileWhite extends StatelessWidget {
  final Widget child;
  final double bottomPadding;
  TileWhite({@required this.child, this.bottomPadding});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: EdgeInsets.only(
        left: 5.0,
        right: 5.0,
        top: 5.0,
        bottom: bottomPadding == null ? 25.0 : bottomPadding,
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
