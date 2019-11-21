import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';

class MenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  MenuItem({
    @required this.label,
    @required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Icon(
          icon,
          color: kGreenDark,
          size: 25.0,
        ),
        SizedBox(
          width: 20.0,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }
}
