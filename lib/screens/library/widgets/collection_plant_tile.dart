import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/screens/plant/plant.dart';
import 'package:plant_collector/widgets/dialogs/select/dialog_select.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';

class CollectionPlantTile extends StatelessWidget {
  final bool connectionLibrary;
  final String collectionID;
  final Map plantMap;
  final List<dynamic> possibleParents;
  CollectionPlantTile({
    @required this.connectionLibrary,
    @required this.collectionID,
    @required this.plantMap,
    @required this.possibleParents,
  });

  @override
  Widget build(BuildContext context) {
    //use this time to set the plantTile image thumbnail to the first image
    if (plantMap[kPlantThumbnail] == null &&
        plantMap[kPlantImageList] != null &&
        connectionLibrary == false) {
      List imageList = plantMap[kPlantImageList];
      int length = imageList.length;
      //this check is for a blank but not null list
      if (length == 1) {
        //run thumbnail package to get thumb url
        Provider.of<CloudStore>(context)
            .thumbnailPackage(
                imageURL: plantMap[kPlantImageList][0],
                plantID: plantMap[kPlantID])
            .then(
          (thumbUrl) {
            Provider.of<CloudDB>(context).updateDocumentInCollection(
                data: Provider.of<CloudDB>(context)
                    .updatePairFull(key: kPlantThumbnail, value: thumbUrl),
                collection: kUserPlants,
                documentName: plantMap[kPlantID]);
          },
        );
      }
    }

    return GestureDetector(
      onLongPress: () {
        connectionLibrary == false
            ? showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogSelect(
                    title: 'Move Plant',
                    text: 'Where would you like to move this plant?',
                    plantID: plantMap[kPlantID],
                    menuItems: Provider.of<UIBuilders>(context)
                        .createDialogCollectionButtons(
                      selectedItemID: plantMap[kPlantID],
                      currentParentID: collectionID,
                      possibleParents: possibleParents,
                    ),
                  );
                },
              )
            : null;
      },
      child: Container(
        decoration: BoxDecoration(
          color: kGreenDark,
          boxShadow: kShadowBox,
          shape: BoxShape.rectangle,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: plantMap[kPlantThumbnail] != null
                ? DecorationImage(
                    image:
                        CachedNetworkImageProvider(plantMap[kPlantThumbnail]),
                    fit: BoxFit.cover,
                  )
                : DecorationImage(
                    image: AssetImage(
                      'assets/images/default.png',
                    ),
                    fit: BoxFit.fill,
                  ),
          ),
          child: FlatButton(
            onPressed: () {
              Provider.of<AppData>(context).forwardingPlantID =
                  plantMap[kPlantID];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantScreen(
                    connectionLibrary: connectionLibrary,
                    plantID: plantMap[kPlantID],
                    forwardingCollectionID: collectionID,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                plantMap[kPlantName] != null
                    ? Padding(
                        padding: EdgeInsets.all(1.0 *
                            MediaQuery.of(context).size.width *
                            kScaleFactor),
                        child: Container(
                          color: const Color(0x44000000),
                          margin: EdgeInsets.all(2.0 *
                              MediaQuery.of(context).size.width *
                              kScaleFactor),
                          padding: EdgeInsets.all(3.0 *
                              MediaQuery.of(context).size.width *
                              kScaleFactor),
                          constraints: BoxConstraints(
                            maxHeight: 50.0 *
                                MediaQuery.of(context).size.width *
                                kScaleFactor,
                          ),
                          child: Text(
                            plantMap[kPlantName],
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: AppTextSize.tiny *
                                  MediaQuery.of(context).size.width,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
