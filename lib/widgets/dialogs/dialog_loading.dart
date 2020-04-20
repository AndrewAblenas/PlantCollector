import 'package:flutter/material.dart';
import 'package:plant_collector/widgets/dialogs/dialog_template.dart';
import 'package:plant_collector/widgets/rotating_indicator.dart';

class DialogLoading extends StatelessWidget {
  final String title;
  final String text;
  DialogLoading({this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return DialogTemplate(
      title: title,
      text: text,
      list: <Widget>[
        RotatingIndicator(),
      ],
    );
  }
}
