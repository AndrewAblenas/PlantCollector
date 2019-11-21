import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/formats/colors.dart';

class CollectionDelete extends StatelessWidget {
  final String collectionID;
  CollectionDelete({@required this.collectionID});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kButtonBoxDecoration,
      child: FlatButton(
        padding: EdgeInsets.all(10.0),
        child: CircleAvatar(
          foregroundColor: kGreenDark,
          backgroundColor: Colors.white,
          radius: AppTextSize.medium * MediaQuery.of(context).size.width,
          child: Icon(
            Icons.delete_forever,
            size: AppTextSize.huge * MediaQuery.of(context).size.width,
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogConfirm(
                title: 'Delete Collection',
                text: 'Are you sure you want to delete this collection?',
                buttonText: 'Delete Collection',
                onPressed: () {
                  Provider.of<CloudDB>(context).deleteDocumentFromCollection(
                      documentID: collectionID, collection: kUserCollections);
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
