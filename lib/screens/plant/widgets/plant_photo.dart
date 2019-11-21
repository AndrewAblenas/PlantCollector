import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/screens/plant/image.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:plant_collector/formats/colors.dart';

//*****WIDGET PURPOSE*****//
//present a plant image from Firebase CloudStore
//tap opens full image
//long press to delete image
//grid icon will set image as thumbnail

class PlantPhoto extends StatelessWidget {
  final String imageURL;
  final String imageDate;
  PlantPhoto({@required this.imageURL, @required this.imageDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: GestureDetector(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogConfirm(
                title: 'Delete Image',
                text: 'Are you sure you want to delete this image?',
                onPressed: () async {
                  //remove from database array
                  await Provider.of<CloudDB>(context)
                      .updateArrayInDocumentInCollection(
                    arrayKey: kPlantImageList,
                    action: false,
                    entries: [imageURL],
                    folder: kUserPlants,
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
                  Navigator.pop(context);
                },
              );
            },
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            color: kGreenMedium,
            boxShadow: kShadowBox,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.94,
            decoration: BoxDecoration(
              image: DecorationImage(
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
                        width: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0 *
                            MediaQuery.of(context).size.width *
                            kTextScale),
                        child: Container(
                          color: Color(0x33000000),
                          padding: EdgeInsets.all(3 *
                              MediaQuery.of(context).size.width *
                              kTextScale),
                          child: Text(
                            imageDate,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppTextSize.medium *
                                  MediaQuery.of(context).size.width,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width:
                            35 * MediaQuery.of(context).size.width * kTextScale,
                        child: FlatButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogConfirm(
                                  title: 'Plant Thumbnail',
                                  text:
                                      'Would you like to use this image as the plant thumbail image?',
                                  onPressed: () async {
                                    //ensure logged in user id is saved for path creation
                                    Provider.of<CloudStore>(context)
                                        .setUserFolderID(
                                            (await Provider.of<UserAuth>(
                                                        context)
                                                    .getCurrentUser())
                                                .uid);
                                    //function bundle
                                    String url = await Provider.of<CloudStore>(
                                            context)
                                        .thumbnailPackage(
                                            imageURL: imageURL,
                                            plantID:
                                                Provider.of<AppData>(context)
                                                    .forwardingPlantID);
                                    //update the plant with new thumbnail url
                                    print(Provider.of<AppData>(context)
                                        .forwardingPlantID);
                                    Provider.of<CloudDB>(context)
                                        .updateDocumentInCollection(
                                            data: Provider.of<CloudDB>(context)
                                                .updatePairFull(
                                                    key: kPlantThumbnail,
                                                    value: url),
                                            collection: kUserPlants,
                                            documentName:
                                                Provider.of<AppData>(context)
                                                    .forwardingPlantID);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          },
                          child: Icon(Icons.grid_on,
                              color: Color(0x55FFFFFF),
                              size: AppTextSize.medium *
                                  MediaQuery.of(context).size.width),
                        ),
                      ),
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
