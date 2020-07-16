import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';

//THEME TEMPLATE FOR SELECTABLE BUTTONS USED IN POPUP DIALOG

class DialogItem extends StatelessWidget {
  final String buttonText;
  final Function onPress;
  final String id;
  DialogItem({@required this.buttonText, @required this.onPress, this.id});

  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    //get the screen width for scaling
    double width = MediaQuery.of(context).size.width;

    //show automatic generated image
    bool autoGen =
        (id != null && DBDefaultDocument.collectionAutoGen.contains(id));

    Widget leading = //show a star for automatically generated shelves
        (autoGen == false)
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(
                  Icons.star,
                  size: AppTextSize.large * width,
                  color: AppTextColor.whitish,
                ),
              );

    //*****SET WIDGET VISIBILITY END*****//

    return GestureDetector(
      //by default tap on transparent things like colorless box doesn't register
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onPress();
      },
      child: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppTextSize.small * width,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  leading,
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 0.80 * width,
                    ),
                    child: Text(
                      buttonText.toUpperCase(),
                      style: TextStyle(
                        fontSize: AppTextSize.huge * width,
                        fontWeight: AppTextWeight.heavy,
                        color: AppTextColor.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1.0,
              color: kGreenDark,
            ),
          ],
        ),
      ),
    );
  }
}
