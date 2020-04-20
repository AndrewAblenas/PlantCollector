import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant/image_data.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
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
  final ImageData imageSet;
  final String currentThumbnail;
  final String imageDate;
  final bool largeWidget;
  final String plantOwner;
  PlantPhoto({
    @required this.connectionLibrary,
    @required this.imageSet,
    @required this.currentThumbnail,
    @required this.imageDate,
    @required this.largeWidget,
    @required this.plantOwner,
  });

  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    //only show set thumbnail for large widget and current user is owner
    bool showSetThumbnail = (largeWidget == true && connectionLibrary == false);

    //check if plant thumbnail is the same as current image
    bool imageIsThumb =
        (currentThumbnail.toString() == imageSet.thumb.toString());

    //*****SET WIDGET VISIBILITY END*****//

    return Padding(
      padding: EdgeInsets.all((largeWidget == true) ? 4.0 : 0.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageScreen(
                        connectionLibrary: connectionLibrary,
                        imageURL: imageSet.full,
                      )));
        },
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
                    Map<String, dynamic> removeData = imageSet.toMap();
                    String plantID =
                        Provider.of<AppData>(context).forwardingPlantID;
                    //remove from database array
                    await CloudDB.updateDocumentL1Array(
                        collection: DBFolder.plants,
                        document: plantID,
                        key: PlantKeys.imageSets,
                        entries: [removeData],
                        action: false);
                    //get reference from the provided URL
                    StorageReference refImage =
                        await Provider.of<CloudStore>(context)
                            .getReferenceFromURL(imageURL: imageSet.full);
                    //delete image
                    Provider.of<CloudStore>(context)
                        .deleteImage(imageReference: refImage);

                    //*****REMOVE THUMBNAIL*****//

                    //check if the image was a thumbnail
                    if (imageIsThumb == true) {
                      //new data map
                      Map<String, dynamic> thumbData = {
                        PlantKeys.thumbnail: ''
                      };
                      //set to default in plant
                      CloudDB.updateDocumentL1(
                          collection: DBFolder.plants,
                          document: plantID,
                          data: thumbData);
                    }
                    //get reference from the provided URL
                    StorageReference refThumb =
                        await Provider.of<CloudStore>(context)
                            .getReferenceFromURL(imageURL: imageSet.thumb);
                    //delete thumbnail
                    Provider.of<CloudStore>(context)
                        .deleteImage(imageReference: refThumb);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.94,
          margin: EdgeInsets.only(bottom: (largeWidget == true) ? 10.0 : 0.0),
          decoration: (largeWidget == true)
              ? BoxDecoration(
                  color: kGreenMedium,
                  boxShadow: kShadowBox,
                )
              : BoxDecoration(color: kGreenMedium),
          child: Stack(fit: StackFit.expand, children: <Widget>[
            (largeWidget == true)
                ? CachedNetworkImage(
                    imageUrl: imageSet.full,
                    fit: BoxFit.cover,
                  )
                :
//            FutureProvider<String>.value(
//                    value: Provider.of<CloudStore>(context)
//                        .getImageUrl(reference: thumbRef),
//                    child: Consumer<String>(
//                      builder: (context, String thumbURL, _) {
//                        if (thumbURL == null) {
//                          return SizedBox();
//                        } else {
//                          return
                CachedNetworkImage(
                    imageUrl: imageSet.thumb,
                    fit: BoxFit.cover,
                  ),
//                        }
//                      },
//                    ),
//                  ),
//              CachedNetworkImage(imageUrl: imageURL),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      width: (largeWidget == true && showSetThumbnail == true)
                          ? 30
                          : 0,
                    ),
                    Container(
                      margin: EdgeInsets.all((largeWidget == true)
                          ? 5.0
                          : 1.0 *
                              MediaQuery.of(context).size.width *
                              kScaleFactor),
                      color: Color(0x55000000),
                      padding: EdgeInsets.all(
                          3 * MediaQuery.of(context).size.width * kScaleFactor),
                      child: Text(
                        imageDate,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          //change text size depending on widget size
                          fontSize: (largeWidget == true)
                              ? AppTextSize.medium *
                                  MediaQuery.of(context).size.width
                              : 1.0 *
                                  AppTextSize.tiny *
                                  MediaQuery.of(context).size.width,
                          fontWeight: (largeWidget == true)
                              ? AppTextWeight.medium
                              : AppTextWeight.heavy,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    //only show set as thumbnail for large widget size
                    (showSetThumbnail == true)
                        ? Container(
                            width: 0.08 * MediaQuery.of(context).size.width,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogConfirm(
                                      title: 'Plant Thumbnail',
                                      text:
                                          'Would you like to use this image as the plant thumbail image?',
                                      onPressed: () {
                                        if (connectionLibrary == false) {
                                          //run thumbnail package to get thumb url
//                                          String thumbUrl = await Provider.of<
//                                                  CloudStore>(context)
//                                              .thumbnailPackage(
//                                                  imageURL: imageSet,
//                                                  plantID: Provider.of<AppData>(
//                                                          context)
//                                                      .forwardingPlantID);
                                          //package data
                                          Map<String, dynamic> data = {
                                            PlantKeys.thumbnail: imageSet.thumb,
                                            PlantKeys.isVisible:
                                                !Provider.of<AppData>(context)
                                                    .currentUserInfo
                                                    .privateLibrary
                                          };
                                          //set thumb url
                                          CloudDB.updateDocumentL1(
                                            collection: DBFolder.plants,
                                            document:
                                                Provider.of<AppData>(context)
                                                    .forwardingPlantID,
                                            data: data,
                                          );

                                          Navigator.pop(context);
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                              child: Icon(Icons.grid_on,
                                  color: Color(0x55FFFFFF),
                                  size: AppTextSize.huge *
                                      MediaQuery.of(context).size.width),
                            ),
                          )
                        : SizedBox(
//                              width: 38 *
//                                  MediaQuery.of(context).size.width *
//                                  kScaleFactor,
                            ),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
