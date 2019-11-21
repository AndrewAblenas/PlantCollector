import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';

class GroupDelete extends StatelessWidget {
  final String groupID;
  GroupDelete({@required this.groupID});

  @override
  Widget build(BuildContext context) {
    return TileWhite(
      child: FlatButton(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.delete_forever,
              color: kGreenDark,
              size: AppTextSize.medium * MediaQuery.of(context).size.width,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'This group is empty.  Tap here to delete.',
              style: TextStyle(
                color: AppTextColor.medium,
                fontWeight: AppTextWeight.medium,
                fontSize: AppTextSize.small * MediaQuery.of(context).size.width,
              ),
            )
          ],
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogConfirm(
                title: 'Delete Group',
                text: 'Are you sure you want to delete this Group?',
                buttonText: 'Delete Group',
                onPressed: () {
                  Provider.of<CloudDB>(context).deleteDocumentFromCollection(
                      documentID: groupID, collection: kUserGroups);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}
