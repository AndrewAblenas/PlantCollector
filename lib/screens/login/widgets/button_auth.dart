import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class ButtonAuth extends StatelessWidget {
  final String text;
  final Function onPress;
  ButtonAuth({@required this.text, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 50.0,
        ),
        RaisedButton(
          color: kGreenDark,
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      AppTextSize.huge * MediaQuery.of(context).size.width,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          onPressed: onPress,
        ),
        SizedBox(
          width: 50.0,
        ),
      ],
    );
  }
}
