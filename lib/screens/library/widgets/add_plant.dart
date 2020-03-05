import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/formats/colors.dart';

class AddPlant extends StatelessWidget {
  final String collectionID;
  AddPlant({@required this.collectionID});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kButtonBoxDecoration,
      child: FlatButton(
        padding: EdgeInsets.all(10.0),
        child: CircleAvatar(
          foregroundColor: kGreenDark,
          backgroundColor: Colors.white,
          radius: 20.0 * MediaQuery.of(context).size.width * kScaleFactor,
          child: Icon(
            Icons.add,
            size: 35.0 * MediaQuery.of(context).size.width * kScaleFactor,
          ),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DialogScreenInput(
                    title: 'Nickname your ${GlobalStrings.plant}',
                    acceptText: 'Add',
                    acceptOnPress: () {
                      Map data =
                          Provider.of<AppData>(context).plantNew().toMap();
                      //add new plant to userPlants
                      Provider.of<CloudDB>(context).insertDocumentToCollection(
                          data: data,
                          collection: DBFolder.plants,
                          documentName: data[PlantKeys.id]);
                      //add plant reference to collection
                      Provider.of<CloudDB>(context)
                          .updateArrayInDocumentInCollection(
                              arrayKey: CollectionKeys.plants,
                              entries: [data[PlantKeys.id]],
                              folder: DBFolder.collections,
                              documentName: collectionID,
                              action: true);
                      Navigator.pop(context);
                    },
                    onChange: (input) {
                      Provider.of<AppData>(context).newDataInput = input;
                    },
                    cancelText: 'Cancel',
                    hintText: null);
              });
        },
      ),
    );
  }
}
