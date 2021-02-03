import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';

Future<bool> connectionActive() async {
  //check to make sure the user is online
  ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();

  //return result
  return connectivityResult != ConnectivityResult.none;
}

Future<void> dialogUpdateFailed({@required BuildContext context}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return DialogConfirm(
          title: 'Update Failed',
          text: 'There was a problem adding this information.  '
              'Make sure you are online and your current network isn\'t app features.  '
              'Otherwise, try connecting to another network.',
          hideCancel: true,
          onPressed: () {
            Navigator.pop(context);
          });
    },
  );
}

Future<void> dialogCheckNetwork({@required BuildContext context}) {
  //2020-05-31
  return showDialog(
    context: context,
    builder: (BuildContext context) {
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
    },
  );
}

// Future<Map> dialogAddPlant(
//     {@required BuildContext context,
//     @required String collectionID,
//     @required String newPlantID}) async {
//   //initialize data
//   Map data;
//   //now show the dialog to provide a plant name
//   await showDialog(
//       context: context,
//       builder: (context) {
//         return DialogScreenInput(
//             title: 'Nickname your ${GlobalStrings.plant}',
//             acceptText: 'Add',
//             onChange: (input) {
//               Provider.of<AppData>(context).newDataInput = input;
//             },
//             cancelText: 'Cancel',
//             hintText: null,
//             acceptOnPress: () async {
// //On submission of name continue
//               //package the plant data
//               data = Provider.of<AppData>(context)
//                   .plantNew(collectionID: collectionID, newPlantID: newPlantID);
//               try {
// //push a new plant to the server
//                 await CloudDB.setDocumentL1(
//                   collection: DBFolder.plants,
//                   document: data[PlantKeys.id],
//                   data: data,
//                 );
//
// //next push a reference to the plant list of the collection/shelf (otherwise it won't be displayed)
//                 await Provider.of<CloudDB>(context)
//                     .updateArrayInDocumentInCollection(
//                         arrayKey: CollectionKeys.plants,
//                         entries: [data[PlantKeys.id]],
//                         folder: DBFolder.collections,
//                         documentName: collectionID,
//                         action: true);
//
// //package next plant update time
//                 Map<String, dynamic> update = {
//                   UserKeys.lastPlantAdd: DateTime.now().millisecondsSinceEpoch
//                 };
//
// //then push this time to user document
//                 await CloudDB.updateDocumentL1(
//                     collection: DBFolder.users,
//                     document: Provider.of<CloudDB>(context).currentUserFolder,
//                     data: update);
//                 //now upload image dialog, context issues prevented this from being separate
//                 if (data != null) {
//                   print('Enter IF');
//                   dialogUploadImage(context: context, data: data);
//                 }
//               } catch (e) {
// //if there are any issues adding information or images
//                 dialogUpdateFailed(context: context);
//               }
//             });
//       });
//   //return
//   return data;
// }

// void dialogUploadImage(
//     {@required BuildContext context, @required Map data}) async {
//   //show image upload dialog
//   await showDialog(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return DialogScreenSelect(
//         title: 'Add a Photo',
//         items: [
//           GetImage(
//               imageFromCamera: true,
//               plantCreationDate: data[PlantKeys.created],
//               largeWidget: false,
//               widgetScale: 1.0,
//               pop: true,
//               plantID: data[PlantKeys.id]),
//           SizedBox(
//             height: 20.0,
//           ),
//           GetImage(
//               imageFromCamera: false,
//               plantCreationDate: data[PlantKeys.created],
//               largeWidget: false,
//               widgetScale: 1.0,
//               pop: true,
//               plantID: data[PlantKeys.id]),
//         ],
//       );
//     },
//   );
//   Navigator.pop(context);
// }

void rehomeOrphanedPlants(
    {@required List<String> orphaned, @required BuildContext context}) {
  //if there are orphaned plants
  if (orphaned.length > 0) {
//first check if orphaned collection exists
    String id = DBDefaultDocument.orphaned;
    bool matchCollection = Provider.of<AppData>(context, listen: false)
        .currentUserCollections
        .any((element) => element.id == id);

//provide default document
    Map defaultCollection = AppData.newDefaultCollection(
      collectionID: id,
    ).toMap();

//now complete cloning
    Provider.of<CloudDB>(context, listen: false).updateDefaultDocumentL2(
      collectionL2: DBFolder.collections,
      documentL2: id,
      key: CollectionKeys.plants,
      entries: orphaned,
      match: matchCollection,
      defaultDocument: defaultCollection,
    );
  }
}
