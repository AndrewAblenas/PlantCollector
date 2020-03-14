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
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              gradient: kBackgroundGradientMid,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  5.0,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 30.0,
              ),
              child: Row(
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/images/app_icon_white_512.png'),
                    height:
                        AppTextSize.huge * MediaQuery.of(context).size.width,
                  ),
                  Text(
                    ' $text',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          AppTextSize.huge * MediaQuery.of(context).size.width,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: onPress,
        ),
        SizedBox(
          width: 50.0,
        ),
      ],
    );
  }
}
