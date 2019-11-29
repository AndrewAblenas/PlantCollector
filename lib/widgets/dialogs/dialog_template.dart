import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/formats/colors.dart';

class DialogTemplate extends StatelessWidget {
  final String title;
  final String text;
  final List<Widget> list;
  DialogTemplate(
      {@required this.title, @required this.text, @required this.list});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: kDialogBackground,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppTextSize.medium * MediaQuery.of(context).size.width,
        ),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 1.0,
              width: double.infinity,
              child: Container(
                color: kGreenDark,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              text != null ? '$text' : '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTextSize.small * MediaQuery.of(context).size.width,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
              children: list,
            )
          ],
        ),
      ),
    );
  }
}
