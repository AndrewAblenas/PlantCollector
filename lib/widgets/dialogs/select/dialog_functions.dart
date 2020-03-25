import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
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
  DialogItemPlant({
    @required this.buttonText,
    @required this.buttonKey,
    @required this.plantID,
  });

  @override
  Widget build(BuildContext context) {
    return DialogItem(
      buttonText: buttonText,
      onPress: () {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
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
                          PlantKeys.update: CloudDB.timeNowMS(),
                        });
                    //pop context
                    Navigator.pop(context);
                  },
                  onChange: (input) {
                    Provider.of<AppData>(context).newDataInput = input;
                  },
                  cancelText: 'Cancel',
                  hintText: null);
            });
      },
    );
  }
}
