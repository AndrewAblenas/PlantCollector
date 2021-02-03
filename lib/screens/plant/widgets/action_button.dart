import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Function action;
  ActionButton({@required this.icon, @required this.action});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(10.0),
      child: Icon(
        icon,
        size: AppTextSize.huge * MediaQuery.of(context).size.width,
        color: kGreenDark50,
      ),
      onPressed: () {
        action();
      },
    );
  }
}
