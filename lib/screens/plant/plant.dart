import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/friend_data.dart';
import 'package:plant_collector/models/data_types/message_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/plant/widgets/carousel_standard.dart';
import 'package:plant_collector/widgets/chat_avatar.dart';
import 'package:plant_collector/screens/dialog/dialog_screen.dart';
import 'package:plant_collector/screens/plant/widgets/action_button.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/info_tip.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:share/share.dart';

class PlantScreen extends StatelessWidget {
  final bool connectionLibrary;
  final String forwardingCollectionID;
  final String plantID;
  PlantScreen(
      {@required this.connectionLibrary,
      @required this.plantID,
      @required this.forwardingCollectionID});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<DocumentSnapshot>.value(
      value: Provider.of<CloudDB>(context).streamPlant(
          userID: connectionLibrary == false
              ? Provider.of<CloudDB>(context).currentUserFolder
              : Provider.of<CloudDB>(context).connectionUserFolder,
          plantID: plantID),
      child: Scaffold(
        backgroundColor: kGreenLight,
        appBar: AppBar(
          backgroundColor: kGreenDark,
          centerTitle: true,
          elevation: 20.0,
          title: Text(
            'Plant Profile',
            style: kAppBarTitle,
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Consumer<DocumentSnapshot>(
                builder: (context, DocumentSnapshot plantSnap, _) {
                  //after the first image has been taken, this will be rebuilt
                  if (plantSnap != null) {
                    PlantData plant = PlantData.fromMap(map: plantSnap.data);
                    //check number of widgets to decide what type to build
                    bool largeWidget =
                        (plant.images != null && plant.images.length >= 8)
                            ? false
                            : true;
                    List<Widget> items = UIBuilders.generateImageTileWidgets(
                      connectionLibrary: connectionLibrary,
                      plantID: plantID,
                      thumbnail: plant != null ? plant.thumbnail : null,
                      //the below check is necessary for deleting a plant via the button on plant screen
                      //reversed the image list so most recent photos are first
                      listURL: plant.images != null
                          ? plant.images.reversed.toList()
                          : null,
                      largeWidget: largeWidget,
                    );
                    //if there are too many photos, it's annoying to scroll.
                    //create a grid view to display instead
                    if (plant.images != null && plant.images.length >= 8) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                0.03 * MediaQuery.of(context).size.width),
                        child: GridView.count(
                          crossAxisCount: 3,
                          primary: false,
                          shrinkWrap: true,
                          mainAxisSpacing:
                              0.005 * MediaQuery.of(context).size.width,
                          crossAxisSpacing:
                              0.005 * MediaQuery.of(context).size.width,
                          children: items,
                        ),
                      );
                    } else if (items.length >= 1) {
                      return CarouselStandard(
                        items: items,
                        connectionLibrary: connectionLibrary,
                      );
                    } else {
                      return SizedBox();
                    }
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 0.01 * MediaQuery.of(context).size.width),
              child: Consumer<DocumentSnapshot>(
                builder: (context, DocumentSnapshot plantSnap, _) {
                  if (plantSnap != null) {
                    PlantData plant = PlantData.fromMap(map: plantSnap.data);
                    return ContainerWrapper(
                      child: UIBuilders.displayInfoCards(
                        connectionLibrary: connectionLibrary,
                        plant: plant,
                        context: context,
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            connectionLibrary == false
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ActionButton(
                        icon: Icons.delete_forever,
                        action: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogConfirm(
                                  title: 'Remove Plant',
                                  text:
                                      'Are you sure you would like to remove this plant?  All photos and all related information will be permanently deleted.  '
                                      '\n\nThis cannot be undone!',
                                  buttonText: 'Delete',
                                  onPressed: () {
                                    //pop dialog
                                    Navigator.pop(context);
                                    //remove plant reference from collection
                                    Provider.of<CloudDB>(context)
                                        .updateArrayInDocumentInCollection(
                                            arrayKey: CollectionKeys.plants,
                                            entries: [plantID],
                                            folder: DBFolder.collections,
                                            documentName:
                                                forwardingCollectionID,
                                            action: false);
                                    //delete plant
                                    Provider.of<CloudDB>(context)
                                        .deleteDocumentFromCollection(
                                            documentID: plantID,
                                            collection: DBFolder.plants);
                                    //pop old plant profile
                                    Navigator.pop(context);
                                    //NOTE: deletion of images is handled by a DB function
                                  });
                            },
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Consumer<DocumentSnapshot>(
                        builder: (context, DocumentSnapshot plantSnap, _) {
                          return ActionButton(
                            icon: Icons.share,
                            action: () {
                              Share.share(
                                UIBuilders.sharePlant(plantMap: plantSnap.data),
                                subject:
                                    'Check out this plant via Plant Collector!',
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      //share plant to in app chat recipient
                      ActionButton(
                        icon: Icons.chat,
                        action: () {
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
                                      builder: (context,
                                          List<FriendData> friends, _) {
                                        if (friends != null &&
                                            friends.length >= 1) {
                                          List<Widget> connectionList = [];
                                          for (FriendData friend in friends) {
                                            connectionList.add(
                                              FutureProvider<Map>.value(
                                                value: Provider.of<CloudDB>(
                                                        context)
                                                    .getConnectionProfile(
                                                        connectionID:
                                                            friend.id),
                                                child: Consumer<Map>(
                                                  builder: (context,
                                                      Map friendSnap, _) {
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
                                                                      friend
                                                                          .id);
                                                          //create message
                                                          MessageData message = Provider
                                                                  .of<CloudDB>(
                                                                      context)
                                                              .createMessage(
                                                                  text: '',
                                                                  type: MessageKeys
                                                                      .typePlant,
                                                                  media:
                                                                      plantID);
                                                          CloudDB.sendMessage(
                                                              message: message,
                                                              document:
                                                                  document);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10.0),
                                                          child: ChatAvatar(
                                                            avatarLink:
                                                                friend.avatar,
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
                                            crossAxisCount: 3,
                                            children: connectionList,
                                            childAspectRatio: 1,
                                          );
                                        } else {
                                          return InfoTip(
                                              text:
                                                  'First add some friends,  \n'
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
                      ),
                    ],
                  )
                //otherwise provide an option to clone the plant
                : SizedBox(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
