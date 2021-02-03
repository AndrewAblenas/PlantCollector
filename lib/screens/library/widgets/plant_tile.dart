import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
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
        PlantKeys.isVisible: !Provider.of<AppData>(context, listen: false)
            .currentUserInfo
            .privateLibrary,
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
    bool recentAdd = AppData.isRecent(dateMS: plant.created);
    bool recentUpdate = AppData.isRecent(dateMS: plant.update);
    bool showUpdateBubble = ((recentAdd || recentUpdate) && hideNew == false);

    //*****SET WIDGET VISIBILITY END*****//

    return GestureDetector(
      onTap: () {
        Provider.of<AppData>(context, listen: false).forwardingPlantID =
            plant.id;
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
                title: 'Move to a different ${GlobalStrings.collection}',
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
                    // fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              5.0,
                            ),
                          ),
                        ),
                      );
                    },
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
                          (recentAdd == true) ? kBubbleUrgent : kBubbleLesser,
                      text: (recentAdd == true)
                          ? 'New ${AppData.plantTileText(creationDate: plant.created)}'
                          : 'Updated ${AppData.plantTileText(creationDate: plant.update)}')
                  : SizedBox(),
              (showUpdateBubble)
                  ? Expanded(
                      child: SizedBox(),
                    )
                  : SizedBox(),
              plant.name != ''
                  ? Container(
                      decoration: BoxDecoration(
                          color: kBubbleGreen,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0))),
                      // margin: EdgeInsets.all(2.0 *
                      //     MediaQuery.of(context).size.width *
                      //     kScaleFactor),
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
  final double iconScale;
  PlantTileDefaultImage({this.iconScale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/default.png',
                ),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.all(
              Radius.circular(
                5.0,
              ),
            ),
          ),
        ),
        Center(
          child: Icon(
            Icons.local_florist,
            color: Color(0x15FFFFFF),
            size: 0.22 * MediaQuery.of(context).size.width * iconScale,
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
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3.0),
      ),
      margin: EdgeInsets.all(
          3.0 * MediaQuery.of(context).size.width * kScaleFactor),
      padding: EdgeInsets.all(
          3.0 * MediaQuery.of(context).size.width * kScaleFactor),
      constraints: BoxConstraints(
        maxHeight: 50.0 * MediaQuery.of(context).size.width * kScaleFactor,
      ),
      child: Text(
        text,
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
