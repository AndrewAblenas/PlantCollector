import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class GoogleAuthButton extends StatelessWidget {
  final String text;
  final Function onPress;
  GoogleAuthButton({@required this.text, @required this.onPress});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      splashColor: Colors.grey,
      onTap: () {
        onPress();
      },
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//      highlightElevation: 0,
//      borderSide: BorderSide(color: Colors.grey),
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
