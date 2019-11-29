import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';

class ContainerWrapper extends StatelessWidget {
  final Widget child;
  final Color color;
  ContainerWrapper({
    @required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color != null ? color : kGreenMedium,
        boxShadow: kShadowBox,
      ),
      child: child,
    );
  }
}
