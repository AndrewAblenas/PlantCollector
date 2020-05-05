import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant/bloom_data.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/plant/growth_data.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/plant/widgets/plant_flowering.dart';
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
        id: buttonPossibleParentID,
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
          //WHEN MOVING OUT OF LIST
          //if the plant was in wishlist set wishList field to false on remove
          if (currentParentID == DBDefaultDocument.wishList &&
              buttonPossibleParentID != DBDefaultDocument.wishList) {
            Map<String, dynamic> data = {PlantKeys.want: false};
            CloudDB.updateDocumentL1(
                collection: DBFolder.plants, document: entryID, data: data);
          }
          //if the plant was in sell list set sell to false after remove
          if (currentParentID == DBDefaultDocument.sellList &&
              buttonPossibleParentID != DBDefaultDocument.sellList) {
            Map<String, dynamic> data = {PlantKeys.sell: false};
            CloudDB.updateDocumentL1(
                collection: DBFolder.plants, document: entryID, data: data);
          }
          //WHEN MOVING INTO LIST
          //if the plant was in wishlist set wishList field to false on remove
          if (currentParentID != DBDefaultDocument.wishList &&
              buttonPossibleParentID == DBDefaultDocument.wishList) {
            Map<String, dynamic> data = {PlantKeys.want: true};
            CloudDB.updateDocumentL1(
                collection: DBFolder.plants, document: entryID, data: data);
          }
          //if the plant was in sell list set sell to false after remove
          if (currentParentID != DBDefaultDocument.sellList &&
              buttonPossibleParentID == DBDefaultDocument.sellList) {
            Map<String, dynamic> data = {PlantKeys.sell: true};
            CloudDB.updateDocumentL1(
                collection: DBFolder.plants, document: entryID, data: data);
          }
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
  final Map showListInput;
  DialogItemPlant({
    @required this.buttonText,
    @required this.buttonKey,
    @required this.plantID,
    @required this.timeCreated,
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
        if (PlantKeys.listDatePickerMultipleKeys.contains(buttonKey)) {
          Navigator.pop(context);
          Type dataType;
          if (buttonKey == PlantKeys.sequenceBloom) {
            dataType = BloomData;
          } else if (buttonKey == PlantKeys.sequenceGrowth) {
            dataType = GrowthData;
          }
          //set to default to store future data
          Provider.of<AppData>(context).newListInput = [
//            [0, 0],
//            [0, 0],
//            [0, 0],
//            [0, 0]
            0,
            0,
            0,
            0,
          ];
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SequenceScreen(
                    plantID: plantID, dataType: dataType, sequenceMap: null);
              });
        } else if (PlantKeys.listDatePickerKeys.contains(buttonKey)) {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //this should be close to the beginning of year 1
            firstDate: DateTime.fromMillisecondsSinceEpoch(-2177452799000),
            lastDate: DateTime.now(),
          ).then((date) {
            if (date != null) {
              int value = date.millisecondsSinceEpoch;
              int update = CloudDB.delayUpdateWrites(
                  timeCreated: timeCreated,
                  document: Provider.of<AppData>(context).currentUserInfo.id);
              //update
              CloudDB.updateDocumentL1(
                collection: DBFolder.plants,
                document: plantID,
                data: {buttonKey: value, PlantKeys.update: update},
              );
              //this must be here to prevent unstable widget tree
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
            }
          });
        } else {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                int update = CloudDB.delayUpdateWrites(
                    timeCreated: timeCreated,
                    document: Provider.of<AppData>(context).currentUserInfo.id);
                return DialogScreenInput(
                  title: 'Add Information',
                  acceptText: 'Add',
                  acceptOnPress: () {
                    //update the value with map
                    CloudDB.updateDocumentL1(
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
