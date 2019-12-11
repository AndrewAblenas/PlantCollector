import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/widgets/dialogs/dialog_template.dart';

//DIALOG WITH A LIST OF BUTTONS TO PROVIDE USER INPUT

class DialogSelect extends StatelessWidget {
  final String title;
  final String text;
  final String plantID;
  final List<Widget> menuItems;
  final String temp;
  DialogSelect(
      {this.title,
      this.text,
      this.plantID,
      @required this.menuItems,
      @required this.temp});

  @override
  Widget build(BuildContext context) {
    return DialogTemplate(
      title: title,
      text: text,
      list: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                10.0,
              ),
            ),
            color: kGreenMedium,
            border: Border.all(
              color: kGreenDark,
              width: 1.0,
            ),
          ),
          width: 280.0 * MediaQuery.of(context).size.width * kScaleFactor,
          constraints: BoxConstraints(
            maxHeight: 125.0 * MediaQuery.of(context).size.width * kScaleFactor,
          ),
          child: Scrollbar(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 5.0,
                bottom: 5.0,
                left: 10.0,
                right: 10.0,
              ),
              children: menuItems,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                color: kGreenDark,
                textColor: Colors.white,
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    fontWeight: AppTextWeight.medium,
                    fontSize:
                        AppTextSize.medium * MediaQuery.of(context).size.width,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
