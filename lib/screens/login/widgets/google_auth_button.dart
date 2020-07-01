import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

//this is not currently in use but the template is here if implemented
class GoogleAuthButton extends StatelessWidget {
  //constructor
  GoogleAuthButton({@required this.text, @required this.onPress});
  final String text;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: AppTextSize.medium * MediaQuery.of(context).size.width),
            Padding(
              padding: EdgeInsets.only(left: 2),
              child: Text(
                text,
                style: TextStyle(
                  fontSize:
                      AppTextSize.small * MediaQuery.of(context).size.width,
                  color: kGreenDark,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
