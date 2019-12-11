import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'dart:io';
import 'package:plant_collector/formats/colors.dart';

class AddPhoto extends StatelessWidget {
  final String plantID;
  AddPhoto({
    @required this.plantID,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.all(4.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.94,
        decoration: BoxDecoration(
          color: kGreenMedium,
          boxShadow: [
            BoxShadow(
              color: kShadowColor,
              blurRadius: 8.0,
              offset: Offset(0.0, 5.0),
              spreadRadius: -5.0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              elevation: 5.0,
              hoverElevation: 0,
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                foregroundColor: kGreenDark,
                backgroundColor: Colors.white,
                radius: 60 * MediaQuery.of(context).size.width * kScaleFactor,
                child: Icon(
                  Icons.camera_alt,
                  size: 80.0 * MediaQuery.of(context).size.width * kScaleFactor,
                ),
              ),
              onPressed: () async {
                //get image from camera
                File image = await Provider.of<CloudStore>(context)
                    .getCameraImage(fromCamera: true);
                //check to make sure the user didn't back out
                if (image != null) {
                  //upload image
                  StorageUploadTask upload = Provider.of<CloudStore>(context)
                      .uploadTask(
                          imageCode: null,
                          imageFile: image,
                          imageExtension: 'jpg',
                          plantIDFolder: plantID,
                          subFolder: StorageFolder.plants);
                  //make sure upload completes
                  StorageTaskSnapshot completion = await upload.onComplete;
                  //get the url string
                  String url = await Provider.of<CloudStore>(context)
                      .getDownloadURL(snapshot: completion);
                  //add thumbnail reference to plant document
                  Provider.of<CloudDB>(context)
                      .updateArrayInDocumentInCollection(
                          arrayKey: PlantKeys.images,
                          entries: [url],
                          folder: DBFolder.plants,
                          documentName: plantID,
                          action: true);
                }
              },
            ),
            RaisedButton(
              elevation: 5.0,
              hoverElevation: 0,
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                foregroundColor: kGreenDark,
                backgroundColor: Colors.white,
                radius: 60 * MediaQuery.of(context).size.width * kScaleFactor,
                child: Icon(
                  Icons.image,
                  size: 80.0 * MediaQuery.of(context).size.width * kScaleFactor,
                ),
              ),
              onPressed: () async {
                //get image from camera
                File image = await Provider.of<CloudStore>(context)
                    .getCameraImage(fromCamera: false);
                //check to make sure the user didn't back out
                if (image != null) {
                  //upload image
                  StorageUploadTask upload = Provider.of<CloudStore>(context)
                      .uploadTask(
                          imageCode: null,
                          imageFile: image,
                          imageExtension: 'jpg',
                          plantIDFolder: plantID,
                          subFolder: StorageFolder.images);
                  //make sure upload completes
                  StorageTaskSnapshot completion = await upload.onComplete;
                  //get the url string
                  String url = await Provider.of<CloudStore>(context)
                      .getDownloadURL(snapshot: completion);
                  //add image reference to plant document
                  Provider.of<CloudDB>(context)
                      .updateArrayInDocumentInCollection(
                          arrayKey: PlantKeys.images,
                          entries: [url],
                          folder: DBFolder.plants,
                          documentName: plantID,
                          action: true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
