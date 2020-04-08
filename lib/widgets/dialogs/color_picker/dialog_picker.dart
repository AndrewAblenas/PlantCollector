import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/formats/colors.dart';

class DialogPicker extends StatelessWidget {
  final String title;
  final int columns;
  final double listViewHeight;
//  final Function onPressed;
//  final String collectionID;
  final List<Widget> widgets;
  DialogPicker(
      {@required this.title,
//      @required this.onPressed,
//      @required this.collectionID,
      @required this.widgets,
      this.columns = 4,
      this.listViewHeight});

  @override
  Widget build(BuildContext context) {
//    Provider.of<AppData>(context).loadingStatus = false;
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
              height: listViewHeight != null
                  ? listViewHeight
                  : 360 * MediaQuery.of(context).size.width * kScaleFactor,
              width: 300 * MediaQuery.of(context).size.width * kScaleFactor,
              child: ListView(
                primary: false,
                children: <Widget>[
                  GridView.count(
                    crossAxisCount: columns,
                    crossAxisSpacing:
                        AppTextSize.small * MediaQuery.of(context).size.width,
                    mainAxisSpacing:
                        AppTextSize.small * MediaQuery.of(context).size.width,
                    primary: false,
                    shrinkWrap: true,
                    children: widgets,
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
