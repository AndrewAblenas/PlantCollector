import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/friend_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/message_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen.dart';
import 'package:plant_collector/widgets/container_card.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/info_tip.dart';
import 'package:provider/provider.dart';

class ViewerUtilityButtons extends StatelessWidget {
  final PlantData plant;
  ViewerUtilityButtons({@required this.plant});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.98 * MediaQuery.of(context).size.width,
      child: ContainerCard(
        color: AppTextColor.white,
        child: Row(
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
                                'Are you sure you want to copy this Plant information to your personal Library?',
                            buttonText: 'Clone',
                            hideCancel: false,
                            onPressed: () {
                              //PLANT
                              //generate a new ID
                              String plantID =
                                  AppData.generateID(prefix: 'plant_');
                              //clean the plant data
                              Map data = Provider.of<CloudDB>(context)
                                  .cleanPlant(
                                      plantData: plant.toMap(), id: plantID);
                              //add new plant to userPlants
                              Provider.of<CloudDB>(context).setDocumentL1(
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
                                  Provider.of<CloudDB>(context)
                                      .newDefaultCollection(
                                        collectionName: collectionID,
                                      )
                                      .toMap();
                              //now complete cloning
                              Provider.of<CloudDB>(context)
                                  .updateDefaultDocumentL2(
                                collectionL2: DBFolder.collections,
                                documentL2: collectionID,
                                key: CollectionKeys.plants,
                                entries: [plantID],
                                match: matchCollection,
                                defaultDocument: defaultCollection,
                              );

                              //GROUP
                              //first check if import group exists
                              bool matchGroup = false;
                              String groupID = DBDefaultDocument.import;
                              for (GroupData group
                                  in Provider.of<AppData>(context)
                                      .currentUserGroups) {
                                if (group.id == groupID) matchGroup = true;
                              }
                              //provide default document
                              Map defaultGroup = Provider.of<CloudDB>(context)
                                  .newDefaultGroup(
                                    groupName: groupID,
                                  )
                                  .toMap();
                              //now complete cloning
                              Provider.of<CloudDB>(context)
                                  .updateDefaultDocumentL2(
                                collectionL2: DBFolder.groups,
                                documentL2: groupID,
                                key: GroupKeys.collections,
                                entries: [collectionID],
                                match: matchGroup,
                                defaultDocument: defaultGroup,
                              );

                              //close
                              Navigator.pop(context);
                            });
                      },
                    );
                  },
                  text: 'Clone',
                  icon: Icons.control_point_duplicate),
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
                            StreamProvider<List<FriendData>>.value(
                              value: Provider.of<CloudDB>(context)
                                  .streamFriendsData(),
                              child: Consumer<List<FriendData>>(
                                builder:
                                    (context, List<FriendData> friends, _) {
                                  if (friends != null && friends.length >= 1) {
                                    List<Widget> connectionList = [];
                                    for (FriendData friend in friends) {
                                      connectionList.add(
                                        FutureProvider<Map>.value(
                                          value: Provider.of<CloudDB>(context)
                                              .getConnectionProfile(
                                                  connectionID: friend.id),
                                          child: Consumer<Map>(
                                            builder:
                                                (context, Map friendSnap, _) {
                                              if (friendSnap != null) {
                                                UserData friend =
                                                    UserData.fromMap(
                                                        map: friendSnap);
                                                return GestureDetector(
                                                  onTap: () {
                                                    //get document name
                                                    String document = Provider
                                                            .of<CloudDB>(
                                                                context)
                                                        .conversationDocumentName(
                                                            connectionId:
                                                                friend.id);
                                                    //create message
                                                    MessageData message =
                                                        Provider.of<CloudDB>(
                                                                context)
                                                            .createMessage(
                                                                text: '',
                                                                type: MessageKeys
                                                                    .typePlant,
                                                                media:
                                                                    plant.id);
                                                    CloudDB.sendMessage(
                                                        message: message,
                                                        document: document);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(2.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 50.0,
                                                          width: 50.0,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                AppTextColor
                                                                    .white,
                                                            backgroundImage: friend
                                                                        .avatar !=
                                                                    ''
                                                                ? CachedNetworkImageProvider(
                                                                    friend
                                                                        .avatar)
                                                                : AssetImage(
                                                                    'assets/images/default.png',
                                                                  ),
                                                          ),
                                                        ),
                                                        plant.name != ''
                                                            ? Padding(
                                                                padding: EdgeInsets.all(1.0 *
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    kScaleFactor),
                                                                child:
                                                                    Container(
                                                                  color: const Color(
                                                                      0x44000000),
                                                                  margin: EdgeInsets.all(2.0 *
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      kScaleFactor),
                                                                  padding: EdgeInsets.all(3.0 *
                                                                      MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      kScaleFactor),
                                                                  constraints:
                                                                      BoxConstraints(
                                                                    maxHeight: 18.0 *
                                                                        MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        kScaleFactor,
                                                                  ),
                                                                  child: Text(
                                                                    friend.name,
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
                                                                          MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                    //add a cancel button
                                    return GridView.count(
                                      primary: false,
                                      shrinkWrap: true,
                                      crossAxisCount: 5,
                                      children: connectionList,
                                      childAspectRatio: 0.75,
                                    );
                                  } else {
                                    return InfoTip(
                                        text: 'First add some friends,  \n'
                                            'then you can share to chat!');
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: AppTextSize.large *
                                  MediaQuery.of(context).size.width,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'CANCEL',
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
            Expanded(
              flex: 1,
              child: StreamProvider<UserData>.value(
                value: CloudDB.streamUserData(
                    userID: Provider.of<AppData>(context).currentUserInfo.id),
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
                      disabledIconColor: ((liked == false && ownPlant == false))
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
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5.0 * MediaQuery.of(context).size.width * kScaleFactor,
          vertical: 10.0 * MediaQuery.of(context).size.width * kScaleFactor,
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
