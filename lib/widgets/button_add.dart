import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class ButtonAdd extends StatelessWidget {
  final String buttonText;
  final Function onPress;
  final Widget dialog;
  final Color buttonColor;
  ButtonAdd(
      {this.buttonText, this.onPress, this.dialog, @required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: RaisedButton(
          textColor: AppTextColor.white,
          color: buttonColor,
          elevation: 5.0,
          hoverElevation: 10.0,
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add,
                size: AppTextSize.huge * MediaQuery.of(context).size.width,
              ),
              Text(
                '  $buttonText',
                style: TextStyle(
                  color: AppTextColor.white,
                  fontSize:
                      AppTextSize.huge * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.medium,
                  shadows: kShadowText,
                ),
              ),
            ],
          ),
          onPressed: () {
            if (onPress != null) {
              onPress();
            }
            if (dialog != null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return dialog;
                },
              );
            }
          }),
    );
  }
}
