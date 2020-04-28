import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_select.dart';
import 'package:plant_collector/widgets/get_image.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/formats/colors.dart';

class AddPlant extends StatelessWidget {
  final String collectionID;
  AddPlant({
    @required this.collectionID,
  });

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
          //initialize data
          Map data;
          //first input the data for the plant
          showDialog(
              context: context,
              builder: (context) {
                return DialogScreenInput(
                    title: 'Nickname your ${GlobalStrings.plant}',
                    acceptText: 'Add',
                    acceptOnPress: () async {
                      data = Provider.of<AppData>(context)
                          .plantNew(collectionID: collectionID);
                      try {
                        //add new plant to userPlants
                        await CloudDB.setDocumentL1(
                          collection: DBFolder.plants,
                          document: data[PlantKeys.id],
                          data: data,
                        );
                        //add plant reference to collection
                        await Provider.of<CloudDB>(context)
                            .updateArrayInDocumentInCollection(
                                arrayKey: CollectionKeys.plants,
                                entries: [data[PlantKeys.id]],
                                folder: DBFolder.collections,
                                documentName: collectionID,
                                action: true);
                        //add the last plant creation time to user file
                        Map<String, dynamic> update = {
                          UserKeys.lastPlantAdd:
                              DateTime.now().millisecondsSinceEpoch
                        };
                        await CloudDB.updateDocumentL1(
                            collection: DBFolder.users,
                            document:
                                Provider.of<CloudDB>(context).currentUserFolder,
                            data: update);
                        //pop the first window
                        Navigator.pop(context);
                        //add image functionality
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DialogScreenSelect(
                              title: 'Add a Photo',
                              items: [
                                GetImage(
                                    imageFromCamera: true,
                                    plantCreationDate: data[PlantKeys.created],
                                    largeWidget: false,
                                    widgetScale: 1.0,
                                    pop: true,
                                    plantID: data[PlantKeys.id]),
                                SizedBox(
                                  height: 20.0,
                                ),
                                GetImage(
                                    imageFromCamera: false,
                                    plantCreationDate: data[PlantKeys.created],
                                    largeWidget: false,
                                    widgetScale: 1.0,
                                    pop: true,
                                    plantID: data[PlantKeys.id]),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        //if something fails (likely plant add or collection reference add)
                        Navigator.pop(context);
                      }
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
