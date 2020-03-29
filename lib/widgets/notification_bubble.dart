import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class NotificationBubble extends StatelessWidget {
  const NotificationBubble({
    @required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: kGreenDark,
        borderRadius: BorderRadius.all(
          Radius.circular(2.0),
        ),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: AppTextSize.small * MediaQuery.of(context).size.width,
          color: AppTextColor.white,
        ),
      ),
    );
  }
}
