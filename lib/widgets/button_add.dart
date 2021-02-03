import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class ButtonAdd extends StatelessWidget {
  final String buttonText;
  final Function onPress;
  final IconData icon;
  final Color textColor;
  final double scale;
  ButtonAdd(
      {@required this.buttonText,
      @required this.onPress,
      this.icon,
      this.textColor,
      this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(
          top: 5.0 * MediaQuery.of(context).size.width * kScaleFactor,
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
            boxShadow: kShadowBox,
            borderRadius: BorderRadius.all(
              Radius.circular(
                10.0,
              ),
            ),
            gradient: kGradientGreenVerticalDarkMed),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '   $buttonText',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor != null ? textColor : AppTextColor.white,
                fontSize: scale *
                    AppTextSize.huge *
                    MediaQuery.of(context).size.width,
                fontWeight: AppTextWeight.heavy,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  icon != null ? icon : Icons.add_circle,
                  size: scale *
                      AppTextSize.huge *
                      MediaQuery.of(context).size.width,
                  color: textColor != null ? textColor : AppTextColor.white,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        onPress();
      },
    );
  }
}
