import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/bloom_data.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_select.dart';
import 'package:plant_collector/widgets/dialogs/select/dialog_item.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';

//Dialog Buttons

//Group
class DialogItemGroup extends StatelessWidget {
  final String buttonText;
  final String buttonPossibleParentID;
  final String entryID;
  final String currentParentID;
  DialogItemGroup({
    @required this.buttonText,
    @required this.buttonPossibleParentID,
    @required this.entryID,
    @required this.currentParentID,
  });

  @override
  Widget build(BuildContext context) {
    return DialogItem(
        buttonText: buttonText,
        onPress: () {
          Provider.of<CloudDB>(context).updateArrayInDocumentInCollection(
              arrayKey: GroupKeys.collections,
              entries: [entryID],
              folder: DBFolder.groups,
              documentName: buttonPossibleParentID,
              action: true);
          Provider.of<CloudDB>(context).updateArrayInDocumentInCollection(
              arrayKey: GroupKeys.collections,
              entries: [entryID],
              folder: DBFolder.groups,
              documentName: currentParentID,
              action: false);
          Navigator.pop(context);
        });
  }
}

//Group
class DialogItemCollection extends StatelessWidget {
  final String buttonText;
  final String buttonPossibleParentID;
  final String entryID;
  final String currentParentID;
  DialogItemCollection({
    @required this.buttonText,
    @required this.buttonPossibleParentID,
    @required this.entryID,
    @required this.currentParentID,
  });

  @override
  Widget build(BuildContext context) {
    return DialogItem(
        buttonText: buttonText,
        onPress: () {
          Provider.of<CloudDB>(context).updateArrayInDocumentInCollection(
              arrayKey: CollectionKeys.plants,
              entries: [entryID],
              folder: DBFolder.collections,
              documentName: buttonPossibleParentID,
              action: true);
          Provider.of<CloudDB>(context).updateArrayInDocumentInCollection(
              arrayKey: CollectionKeys.plants,
              entries: [entryID],
              folder: DBFolder.collections,
              documentName: currentParentID,
              action: false);
          Navigator.pop(context);
        });
  }
}

//Plant Entry Data
class DialogItemPlant extends StatelessWidget {
  final String buttonText;
  final String buttonKey;
  final String plantID;
  final int timeCreated;
  final bool showDatePickerInstead;
  final Map showListInput;
  DialogItemPlant({
    @required this.buttonText,
    @required this.buttonKey,
    @required this.plantID,
    @required this.timeCreated,
    @required this.showDatePickerInstead,
    this.showListInput,
  });

  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    //*****SET WIDGET VISIBILITY END*****//

    return DialogItem(
      buttonText: buttonText,
      onPress: () {
        //this has to be at the top otherwise a focusScope issue arises
        if (showListInput != null) {
          Navigator.pop(context);
          //set to default to store future data
          Provider.of<AppData>(context).newListInput = [
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0]
          ];
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogScreenSelect(
                  title: 'New Information',
                  items: UIBuilders.generateDateButtons(map: showListInput),
                  onAccept: () {
                    //get the list of inputted data
                    List data = Provider.of<AppData>(context).newListInput;

                    //get the day of year, add to list
                    List bloomEntry = [];
                    for (List entry in data) {
                      int day =
                          AppData.getDayOfYear(month: entry[0], day: entry[1]);
                      bloomEntry.add(day);
                    }

                    //pull the days and add to a map to upload the data
                    Map<String, dynamic> bloomMap = {
                      BloomKeys.bud: bloomEntry[0],
                      BloomKeys.first: bloomEntry[1],
                      BloomKeys.last: bloomEntry[2],
                      BloomKeys.seed: bloomEntry[3]
                    };
                    Map upload = {
                      PlantKeys.bloomSequence: [bloomMap]
                    };

                    //upload the data
                    Provider.of<CloudDB>(context).updateDocumentL1(
                        collection: DBFolder.plants,
                        document: plantID,
                        data: upload);

                    //clear and pop
                    Provider.of<AppData>(context).newListInput = [];
                    Navigator.pop(context);
                  },
                );
              });
        } else if (showDatePickerInstead == true) {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //this should be close to the beginning of year 1
            firstDate: DateTime.fromMillisecondsSinceEpoch(-2177452799000),
            lastDate: DateTime.now(),
          ).then((date) {
            if (date != null) {
              int value = date.millisecondsSinceEpoch;
              int update = CloudDB.delayUpdateWrites(timeCreated: timeCreated);
              //update
              Provider.of<CloudDB>(context).updateDocumentL1(
                collection: DBFolder.plants,
                document: plantID,
                data: {buttonKey: value, PlantKeys.update: update},
              );
              //this must be here to prevent unstable widget tree
              Navigator.pop(context);
            }
          });
        } else {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                int update =
                    CloudDB.delayUpdateWrites(timeCreated: timeCreated);
                return DialogScreenInput(
                  title: 'Add Information',
                  acceptText: 'Add',
                  acceptOnPress: () {
                    //update the value with map
                    Provider.of<CloudDB>(context).updateDocumentL1(
                        collection: DBFolder.plants,
                        document: plantID,
                        data: {
                          buttonKey: Provider.of<AppData>(context).newDataInput,
                          PlantKeys.update: update,
                        });
                    //pop context
                    Navigator.pop(context);
                  },
                  onChange: (input) {
                    Provider.of<AppData>(context).newDataInput = input;
                  },
                  cancelText: 'Cancel',
                  hintText: '',
                  smallText: false,
                );
              });
        }
      },
    );
  }
}

//for multiple input dialog
//showDialog(
//context: context,
//builder: (BuildContext context) {
//int update =
//CloudDB.delayUpdateWrites(timeCreated: timeCreated);
//return DialogScreenInputMultiple(
//keys: [],
//title: 'Add Flowering Information',
//acceptText: 'Add',
//onChange: (value) {
//null;
//},
//acceptOnPress: () {
////update the value with map
//Provider.of<CloudDB>(context).updateDocumentL1(
//collection: DBFolder.plants,
//document: plantID,
//data: {
//buttonKey: Provider.of<AppData>(context).newListInput,
//PlantKeys.update: update,
//});
////pop context
//Navigator.pop(context);
//},
//hintText: '',
//smallText: false,
//cancelText: 'Cancel',
//);
//});
