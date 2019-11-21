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
  DialogSelect({this.title, this.text, this.plantID, @required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return DialogTemplate(
      title: title,
      text: text,
      list: <Widget>[
        Container(
            decoration: BoxDecoration(
              color: kGreenMedium,
              border: Border.all(
                color: kGreenDark,
                width: 1.0,
              ),
            ),
            height: 75.0 * MediaQuery.of(context).size.width * kTextScale,
            width: 280.0 * MediaQuery.of(context).size.width * kTextScale,
            child: Scrollbar(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                children: menuItems,
              ),
            )),
        SizedBox(height: 20.0),
        RaisedButton(
          color: kGreenDark,
          textColor: Colors.white,
          child: Text(
            'Cancel',
            style: TextStyle(
              fontWeight: AppTextWeight.medium,
              fontSize: AppTextSize.medium * MediaQuery.of(context).size.width,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
