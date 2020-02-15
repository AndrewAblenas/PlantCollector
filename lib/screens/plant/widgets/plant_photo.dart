import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/screens/plant/image.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:plant_collector/formats/colors.dart';

//*****WIDGET PURPOSE*****//
//present a plant image from Firebase CloudStore
//tap opens full image
//long press to delete image
//grid icon will set image as thumbnail

class PlantPhoto extends StatelessWidget {
  final bool connectionLibrary;
  final String imageURL;
  final String imageDate;
  final bool largeWidget;
  PlantPhoto(
      {@required this.connectionLibrary,
      @required this.imageURL,
      @required this.imageDate,
      @required this.largeWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(largeWidget ? 4.0 : 0.0),
      child: GestureDetector(
        onLongPress: () {
          //allow long press to delete image, if this is the user library
          if (connectionLibrary == false) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogConfirm(
                  title: 'Delete Image',
                  text: 'Are you sure you want to delete this image?',
                  onPressed: () async {
                    //*****REMOVE IMAGE*****//
                    //remove from database array
                    await Provider.of<CloudDB>(context)
                        .updateArrayInDocumentInCollection(
                      arrayKey: PlantKeys.images,
                      action: false,
                      entries: [imageURL],
                      folder: DBFolder.plants,
                      documentName:
                          Provider.of<AppData>(context).forwardingPlantID,
                    );
                    //get reference from the provided URL
                    StorageReference reference =
                        await Provider.of<CloudStore>(context)
                            .getReferenceFromURL(imageURL: imageURL);
                    //delete image
                    Provider.of<CloudStore>(context)
                        .deleteImage(imageReference: reference);
                    //*****REMOVE THUMBNAIL*****//
                    //get the thumbnail image name from the full sized image url
                    String imageName =
                        CloudStore.getThumbName(imageUrl: imageURL);
                    //get the thumb ref
                    StorageReference thumbRef = Provider.of<CloudStore>(context)
                        .getImageRef(
                            imageName: imageName,
                            imageExtension: 'jpg',
                            plantIDFolder: Provider.of<AppData>(context)
                                .forwardingPlantID);
                    //delete thumbnail
                    Provider.of<CloudStore>(context)
                        .deleteImage(imageReference: thumbRef);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
        child: Container(
          margin: EdgeInsets.only(bottom: largeWidget ? 10.0 : 0.0),
          decoration: largeWidget
              ? BoxDecoration(
                  color: kGreenMedium,
                  boxShadow: kShadowBox,
                )
              : BoxDecoration(color: kGreenMedium),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.94,
            decoration: BoxDecoration(
              image: DecorationImage(
                //TODO set to use thumbnail, not full image?, maybe send over proper URL during build
                image: CachedNetworkImageProvider(imageURL),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            child: FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageScreen(
                              imageURL: imageURL,
                            )));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        width: largeWidget ? 30 : 0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(largeWidget
                            ? 5.0
                            : 1.0 *
                                MediaQuery.of(context).size.width *
                                kScaleFactor),
                        child: Container(
                          color: Color(0x33000000),
                          padding: EdgeInsets.all(3 *
                              MediaQuery.of(context).size.width *
                              kScaleFactor),
                          child: Text(
                            imageDate,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //change text size depending on widget size
                              fontSize: largeWidget
                                  ? AppTextSize.medium *
                                      MediaQuery.of(context).size.width
                                  : 0.9 *
                                      AppTextSize.tiny *
                                      MediaQuery.of(context).size.width,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      //only show set as thumbnail for large widget size
                      largeWidget
                          ? Container(
                              width: 38 *
                                  MediaQuery.of(context).size.width *
                                  kScaleFactor,
                              //only show set as thumbnail if user library
                              child: connectionLibrary == false
                                  ? FlatButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DialogConfirm(
                                              title: 'Plant Thumbnail',
                                              text:
                                                  'Would you like to use this image as the plant thumbail image?',
                                              onPressed: () async {
                                                //run thumbnail package to get thumb url
                                                String thumbUrl = await Provider
                                                        .of<CloudStore>(context)
                                                    .thumbnailPackage(
                                                        imageURL: imageURL,
                                                        plantID: Provider.of<
                                                                    AppData>(
                                                                context)
                                                            .forwardingPlantID);
                                                //set thumb url
                                                Provider.of<CloudDB>(context)
                                                    .updateDocumentInCollection(
                                                        data: CloudDB
                                                            .updatePairFull(
                                                                key: PlantKeys
                                                                    .thumbnail,
                                                                value:
                                                                    thumbUrl),
                                                        collection:
                                                            DBFolder.plants,
                                                        documentName: Provider
                                                                .of<AppData>(
                                                                    context)
                                                            .forwardingPlantID);

                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(Icons.grid_on,
                                          color: Color(0x55FFFFFF),
                                          size: AppTextSize.huge *
                                              MediaQuery.of(context)
                                                  .size
                                                  .width),
                                    )
                                  : SizedBox(),
                            )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
