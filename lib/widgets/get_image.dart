import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
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
    //easy reference
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: false);
    CloudStore provCloudStoreFalse =
        Provider.of<CloudStore>(context, listen: false);
    //easy scale
    double relativeWidth = MediaQuery.of(context).size.width * kScaleFactor;
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
        radius: 60 * relativeWidth * widgetScale,
        child: Icon(
          icon,
          size: 80.0 * relativeWidth * widgetScale,
        ),
      ),
      onPressed: () async {
        //get image from camera
        provCloudStoreFalse
            .getImageFile(fromCamera: imageFromCamera)
            .then((image) async {
          //check to make sure the user didn't back out and is online
          ConnectivityResult connectivityResult =
              await Connectivity().checkConnectivity();

          //if there is an image and active connection
          if (image != null && connectivityResult != ConnectivityResult.none) {
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

            //check connectivity in dialog input screen
            //upload image
            //wait for completion
            provCloudStoreFalse
                .uploadTask(
                    imageCode: null,
                    imageFile: image,
                    imageExtension: 'jpg',
                    plantIDFolder: plantID,
                    subFolder: DBDocument.images)
                .then((completion) {
              //delete the temporary image
              try {
                image.delete().then(
                    (value) => print('Image Removed: ${!value.existsSync()}'));
              } catch (e) {
                print(e);
              }

              //get the url string
              provCloudStoreFalse.getDownloadURL(snapshot: completion).then(
                    (url) =>
                        //NOW GET DATE, THUMB URL AND UPLOAD
                        Provider.of<CloudDB>(context, listen: false)
                            .generateImageMapAndUpload(
                                ref: provCloudStoreFalse.getStorageRef(),
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
                        document: provAppDataFalse.currentUserInfo.id),
                  });
              //pop the
              if (pop == true) {
                Navigator.pop(context);
              }
              //now pop the upload dialog
              Future.delayed(Duration(seconds: 1)).then((value) {
                Navigator.pop(context);
              });
            });
          } else if (image == null) {
            //let the user know they cancelled the upload
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogConfirm(
                    title: 'No Selection',
                    text: 'No image was selected for upload.',
                    buttonText: 'OK',
                    hideCancel: true,
                    onPressed: () {
                      Navigator.pop(context);
                    });
              },
            );
          } else {
            //show a dialog notifying the user
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogConfirm(
                    title: 'Upload Failed',
                    text:
                        'Make sure you are online and your current network isn\'t blocking cloud storage.  '
                        'Otherwise, try connecting to another network.',
                    hideCancel: true,
                    onPressed: () {
                      Navigator.pop(context);
                    });
              },
            );
          }
        });
      },
    );
  }
}
