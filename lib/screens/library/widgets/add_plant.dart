import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
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
        onPressed: () async {
          //check to make sure the user is online
          ConnectivityResult connectivityResult =
              await Connectivity().checkConnectivity();

          //if there is an active connection continue
          if (connectivityResult != ConnectivityResult.none) {
            //initialize data here
            //generate only one ID for a new plant to prevent multiple uploads
            //if the add function fails and user keeps hitting Add Button
            Map data;
            String newPlantID = AppData.generateID(prefix: 'plant_');

            //now show the dialog
            showDialog(
                context: context,
                builder: (context) {
                  return DialogScreenInput(
                      title: 'Nickname your ${GlobalStrings.plant}',
                      acceptText: 'Add',
                      acceptOnPress: () async {
                        //try
                        try {
                          //set the plant data
                          data = Provider.of<AppData>(context).plantNew(
                              collectionID: collectionID,
                              newPlantID: newPlantID);

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
                          //first package the information
                          Map<String, dynamic> update = {
                            UserKeys.lastPlantAdd:
                                DateTime.now().millisecondsSinceEpoch
                          };

                          //then update the user document
                          await CloudDB.updateDocumentL1(
                              collection: DBFolder.users,
                              document: Provider.of<CloudDB>(context)
                                  .currentUserFolder,
                              data: update);

                          //pop the first window
                          Navigator.pop(context);

                          //after adding the plant, ask to add an image
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DialogScreenSelect(
                                title: 'Add a Photo',
                                items: [
                                  GetImage(
                                      imageFromCamera: true,
                                      plantCreationDate:
                                          data[PlantKeys.created],
                                      largeWidget: false,
                                      widgetScale: 1.0,
                                      pop: true,
                                      plantID: data[PlantKeys.id]),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  GetImage(
                                      imageFromCamera: false,
                                      plantCreationDate:
                                          data[PlantKeys.created],
                                      largeWidget: false,
                                      widgetScale: 1.0,
                                      pop: true,
                                      plantID: data[PlantKeys.id]),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          //if there are any issues adding information or images
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogConfirm(
                                  title: 'Update Failed',
                                  text:
                                      'There was a problem adding this information.  '
                                      'Make sure you are online and your current network isn\'t app features.  '
                                      'Otherwise, try connecting to another network.',
                                  hideCancel: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  });
                            },
                          );
                        }
                      },
                      onChange: (input) {
                        Provider.of<AppData>(context).newDataInput = input;
                      },
                      cancelText: 'Cancel',
                      hintText: null);
                });
          } else {
            //2020-05-31
            //if the network status is offline let the user know
            //this is to prevent repeated additions of the same plant

            showDialog(
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
        },
//                    onChange: (input) {
//                      Provider.of<AppData>(context).newDataInput = input;
//                    },
//                    cancelText: 'Cancel',
//                    hintText: null);
//              });
//        },
//      ),
      ),
    );
  }
}
