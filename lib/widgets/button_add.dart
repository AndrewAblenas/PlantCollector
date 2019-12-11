import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/widgets/container_card.dart';

class ButtonAdd extends StatelessWidget {
  final String buttonText;
  final Function onPress;
  final Color buttonColor;
  ButtonAdd(
      {@required this.buttonText,
      @required this.onPress,
      @required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return ContainerCard(
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        textColor: AppTextColor.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '+   $buttonText',
              style: TextStyle(
                color: AppTextColor.white,
                fontSize: AppTextSize.huge * MediaQuery.of(context).size.width,
                fontWeight: AppTextWeight.medium,
                shadows: kShadowText,
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
