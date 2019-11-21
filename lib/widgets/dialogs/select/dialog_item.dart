import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

//THEME TEMPLATE FOR SELECTABLE BUTTONS USED IN POPUP DIALOG

class DialogItem extends StatelessWidget {
  final String buttonText;
  final Function onPress;
  DialogItem({
    @required this.buttonText,
    @required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: kGreenDark,
      textColor: AppTextColor.white,
      child: Container(
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: AppTextSize.medium * MediaQuery.of(context).size.width,
            fontWeight: AppTextWeight.medium,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      onPressed: () {
        onPress();
      },
    );
  }
}
