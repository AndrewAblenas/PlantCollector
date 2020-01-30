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
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical:
                      AppTextSize.small * MediaQuery.of(context).size.width,
                  horizontal: 0.0),
              child: Text(
                buttonText.toUpperCase(),
                style: TextStyle(
                  fontSize:
                      AppTextSize.huge * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.heavy,
                  color: AppTextColor.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 1.0,
              color: kGreenDark,
            ),
          ],
        ),
      ),
    );
//    return GestureDetector(
//      child: Text(
//        buttonText,
//        style: TextStyle(
//          fontSize: AppTextSize.medium * MediaQuery.of(context).size.width,
//          fontWeight: AppTextWeight.medium,
//        ),
//        textAlign: TextAlign.center,
//      ),
//      onTap: () {
//        onPress();
//      },
//    );
  }
}
