import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_select.dart';
import 'package:plant_collector/screens/plant/plant.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';

class PlantTile extends StatelessWidget {
  final bool connectionLibrary;
  final String collectionID;
  final PlantData plant;
  final List<dynamic> possibleParents;
  PlantTile({
    @required this.connectionLibrary,
    @required this.collectionID,
    @required this.plant,
    @required this.possibleParents,
  });

  @override
  Widget build(BuildContext context) {
    //use this time to set the plantTile image thumbnail to the first image
    if (plant.thumbnail == '' &&
        plant.images != [] &&
        connectionLibrary == false) {
      List imageList = plant.images;
      int length = imageList.length;
      //this check is for a blank but not null list
      if (length == 1) {
        //run thumbnail package to get thumb url
        Provider.of<CloudStore>(context)
            .thumbnailPackage(imageURL: plant.images[0], plantID: plant.id)
            .then(
          (thumbUrl) {
            Provider.of<CloudDB>(context).updateDocumentInCollection(
                data: CloudDB.updatePairFull(
                    key: PlantKeys.thumbnail, value: thumbUrl),
                collection: DBFolder.plants,
                documentName: plant.id);
          },
        );
      }
    }

    return GestureDetector(
      onLongPress: () {
        if (connectionLibrary == false)
          showDialog(
            context: context,
            builder: (BuildContext context) {
              //remove the auto generated import collections
              List<CollectionData> reducedParents = [];
              for (CollectionData collection in possibleParents) {
                if (collection.id != DBDefaultDocument.clone) {
                  reducedParents.add(collection);
                }
              }
              return DialogScreenSelect(
                title:
                    'Move this ${GlobalStrings.plant} to a different ${GlobalStrings.collection}',
                items: UIBuilders.createDialogCollectionButtons(
                  selectedItemID: plant.id,
                  currentParentID: collectionID,
                  possibleParents: reducedParents,
                ),
              );
            },
          );
      },
      child: Container(
        decoration: BoxDecoration(
          color: kGreenDark,
//          boxShadow: kShadowBox,
          shape: BoxShape.rectangle,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: plant.thumbnail != ''
                ? DecorationImage(
                    image: CachedNetworkImageProvider(plant.thumbnail),
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
              Provider.of<AppData>(context).forwardingPlantID = plant.id;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlantScreen(
                    connectionLibrary: connectionLibrary,
                    plantID: plant.id,
                    forwardingCollectionID: collectionID,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                AppData.isNew(idWithTime: plant.id)
                    ? Padding(
                        padding: EdgeInsets.all(1.0 *
                            MediaQuery.of(context).size.width *
                            kScaleFactor),
                        child: Container(
                          color: Colors.red,
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
                            'NEW',
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
                    : SizedBox(),
                AppData.isNew(idWithTime: plant.id)
                    ? Expanded(
                        child: SizedBox(),
                      )
                    : SizedBox(),
                plant.name != ''
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
                            plant.name,
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
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
