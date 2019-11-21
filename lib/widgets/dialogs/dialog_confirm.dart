import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/widgets/dialogs/dialog_template.dart';
import 'package:plant_collector/formats/colors.dart';

class DialogConfirm extends StatelessWidget {
  final String title;
  final String text;
  final String buttonText;
  final Function onPressed;
  DialogConfirm({this.title, this.text, this.onPressed, this.buttonText});

  @override
  Widget build(BuildContext context) {
    return DialogTemplate(
      title: title,
      text: text,
      list: <Widget>[
        RaisedButton(
          color: kGreenDark,
          textColor: Colors.white,
          child: Text(
            buttonText == null ? 'Confirm' : buttonText,
            style: TextStyle(
              fontWeight: AppTextWeight.medium,
              fontSize: AppTextSize.medium * MediaQuery.of(context).size.width,
            ),
          ),
          onPressed: () {
            onPressed();
          },
        ),
      ],
    );
  }
}
