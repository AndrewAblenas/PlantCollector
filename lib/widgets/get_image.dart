import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:provider/provider.dart';

class GetImage extends StatelessWidget {
  const GetImage(
      {Key key,
      @required this.largeWidget,
      @required this.widgetScale,
      @required this.plantID,
      @required this.plantCreationDate,
      @required this.imageFromCamera,
      this.iconColor = kGreenDark,
      this.backgroundColor = Colors.white,
      this.pop});

  final bool largeWidget;
  final double widgetScale;
  final String plantID;
  final int plantCreationDate;
  final bool imageFromCamera;
  final Color iconColor;
  final Color backgroundColor;
  final bool pop;

  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    //determine icon
    IconData icon = (imageFromCamera == true) ? Icons.camera_alt : Icons.image;

    //*****SET WIDGET VISIBILITY END*****//

    return FlatButton(
      color: largeWidget ? AppTextColor.white : Color(0x00000000),
      padding: EdgeInsets.all(10.0 * widgetScale),
      child: CircleAvatar(
        foregroundColor: iconColor,
        backgroundColor: backgroundColor,
        radius:
            60 * MediaQuery.of(context).size.width * kScaleFactor * widgetScale,
        child: Icon(
          icon,
          size: 80.0 *
              MediaQuery.of(context).size.width *
              kScaleFactor *
              widgetScale,
        ),
      ),
      onPressed: () async {
        //get image from camera
        File image = await Provider.of<CloudStore>(context)
            .getImageFile(fromCamera: imageFromCamera);
        //check to make sure the user didn't back out
        if (image != null) {
          //upload image
          StorageUploadTask upload = Provider.of<CloudStore>(context)
              .uploadTask(
                  imageCode: null,
                  imageFile: image,
                  imageExtension: 'jpg',
                  plantIDFolder: plantID,
                  subFolder: DBDocument.images);
          //make sure upload completes
          StorageTaskSnapshot completion = await upload.onComplete;
          //get the url string
          String url = await Provider.of<CloudStore>(context)
              .getDownloadURL(snapshot: completion);
          //add image reference to plant document
          await Provider.of<CloudDB>(context).updateDocumentL1Array(
              collection: DBFolder.plants,
              document: plantID,
              key: PlantKeys.images,
              entries: [url],
              action: true);
          //update document last updated time
          Provider.of<CloudDB>(context).updateDocumentL1(
              collection: DBFolder.plants,
              document: plantID,
              data: {
                PlantKeys.update:
                    CloudDB.delayUpdateWrites(timeCreated: plantCreationDate),
              });
          //pop context
          if (pop == true) {
            Navigator.pop(context);
          }
        }
      },
    );
  }
}
