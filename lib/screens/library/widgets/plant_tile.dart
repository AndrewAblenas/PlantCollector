import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
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
        plant.imageSets.length >= 1 &&
        connectionLibrary == false) {
      String thumbUrl = plant.imageSets[0].thumb;
      //then package the data
      Map<String, dynamic> data = {
        PlantKeys.thumbnail: thumbUrl,
        //if a user has chosen to hide their library except from friends don't make globally visible
        PlantKeys.isVisible:
            !Provider.of<AppData>(context).currentUserInfo.privateLibrary,
      };
      //and finally upload the new thumbnail URL
      CloudDB.updateDocumentL1(
        collection: DBFolder.plants,
        document: plant.id,
        data: data,
      );
    }

    //*****SET WIDGET VISIBILITY START*****//

    //enable dialogs only if library belongs to the current user
    bool enableDialogs = (connectionLibrary == false);

    //show update bubble
    bool recentAdd = AppData.isNew(idWithTime: plant.id);
    bool recentUpdate = AppData.isRecentUpdate(lastUpdate: plant.update);
    bool showUpdateBubble = ((recentAdd || recentUpdate) && hideNew == false);

    //*****SET WIDGET VISIBILITY END*****//

    return GestureDetector(
      onTap: () {
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
      onLongPress: () {
        if (enableDialogs == true)
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogScreenSelect(
                title:
                    'Move this ${GlobalStrings.plant} to a different ${GlobalStrings.collection}',
                items: UIBuilders.createDialogCollectionButtons(
                  selectedItemID: plant.id,
                  currentParentID: collectionID,
                  possibleParents: possibleParents,
                ),
              );
            },
          );
      },
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
//          color: kGreenDark,
              shape: BoxShape.rectangle,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: plant.thumbnail != ''
                ? CachedNetworkImage(
                    imageUrl: plant.thumbnail,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, _) {
                      return PlantTileDefaultImage();
                    })
                : PlantTileDefaultImage(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //sized box
              SizedBox(
                width: double.infinity,
              ),
              //red new button
              (showUpdateBubble)
                  ? UpdateBubble(
                      color:
                          (recentAdd == true) ? Colors.red : Colors.redAccent,
                      text: (recentAdd == true) ? 'NEW' : 'UPDATE')
                  : SizedBox(),
              (showUpdateBubble)
                  ? Expanded(
                      child: SizedBox(),
                    )
                  : SizedBox(),
              plant.name != ''
                  ? Container(
                      color: const Color(0x55000000),
                      margin: EdgeInsets.all(3.0 *
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
                        softWrap: true,
                        style: TextStyle(
                          fontSize: AppTextSize.tiny *
                              MediaQuery.of(context).size.width,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}

class PlantTileDefaultImage extends StatelessWidget {
  const PlantTileDefaultImage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/images/default.png',
          fit: BoxFit.fill,
        ),
        Center(
          child: Icon(
            Icons.local_florist,
            color: Color(0x15FFFFFF),
            size: 0.22 * MediaQuery.of(context).size.width,
          ),
        ),
      ],
    );
  }
}

class UpdateBubble extends StatelessWidget {
  final Color color;
  final String text;

  UpdateBubble({@required this.color, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      margin: EdgeInsets.all(
          3.0 * MediaQuery.of(context).size.width * kScaleFactor),
      padding: EdgeInsets.all(
          3.0 * MediaQuery.of(context).size.width * kScaleFactor),
      constraints: BoxConstraints(
        maxHeight: 50.0 * MediaQuery.of(context).size.width * kScaleFactor,
      ),
      child: Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
        style: TextStyle(
          fontSize: AppTextSize.tiny * MediaQuery.of(context).size.width,
          color: Colors.white,
        ),
      ),
    );
  }
}
