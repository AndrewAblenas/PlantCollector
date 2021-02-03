import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/app_data.dart';

class ImageScreen extends StatelessWidget {
  final String imageURL;
  final bool connectionLibrary;
  ImageScreen({this.imageURL, @required this.connectionLibrary});
  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    //enable dialogs only if library belongs to the current user
    bool enableDialogs = (connectionLibrary == false);

    //*****SET WIDGET VISIBILITY END*****//

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenDark,
        centerTitle: true,
        elevation: 20.0,
//        title: Text(
//          screenTitle,
//          style: kAppBarTitle,
//        ),
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: GestureDetector(
          onLongPress: () {
            if (enableDialogs == true) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogConfirm(
                    hideCancel: false,
                    title: 'Plant Thumbnail',
                    text:
                        'Would you like to use this image as the plant thumbail image?',
                    onPressed: () async {
                      if (connectionLibrary == false) {
                        //run thumbnail package to get thumb url
                        String thumbUrl = await Provider.of<CloudStore>(context,
                                listen: false)
                            .thumbnailPackage(
                                imageURL: imageURL,
                                plantID:
                                    Provider.of<AppData>(context, listen: false)
                                        .forwardingPlantID);
                        //package data
                        Map<String, dynamic> data = {
                          PlantKeys.thumbnail: thumbUrl,
                          PlantKeys.isVisible:
                              !Provider.of<AppData>(context, listen: false)
                                  .currentUserInfo
                                  .privateLibrary
                        };
                        //set thumb url
                        CloudDB.updateDocumentL1(
                          collection: DBFolder.plants,
                          document: Provider.of<AppData>(context, listen: false)
                              .forwardingPlantID,
                          data: data,
                        );

                        Navigator.pop(context);
                      }
                    },
                  );
                },
              );
            }
          },
          child: PhotoView(
            imageProvider: NetworkImage(imageURL),
            maxScale: 4.0,
          ),
        ),
      ),
    );
  }
}
