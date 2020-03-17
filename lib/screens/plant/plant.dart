import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/plant/widgets/carousel_standard.dart';
import 'package:plant_collector/screens/search/widgets/search_tile_user.dart';
import 'package:plant_collector/widgets/admin_button.dart';
import 'package:plant_collector/screens/plant/widgets/action_button.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:share/share.dart';

class PlantScreen extends StatelessWidget {
  final bool connectionLibrary;
  final bool communityView;
  final String forwardingCollectionID;
  final String plantID;
  PlantScreen(
      {@required this.connectionLibrary,
      @required this.communityView,
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
                        child: ContainerWrapper(
                          color: kGreenMedium,
                          marginVertical: 0.0,
                          child: Padding(
                            padding: EdgeInsets.all(
                              5.0 *
                                  MediaQuery.of(context).size.width *
                                  kScaleFactor,
                            ),
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
                          ),
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
                  //check for data as well so that if delete plant no error calling owner later for admin
                  if (plantSnap != null && plantSnap.data != null) {
                    PlantData plant = PlantData.fromMap(map: plantSnap.data);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ContainerWrapper(
                          child: Column(
                            children: <Widget>[
                              UIBuilders.displayInfoCards(
                                connectionLibrary: connectionLibrary,
                                plant: plant,
                                context: context,
                              ),
                              communityView == false
                                  ? SizedBox()
                                  : FutureProvider<UserData>.value(
                                      value: CloudDB.futureUserData(
                                        userID: plant.owner,
                                      ),
                                      child: Consumer<UserData>(
                                        builder: (context, user, _) {
                                          if (user == null) {
                                            return SizedBox();
                                          } else {
                                            return Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: SearchUserTile(user: user),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                              //ADMIN AND CREATOR ONLY FUNCTION!
                              Provider.of<AppData>(context)
                                          .currentUserInfo
                                          .type !=
                                      UserTypes.creator
                                  ? SizedBox()
                                  : AdminButton(
                                      label: 'Delete user plant',
                                      onPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DialogConfirm(
                                                title: 'Remove Plant',
                                                text:
                                                    'Are you sure you would like to remove this plant?  All photos and all related information will be permanently deleted.  '
                                                    '\n\nThis cannot be undone!',
                                                buttonText: 'Delete',
                                                onPressed: () async {
                                                  //get the collection
                                                  List<CollectionData>
                                                      collections =
                                                      await CloudDB
                                                          .futureCollectionsData(
                                                              userID:
                                                                  plant.owner);
                                                  //check for plant id
                                                  for (CollectionData collection
                                                      in collections) {
                                                    if (collection.plants
                                                        .contains(plant.id)) {
                                                      //remove plant reference from collection
                                                      await Provider.of<
                                                              CloudDB>(context)
                                                          .updateDocumentL2Array(
                                                        collectionL1:
                                                            DBFolder.users,
                                                        documentL1: plant.owner,
                                                        collectionL2: DBFolder
                                                            .collections,
                                                        documentL2:
                                                            collection.id,
                                                        key: CollectionKeys
                                                            .plants,
                                                        entries: [plantID],
                                                        action: false,
                                                      );
                                                    }
                                                  }
                                                  //delete plant
                                                  await Provider.of<CloudDB>(
                                                          context)
                                                      .deleteDocumentL1(
                                                          document: plantID,
                                                          collection:
                                                              DBFolder.plants);
                                                  //pop dialog
                                                  Navigator.pop(context);
                                                  //pop old plant profile
                                                  Navigator.pop(context);
                                                  //NOTE: deletion of images is handled by a DB function
                                                });
                                          },
                                        );
                                      },
                                    )
                            ],
                          ),
                        ),
                        (connectionLibrary == true)
                            ? SizedBox()
                            : ContainerWrapper(
                                child: Column(
                                  children: <Widget>[
                                    UIBuilders.displayJournalTiles(
                                        journals: plant.journal,
                                        plantID: plant.id)
                                  ],
                                ),
                              ),
                      ],
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
                ? Consumer<DocumentSnapshot>(
                    builder: (context, DocumentSnapshot plantSnap, _) {
                      if (plantSnap != null) {
                        PlantData plant =
                            PlantData.fromMap(map: plantSnap.data);
                        return Row(
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
                                      hideCancel: false,
                                      onPressed: () {
                                        //pop dialog
                                        Navigator.pop(context);
                                        if (plant.owner ==
                                            Provider.of<AppData>(context)
                                                .currentUserInfo
                                                .id) {
                                          //remove plant reference from collection
                                          Provider.of<CloudDB>(context)
                                              .updateArrayInDocumentInCollection(
                                                  arrayKey:
                                                      CollectionKeys.plants,
                                                  entries: [plantID],
                                                  folder: DBFolder.collections,
                                                  documentName:
                                                      forwardingCollectionID,
                                                  action: false);
                                          //delete plant
                                          Provider.of<CloudDB>(context)
                                              .deleteDocumentL1(
                                                  document: plantID,
                                                  collection: DBFolder.plants);
                                          //pop old plant profile
                                          Navigator.pop(context);
                                          //NOTE: deletion of images is handled by a DB function
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            ActionButton(
                              icon: Icons.share,
                              action: () {
                                Share.share(
                                  UIBuilders.sharePlant(
                                      plantMap: plantSnap.data),
                                  subject:
                                      'Check out this plant via Plant Collector!',
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  )
                //otherwise provide an option to clone the plant
                : SizedBox(),
            //ADMIN AND CREATOR ONLY VISIBLE
            (Provider.of<AppData>(context).currentUserInfo.type ==
                        UserTypes.admin ||
                    Provider.of<AppData>(context).currentUserInfo.type ==
                        UserTypes.creator)
                ? Text(
                    plantID,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTextColor.black,
                      fontWeight: AppTextWeight.medium,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
