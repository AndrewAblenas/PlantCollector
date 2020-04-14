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

    //show automatic generated image
    bool autoGen =
        (id != null && DBDefaultDocument.collectionAutoGen.contains(id));

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
                  vertical:
                      AppTextSize.small * MediaQuery.of(context).size.width,
                  horizontal: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (autoGen == false)
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Icon(
                            Icons.star,
                            size: AppTextSize.large *
                                MediaQuery.of(context).size.width,
                            color: AppTextColor.whitish,
                          ),
                        ),
                  Text(
                    buttonText.toUpperCase(),
                    style: TextStyle(
                      fontSize:
                          AppTextSize.huge * MediaQuery.of(context).size.width,
                      fontWeight: AppTextWeight.heavy,
                      color: AppTextColor.white,
                    ),
                    textAlign: TextAlign.center,
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
