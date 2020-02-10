import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/screens/dialog/dialog_screen.dart';

class DialogScreenSelect extends StatelessWidget {
  final String title;
  final List<Widget> items;
  DialogScreenSelect({
    @required this.title,
    @required this.items,
  });
  @override
  Widget build(BuildContext context) {
    List<Widget> noItems = [
      Text(
        'no items to select',
        style: TextStyle(
          color: AppTextColor.white,
          fontSize: AppTextSize.large * MediaQuery.of(context).size.width,
        ),
      )
    ];
    return DialogScreen(
      title: title,
      children: <Widget>[
        Column(
          children: items.length >= 1 ? items : noItems,
        ),
        SizedBox(
          height: AppTextSize.large * MediaQuery.of(context).size.width,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    fontSize:
                        AppTextSize.large * MediaQuery.of(context).size.width,
                    fontWeight: AppTextWeight.medium,
                    color: kButtonCancel,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
