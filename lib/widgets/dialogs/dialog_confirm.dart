import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/widgets/dialogs/dialog_template.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:provider/provider.dart';

class DialogConfirm extends StatelessWidget {
  final String title;
  final String text;
  final String buttonText;
  final Function onPressed;
  DialogConfirm({this.title, this.text, this.onPressed, this.buttonText});

  @override
  Widget build(BuildContext context) {
    Provider.of<UIBuilders>(context).loadingIndicator = false;
    return DialogTemplate(
      title: title,
      text: text,
      list: <Widget>[
        //TODO loading indicator doesn't work
        ModalProgressHUD(
          inAsyncCall: Provider.of<UIBuilders>(context).loadingIndicator,
          child: RaisedButton(
            color: kGreenDark,
            textColor: Colors.white,
            child: Text(
              buttonText == null ? 'Confirm' : buttonText,
              style: TextStyle(
                fontWeight: AppTextWeight.medium,
                fontSize:
                    AppTextSize.medium * MediaQuery.of(context).size.width,
              ),
            ),
            onPressed: () {
              onPressed();
            },
          ),
        ),
      ],
    );
  }
}
