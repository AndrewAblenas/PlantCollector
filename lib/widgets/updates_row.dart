import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class UpdatesRow extends StatelessWidget {
  final String text;
  final IconData icon;
  final double textSize;
  final MainAxisAlignment mainAxisAlignment;
  UpdatesRow({
    @required this.text,
    @required this.icon,
    @required this.textSize,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: <Widget>[
        Icon(
          icon,
          size: textSize * MediaQuery.of(context).size.width,
          color: kGreenMedium,
        ),
        SizedBox(
          width: 2.0,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: textSize * MediaQuery.of(context).size.width,
            fontWeight: AppTextWeight.medium,
            color: AppTextColor.black,
          ),
        ),
      ],
    );
  }
}
