import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/widgets/dialogs/dialog_input.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/formats/colors.dart';

class CollectionAddPlant extends StatelessWidget {
  final String collectionID;
  CollectionAddPlant({@required this.collectionID});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kButtonBoxDecoration,
      child: FlatButton(
        padding: EdgeInsets.all(10.0),
        child: CircleAvatar(
          foregroundColor: kGreenDark,
          backgroundColor: Colors.white,
          radius: 20.0 * MediaQuery.of(context).size.width * kTextScale,
          child: Icon(
            Icons.add,
            size: 35.0 * MediaQuery.of(context).size.width * kTextScale,
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogInput(
                title: 'Create Plant',
                text: 'Please provide the name of your new plant',
                onPressedSubmit: () {
                  //DB upgrade
                  Map data = Provider.of<AppData>(context).plantNewDB().toMap();
                  Provider.of<CloudDB>(context).insertDocumentToCollection(
                      data: data,
                      collection: kUserPlants,
                      documentName: data[kPlantID]);
                  //add plant reference to collection
                  Provider.of<CloudDB>(context)
                      .updateArrayInDocumentInCollection(
                          arrayKey: kCollectionPlantList,
                          entries: [data[kPlantID]],
                          folder: kUserCollections,
                          documentName: collectionID,
                          action: true);
                  Navigator.pop(context);
                },
                onChangeInput: (input) {
                  Provider.of<AppData>(context).newDataInput = input;
                },
                onPressedCancel: () {
                  Provider.of<AppData>(context).newDataInput = null;
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
