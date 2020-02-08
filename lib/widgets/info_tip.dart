import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';

class InfoTip extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function onPress;
  InfoTip({@required this.text, this.icon, this.onPress});

  @override
  Widget build(BuildContext context) {
    return TileWhite(
      child: FlatButton(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              //if no icon provided use default
              icon != null ? icon : Icons.help_outline,
              color: kGreenDark,
              size: AppTextSize.medium * MediaQuery.of(context).size.width,
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              width: 0.60 * MediaQuery.of(context).size.width,
              child: Text(
                text,
                style: TextStyle(
                  color: AppTextColor.medium,
                  fontWeight: AppTextWeight.medium,
                  fontSize:
                      AppTextSize.small * MediaQuery.of(context).size.width,
                ),
              ),
            )
          ],
        ),
        onPressed: () {
          onPress();
        },
      ),
    );
  }
}
