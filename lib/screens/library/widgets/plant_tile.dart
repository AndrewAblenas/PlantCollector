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
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';

class PlantTile extends StatelessWidget {
  final bool connectionLibrary;
  final bool communityView;
  final String collectionID;
  final PlantData plant;
  final List<dynamic> possibleParents;
  final bool hideNew;
  PlantTile({
    @required this.connectionLibrary,
    @required this.communityView,
    @required this.collectionID,
    @required this.plant,
    @required this.possibleParents,
    this.hideNew = false,
  });

  @override
  Widget build(BuildContext context) {
    //*****AUTOMATICALLY SET FIRST ADDED IMAGE AS THUMBNAIL*****//

    //if no thumbnail, and firsts image added, and current user Library
    if (plant.thumbnail == '' &&
        plant.images.length == 1 &&
        connectionLibrary == false) {
      //delay to stop image ref call before DB knows it exists to avoid error
      Future.delayed(Duration(seconds: 3)).then((value) {
        //then generate the thumbnail URL
        Provider.of<CloudStore>(context)
            .thumbnailPackage(imageURL: plant.images[0], plantID: plant.id)
            .then(
          (thumbUrl) {
            //then package the data
            Map<String, dynamic> data = {
              PlantKeys.thumbnail: thumbUrl,
              //if a user has chosen to hide their library except from friends don't make globally visible
              PlantKeys.isVisible:
                  !Provider.of<AppData>(context).currentUserInfo.privateLibrary,
            };
            //and finally upload the new thumbnail URL
            Provider.of<CloudDB>(context).updateDocumentL1(
              collection: DBFolder.plants,
              document: plant.id,
              data: data,
            );
          },
        );
      });
    }

    //*****SET WIDGET VISIBILITY START*****//

    //enable dialogs only if library belongs to the current user
    bool enableDialogs = (connectionLibrary == false);

    //*****SET WIDGET VISIBILITY END*****//

    return GestureDetector(
      onLongPress: () {
        if (enableDialogs == true)
          showDialog(
            context: context,
            builder: (BuildContext context) {
              //remove the auto generated import collections
              List<CollectionData> reducedParents = [];
              for (CollectionData collection in possibleParents) {
                if (!DBDefaultDocument.collectionExclude
                    .contains(collection.id)) {
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
//          color: kGreenDark,
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
                    communityView: communityView,
                    plantID: plant.id,
                    forwardingCollectionID: collectionID,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                (AppData.isNew(idWithTime: plant.id) && hideNew == false)
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
