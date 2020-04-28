import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/message_data.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/chat/chat.dart';
import 'package:plant_collector/screens/dialog/dialog_screen.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/info_tip.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';

class ViewerUtilityButtons extends StatelessWidget {
  final PlantData plant;
  final bool showPlantStatus;
  ViewerUtilityButtons({@required this.plant, @required this.showPlantStatus});
  @override
  Widget build(BuildContext context) {
    //status text to display
    String statusText = '';
    if (plant.sell == true) {
      statusText = 'This Plant is for Sale or Trade';
    } else if (plant.want == true) {
      statusText = 'This Plant is on a Wishlist';
    } else {
      statusText = '';
    }

    return Container(
      width: 0.98 * MediaQuery.of(context).size.width,
      child: TileWhite(
        bottomPadding: 0.0,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: UtilityButton(
                      onPress: () {
                        //show confirm dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogConfirm(
                                title: 'Clone Plant',
                                text:
                                    'Copy the basic Plant information and thumbnail to the "Clone" Shelf in your Library?',
                                buttonText: 'Clone',
                                hideCancel: false,
                                onPressed: () {
                                  //PLANT
                                  //generate a new ID
                                  String newPlantID =
                                      AppData.generateID(prefix: 'plant_');
                                  //clean the plant data
                                  Map data = AppData.cleanPlant(
                                      plantData: plant.toMap(),
                                      newPlantID: newPlantID,
                                      newUserID: Provider.of<AppData>(context)
                                          .currentUserInfo
                                          .id);
                                  //add new plant to userPlants
                                  CloudDB.setDocumentL1(
                                      data: data,
                                      collection: DBFolder.plants,
                                      document: data[PlantKeys.id]);

                                  //CHECK COLLECTION FIRST
                                  //first check if clone collection exists
                                  bool matchCollection = false;
                                  String collectionID = DBDefaultDocument.clone;
                                  for (CollectionData collection
                                      in Provider.of<AppData>(context)
                                          .currentUserCollections) {
                                    if (collection.id == collectionID)
                                      matchCollection = true;
                                  }
                                  //provide default document
                                  Map defaultCollection =
                                      AppData.newDefaultCollection(
                                    collectionID: collectionID,
                                  ).toMap();
                                  //now complete cloning to collection
                                  Provider.of<CloudDB>(context)
                                      .updateDefaultDocumentL2(
                                    collectionL2: DBFolder.collections,
                                    documentL2: collectionID,
                                    key: CollectionKeys.plants,
                                    entries: [newPlantID],
                                    match: matchCollection,
                                    defaultDocument: defaultCollection,
                                  );
                                  //finally update the original plant clone count
                                  Map<String, dynamic> update = {
                                    PlantKeys.clones: plant.clones + 1
                                  };
                                  CloudDB.updateDocumentL1(
                                      collection: DBFolder.plants,
                                      document: plant.id,
                                      data: update);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogConfirm(
                                            title: 'Success',
                                            text:
                                                'This plant has been cloned to your Library.  '
                                                'You can move it to one of your Shelves and add information/photos to make it your own.',
                                            buttonText: 'OK',
                                            hideCancel: true,
                                            onPressed: () {
                                              //pop success
                                              Navigator.pop(context);
                                              //pop confirm
                                              Navigator.pop(context);
                                            });
                                      });
                                });
                          },
                        );
                      },
                      text: 'Clone',
                      icon: Icons.control_point_duplicate),
                ),
                SizedBox(
                  width: 0.01 * MediaQuery.of(context).size.width,
                ),
                Expanded(
                  flex: 1,
                  child: UtilityButton(
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DialogScreen(
                              title: 'Share Plant',
                              children: <Widget>[
                                Provider<List>.value(
                                  value: Provider.of<AppData>(context)
                                      .currentUserInfo
                                      .friends,
                                  child: Consumer<List>(
                                    builder: (context, List friends, _) {
                                      if (friends != null &&
                                          friends.length >= 1) {
                                        List<Widget> connectionList = [];
                                        for (String friend in friends) {
                                          connectionList
                                              .add(FutureProvider<Map>.value(
                                            value: CloudDB.getConnectionProfile(
                                                connectionID: friend),
                                            child: Consumer<Map>(
                                              builder:
                                                  (context, Map friendMap, _) {
                                                if (friendMap == null) {
                                                  return SizedBox();
                                                } else {
                                                  UserData profile =
                                                      UserData.fromMap(
                                                          map: friendMap);
                                                  return GestureDetector(
                                                      onTap: () {
                                                        //get document name
                                                        String document = Provider
                                                                .of<CloudDB>(
                                                                    context)
                                                            .conversationDocumentName(
                                                                connectionId:
                                                                    friend);
                                                        //create message
                                                        MessageData message =
                                                            AppData.createMessage(
                                                                senderID: Provider.of<
                                                                            AppData>(
                                                                        context)
                                                                    .currentUserInfo
                                                                    .id,
                                                                text: '',
                                                                type: MessageKeys
                                                                    .typePlant,
                                                                media:
                                                                    plant.id);
                                                        CloudDB.sendMessage(
                                                            message: message,
                                                            document: document);
                                                        //pop the window
                                                        Navigator.pop(context);
                                                        //navigate to chat
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                ChatScreen(
                                                              friend: profile,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: Stack(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          children: <Widget>[
                                                            Container(
                                                              height: 200.0,
                                                              width: 200.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image: profile
                                                                              .avatar !=
                                                                          ''
                                                                      ? CachedNetworkImageProvider(
                                                                          profile
                                                                              .avatar)
                                                                      : AssetImage(
                                                                          'assets/images/default.png',
                                                                        ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            Container(
                                                              color:
                                                                  kGreenMediumOpacity,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight: 20.0 *
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    kScaleFactor,
                                                              ),
                                                              child: Text(
                                                                profile.name,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: AppTextSize
                                                                          .tiny *
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                }
                                              },
                                            ),
                                          ));
                                        }
                                        return GridView.count(
                                          primary: false,
                                          shrinkWrap: true,
                                          crossAxisCount: 5,
                                          children: connectionList,
//                                      childAspectRatio: 1.0,
                                        );
                                      } else {
                                        return InfoTip(
                                            onPress: () {},
                                            showAlways: true,
                                            text: 'First add some friends,  \n'
                                                'then you can share to chat!');
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: AppTextSize.large *
                                          MediaQuery.of(context).size.width,
                                      fontWeight: AppTextWeight.medium,
                                      color: kButtonCancel,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      text: 'Share',
                      icon: Icons.person),
                ),
                SizedBox(
                  width: 0.01 * MediaQuery.of(context).size.width,
                ),
                Expanded(
                  flex: 1,
                  child: StreamProvider<UserData>.value(
                    value: CloudDB.streamUserData(
                        userID:
                            Provider.of<AppData>(context).currentUserInfo.id),
                    child: Consumer<UserData>(builder: (context, user, _) {
                      if (user != null) {
                        //check if the current user owns the plant
                        bool ownPlant = (plant.owner ==
                            Provider.of<AppData>(context).currentUserInfo.id);
                        //check if the current user liked the plant
                        bool liked = (user.likedPlants.contains(plant.id));
                        return UtilityButton(
                          onPress: () {
                            //only allow onPress function if it isn't your plant
                            if (ownPlant == false)
                              Provider.of<CloudDB>(context).updatePlantLike(
                                  plantID: plant.id,
                                  likes: plant.likes,
                                  likeList: user.likedPlants);
                          },
                          text: plant.likes.toString(),
                          icon: Icons.thumb_up,
                          disabledIconColor:
                              ((liked == false && ownPlant == false))
                                  ? AppTextColor.medium
                                  : null,
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
                  ),
                ),
              ],
            ),
            (showPlantStatus == true)
                ? Padding(
                    padding: EdgeInsets.all(
                        0.01 * MediaQuery.of(context).size.width),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          size: AppTextSize.small *
                              MediaQuery.of(context).size.width,
                          color: kGreenDark,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: AppTextColor.black,
                            fontSize: AppTextSize.small *
                                MediaQuery.of(context).size.width,
                            fontWeight: AppTextWeight.medium,
//                shadows: kShadowText,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class UtilityButton extends StatelessWidget {
  UtilityButton(
      {@required this.onPress,
      @required this.text,
      @required this.icon,
      this.disabledIconColor});

  final Function onPress;
  final String text;
  final IconData icon;
  final Color disabledIconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              width: 1.0,
              color: AppTextColor.whitish,
            )),
        margin: EdgeInsets.symmetric(
          horizontal: 0.005 * MediaQuery.of(context).size.width,
          vertical: 0.005 * MediaQuery.of(context).size.width,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 0.01 * MediaQuery.of(context).size.width,
          vertical: 0.015 * MediaQuery.of(context).size.width,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: AppTextSize.small * MediaQuery.of(context).size.width,
              color:
                  (disabledIconColor != null) ? disabledIconColor : kGreenDark,
            ),
            SizedBox(
              width: 10.0 * MediaQuery.of(context).size.width * kScaleFactor,
            ),
            Text(
              text,
              style: TextStyle(
                color: AppTextColor.black,
                fontSize: AppTextSize.small * MediaQuery.of(context).size.width,
                fontWeight: AppTextWeight.medium,
//                shadows: kShadowText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
