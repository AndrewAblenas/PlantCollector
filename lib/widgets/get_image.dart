import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/widgets/dialogs/dialog_loading.dart';
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
        Provider.of<CloudStore>(context)
            .getImageFile(fromCamera: imageFromCamera)
            .then((image) {
          //check to make sure the user didn't back out
          if (image != null) {
            //show a status dialog
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return DialogLoading(
                  title: 'Uploading Photo',
                  text: 'Please wait...',
                );
              },
            );
            //upload image
            //wait for completion
            Provider.of<CloudStore>(context)
                .uploadTask(
                    imageCode: null,
                    imageFile: image,
                    imageExtension: 'jpg',
                    plantIDFolder: plantID,
                    subFolder: DBDocument.images)
                .onComplete
                .then((completion) {
              //get the url string
              Provider.of<CloudStore>(context)
                  .getDownloadURL(snapshot: completion)
                  .then(
                    (url) =>
                        //NOW GET DATE, THUMB URL AND UPLOAD
                        Provider.of<CloudDB>(context).generateImageMapAndUpload(
                            ref: Provider.of<CloudStore>(context)
                                .getStorageRef(),
                            url: url,
                            plantID: plantID),
                  );
              //update document last updated time
              CloudDB.updateDocumentL1(
                  collection: DBFolder.plants,
                  document: plantID,
                  data: {
                    PlantKeys.update: CloudDB.delayUpdateWrites(
                        timeCreated: plantCreationDate,
                        document:
                            Provider.of<AppData>(context).currentUserInfo.id),
                  });
              //pop
              if (pop == true) {
                Navigator.pop(context);
              }
              //now pop the upload dialog
              Future.delayed(Duration(seconds: 1)).then((value) {
                Navigator.pop(context);
              });
            });
          }
        });
      },
    );
  }
}
