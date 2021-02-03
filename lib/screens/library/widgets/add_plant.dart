import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/button_dialogs.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_select.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/get_image.dart';
import 'package:provider/provider.dart';

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
          onPressed: () async {
            //continue
            //if there is an active connection continue
            bool active = await connectionActive();
            if (active == true) {
//initialize data here (generate only one ID here to prevent duplicate uploads on multiple button taps)
              String newPlantID = AppData.generateID(prefix: 'plant_');
//now present the add plant dialog
              showDialog(
                  context: context,
                  builder: (context) {
                    return AppDialogNewPlantName(
                      collectionID: collectionID,
                      newPlantID: newPlantID,
                      nextDialog: true,
                    );
                  });
            }
          },
        ));
  }
}

class AppDialogNewPlantName extends StatelessWidget {
  final String collectionID;
  final String newPlantID;
  final bool nextDialog;
  AppDialogNewPlantName(
      {@required this.collectionID,
      @required this.newPlantID,
      this.nextDialog});
  @override
  Widget build(BuildContext context) {
    return DialogScreenInput(
        title: 'Nickname your ${GlobalStrings.plant}',
        acceptText: 'Add',
        onChange: (input) {
          Provider.of<AppData>(context, listen: false).newDataInput = input;
        },
        cancelText: 'Cancel',
        hintText: null,
        acceptOnPress: () async {
//On submission of name continue
          //package the plant data
          Map data = Provider.of<AppData>(context, listen: false)
              .plantNew(collectionID: collectionID, newPlantID: newPlantID);
          try {
//push a new plant to the server
            await CloudDB.setDocumentL1(
              collection: DBFolder.plants,
              document: data[PlantKeys.id],
              data: data,
            );

//next push a reference to the plant list of the collection/shelf (otherwise it won't be displayed)
            await Provider.of<CloudDB>(context, listen: false)
                .updateArrayInDocumentInCollection(
                    arrayKey: CollectionKeys.plants,
                    entries: [data[PlantKeys.id]],
                    folder: DBFolder.collections,
                    documentName: collectionID,
                    action: true);

//package next plant update time
            Map<String, dynamic> update = {
              UserKeys.lastPlantAdd: DateTime.now().millisecondsSinceEpoch
            };

//then push this time to user document
            await CloudDB.updateDocumentL1(
                collection: DBFolder.users,
                document: Provider.of<CloudDB>(context, listen: false)
                    .currentUserFolder,
                data: update);
            //show next dialog
            if (nextDialog == true) {
              print('TRUE');
              await showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AppDialogUploadImage(data: data);
                  });
              Navigator.pop(context);
            }
            //now pop
          } catch (e) {
//if there are any issues adding information or images
            dialogUpdateFailed(context: context);
          }
        });
  }
}

class AppDialogUploadImage extends StatelessWidget {
  final Map data;
  AppDialogUploadImage({@required this.data});
  @override
  Widget build(BuildContext context) {
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
  }
}

class AppDialogCheckNetwork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DialogConfirm(
        title: 'Check Connection',
        text:
            'Make sure that you are online and that your network isn\'t blocking any app functions.  '
            '\n\nOtherwise, try connecting to a different network.',
        hideCancel: true,
        buttonText: 'OK',
        onPressed: () {
          Navigator.pop(context);
        });
  }
}
