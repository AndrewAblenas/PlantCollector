import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/formats/colors.dart';

class DialogColorPicker extends StatelessWidget {
  final String title;
  final Function onPressed;
  final String groupID;
  DialogColorPicker(
      {@required this.title, @required this.onPressed, @required this.groupID});

  @override
  Widget build(BuildContext context) {
    Provider.of<AppData>(context).loadingStatus = false;
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title != null ? title.toUpperCase() : '',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppTextSize.small * MediaQuery.of(context).size.width,
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
            Container(
//              decoration: BoxDecoration(
//                border: Border.all(
//                  color: kGreenDark,
//                  width: 1.0,
//                ),
//              ),
              height: 220 * MediaQuery.of(context).size.width * kScaleFactor,
              width: 300 * MediaQuery.of(context).size.width * kScaleFactor,
              child: ListView(
                primary: false,
                children: <Widget>[
                  GridView.count(
                    crossAxisCount: 3,
                    primary: false,
                    shrinkWrap: true,
                    children: Provider.of<UIBuilders>(context).colorButtonsList(
                        colors: kGroupColors,
                        onPress: onPressed,
                        groupID: groupID),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
