import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/widgets/dialogs/dialog_template.dart';

class DialogInput extends StatelessWidget {
  final String title;
  final String text;
  final Function onPressedSubmit;
  final String hintText;
  final Function onChangeInput;
  final Function onPressedCancel;
  DialogInput({
    @required this.title,
    @required this.text,
    this.onPressedSubmit,
    this.hintText,
    @required this.onChangeInput,
    @required this.onPressedCancel,
  });

  @override
  Widget build(BuildContext context) {
    return DialogTemplate(
      title: title,
      text: text,
      list: <Widget>[
        TextField(
          decoration: InputDecoration(hintText: hintText),
          autofocus: true,
          textAlign: TextAlign.center,
          minLines: 1,
          maxLines: 10,
          onChanged: onChangeInput,
          style: TextStyle(
            fontSize: AppTextSize.small * MediaQuery.of(context).size.width,
          ),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
//            RaisedButton(
//              color: kGreenDark,
//              textColor: Colors.white,
//              child: Text(
//                'Cancel',
//                style: TextStyle(
//                    fontWeight: AppTextWeight.medium,
//                    fontSize:
//                        AppTextSize.medium * MediaQuery.of(context).size.width),
//              ),
//              onPressed: onPressedCancel,
//            ),
            RaisedButton(
              color: kGreenDark,
              textColor: Colors.white,
              child: Text(
                'Submit',
                style: TextStyle(
                    fontWeight: AppTextWeight.medium,
                    fontSize:
                        AppTextSize.medium * MediaQuery.of(context).size.width),
              ),
              onPressed: onPressedSubmit,
            ),
          ],
        ),
      ],
    );
  }
}
