import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/widgets/dialogs/dialog_template.dart';
import 'package:plant_collector/formats/colors.dart';

class DialogConfirm extends StatelessWidget {
  final String title;
  final String text;
  final String buttonText;
  final Function onPressed;
  final Function onCancel;
  final bool hideCancel;
  DialogConfirm(
      {this.title,
      this.text,
      @required this.onPressed,
      this.onCancel,
      this.buttonText = 'CONFIRM',
      this.hideCancel});

  @override
  Widget build(BuildContext context) {
    return DialogTemplate(
      title: title,
      text: text,
      list: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            hideCancel == false
                ? Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (onCancel != null) onCancel();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'CANCEL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppTextSize.medium *
                              MediaQuery.of(context).size.width,
                          fontWeight: AppTextWeight.heavy,
                          color: kButtonCancel,
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
//            SizedBox(),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  onPressed();
                },
                child: Text(
                  buttonText.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize:
                        AppTextSize.medium * MediaQuery.of(context).size.width,
                    fontWeight: AppTextWeight.heavy,
                    color: kButtonAccept,
                  ),
                ),
              ),
            ),
//            hideCancel == true
//                ? SizedBox(
//                    width: 20.0,
//                  )
//                : SizedBox(),
          ],
        ),
      ],
    );
  }
}
