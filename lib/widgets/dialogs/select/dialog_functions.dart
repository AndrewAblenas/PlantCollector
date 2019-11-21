import 'package:flutter/material.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/widgets/dialogs/select/dialog_item.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/widgets/dialogs/dialog_input.dart';

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
              arrayKey: kGroupCollectionList,
              entries: [entryID],
              folder: kUserGroups,
              documentName: buttonPossibleParentID,
              action: true);
          Provider.of<CloudDB>(context).updateArrayInDocumentInCollection(
              arrayKey: kGroupCollectionList,
              entries: [entryID],
              folder: kUserGroups,
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
              arrayKey: kCollectionPlantList,
              entries: [entryID],
              folder: kUserCollections,
              documentName: buttonPossibleParentID,
              action: true);
          Provider.of<CloudDB>(context).updateArrayInDocumentInCollection(
              arrayKey: kCollectionPlantList,
              entries: [entryID],
              folder: kUserCollections,
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
          barrierDismissible: false,
          builder: (BuildContext context) {
            return DialogInput(
              title: buttonText,
              text: 'Please input the new information below.',
              hintText: null,
              onPressedSubmit: () {
                //update the value
                Provider.of<CloudDB>(context).updateDocumentInCollection(
                    data: Provider.of<CloudDB>(context)
                        .updatePairInput(key: buttonKey),
                    collection: kUserPlants,
                    documentName: plantID);

                Navigator.pop(context);
              },
              onChangeInput: (input) {
                Provider.of<CloudDB>(context).newDataInput = input;
              },
              onPressedCancel: () {
                Provider.of<CloudDB>(context).newDataInput = null;
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
