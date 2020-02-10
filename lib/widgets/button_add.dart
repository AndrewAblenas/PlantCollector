import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/widgets/container_card.dart';

class ButtonAdd extends StatelessWidget {
  final String buttonText;
  final Function onPress;
  final Color buttonColor;
  final IconData icon;
  final Color textColor;
  ButtonAdd(
      {@required this.buttonText,
      @required this.onPress,
      @required this.buttonColor,
      this.icon,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return ContainerCard(
      color: buttonColor != null ? buttonColor : kGreenDark,
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        textColor: AppTextColor.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon != null ? icon : Icons.add,
              size: AppTextSize.huge * MediaQuery.of(context).size.width,
              color: textColor != null ? textColor : AppTextColor.white,
            ),
            Text(
              '   $buttonText',
              style: TextStyle(
                color: textColor != null ? textColor : AppTextColor.white,
                fontSize: AppTextSize.huge * MediaQuery.of(context).size.width,
                fontWeight: AppTextWeight.medium,
//                shadows: kShadowText,
              ),
            ),
          ],
        ),
        onPressed: () {
          onPress();
        },
      ),
    );
  }
}
