import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';

class SearchBarWrapper extends StatelessWidget {
  final Widget child;
  final double marginVertical;
  SearchBarWrapper({
    @required this.child,
    this.marginVertical,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: marginVertical ?? 15,
        bottom: marginVertical ?? 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: kBackgroundGradientMidReversed,
        boxShadow: kShadowBox,
      ),
      child: child,
    );
  }
}
