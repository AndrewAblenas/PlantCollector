import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/button_dialogs.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/communication_data.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/models/push_notifications_service.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_select.dart';
import 'package:plant_collector/screens/library/widgets/add_plant.dart';
import 'package:plant_collector/screens/library/widgets/announcements.dart';
import 'package:plant_collector/screens/library/widgets/communications.dart';
import 'package:plant_collector/screens/plant/widgets/add_journal_button.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/screens/library/widgets/profile_header.dart';
import 'package:plant_collector/widgets/dialogs/select/dialog_item.dart';
import 'package:plant_collector/widgets/info_tip.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/formats/colors.dart';

//This screen is the main application screen.
//A row of statistics is provided at the top.
//This is followed by a list of Groups.
//These Groups in turn contain Collections.
//Collections contain a user's plants.

class LibraryScreen extends StatelessWidget {
  final String userID;
  final bool connectionLibrary;
  LibraryScreen({@required this.userID, this.connectionLibrary = true});
  @override
  Widget build(BuildContext context) {
    //easy reference
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: false);
    CloudDB provCloudDBFalse = Provider.of<CloudDB>(context, listen: false);
    CloudStore provCloudStoreFalse =
        Provider.of<CloudStore>(context, listen: false);
    //easy scale
    double width = MediaQuery.of(context).size.width;
    if (connectionLibrary == false) {
      //make current user ID available to CloudDB and CloudStore instances
      provCloudDBFalse.setUserFolder(userID: userID);
      provCloudStoreFalse.setUserFolder(userID: userID);
      provAppDataFalse.showTipsHelpers();
      //user this time to set last user activity
      Map<String, dynamic> timestamp = {
        UserKeys.lastActive: DateTime.now().millisecondsSinceEpoch
      };
      CloudDB.updateDocumentL1(
          collection: DBFolder.users, document: userID, data: timestamp);
      //initialize firebase messaging push functions
    } else {
      //make friend ID available to CloudDB and CloudStore instances to display friend library
//      provCLoudDBFalse.setConnectionFolder(connectionID: userID);
      provCloudStoreFalse.setConnectionFolder(connectionID: userID);
      provAppDataFalse.showTips = false;
    }
    //*****SET WIDGET VISIBILITY START*****//

    //title text and spacing
    String screenTitle = (connectionLibrary == false)
        ? 'My ${GlobalStrings.library}'
        : '${GlobalStrings.friend} ${GlobalStrings.library}';
//    double screenTitleSizedBoxWidth = (connectionLibrary == false) ? 0.0 : 50.0;

    //show add shelf only if library belongs to the current user
    //show add floating button only if library belongs to current user
    bool showAddButton = (connectionLibrary == false);

    //show bottom nav only if library belongs to the current user
    bool showBottomNavBar = (connectionLibrary == false);

    //do not show title back button if library belongs to the current user
    bool showTitleBackButton = (connectionLibrary == true);

    //*****SET WIDGET VISIBILITY END*****//

    return MultiProvider(
      providers: [
        StreamProvider<UserData>.value(
          value: CloudDB.streamUserData(userID: userID),
        ),
        StreamProvider<List<CollectionData>>.value(
          value: CloudDB.streamCollectionsData(userID: userID),
        ),
        StreamProvider<List<PlantData>>.value(
          value: CloudDB.streamPlantsData(userID: userID),
        ),
      ],
      child: ScreenTemplate(
        screenTitle: screenTitle,
        implyLeading: showTitleBackButton,
        backgroundColor: kGreenLight,
        actionButton:
            //floating action button
            (showAddButton == true)
                ? Padding(
                    padding: EdgeInsets.only(bottom: 0.1 * width),
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: kGreenDark50,
                      foregroundColor: AppTextColor.white,
                      // mini: true,
                      shape: RoundedRectangleBorder(
                        side:
                            BorderSide(width: 1.0, color: AppTextColor.whitish),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        //first determine possible parents
                        List<CollectionData> plantTilePossibleParents =
                            (connectionLibrary == false)
                                ? provAppDataFalse.currentUserCollections
                                : provAppDataFalse.connectionCollections;
                        //remove the auto generated import collections and hidden
                        List<CollectionData> reducedParents = [];
                        for (CollectionData collection
                            in plantTilePossibleParents) {
                          if (collection.id == DBDefaultDocument.wishList) {
                            //check wishlist visibility
                            if (provAppDataFalse.currentUserInfo.showWishList ==
                                true) reducedParents.add(collection);
                          } else if (collection.id ==
                              DBDefaultDocument.sellList) {
                            //check sell list visibility
                            if (provAppDataFalse.currentUserInfo.showSellList ==
                                true) reducedParents.add(collection);
                          } else if (collection.id ==
                              DBDefaultDocument.compostList) {
                            //check compost list visibility
                            if (provAppDataFalse
                                    .currentUserInfo.showCompostList ==
                                true) reducedParents.add(collection);
                          } else if (!DBDefaultDocument
                              .collectionPreventMoveInto
                              .contains(collection.id)) {
                            reducedParents.add(collection);
                          }
                        }
                        //sort
                        reducedParents = UIBuilders.sortCollections(
                            userCollections: reducedParents);
                        //create a button for each collection
                        List<Widget> buttons = [];
                        for (CollectionData collection in reducedParents) {
                          buttons.add(DialogItem(
                              buttonText: collection.name,
                              id: collection.id,
                              onPress: () {
                                provAppDataFalse.selectOption = collection.id;
                                Navigator.pop(context);
                              }));
                        }

                        //present dialog to place plant on shelf
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogScreenSelect(
                                title: 'Select a ${GlobalStrings.collection}',
                                items: buttons);
                          },
                        );
                        //continue
                        //if there is an active connection continue
                        bool active = await connectionActive();
                        //make sure connection is active and an option was previously selected
                        if (active == true &&
                            provAppDataFalse.selectOption != null) {
                          //initialize data here (generate only one ID here to prevent duplicate uploads on multiple button taps)
                          String newPlantID =
                              AppData.generateID(prefix: 'plant_');
                          //now present the add plant dialog
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AppDialogNewPlantName(
                                  collectionID: provAppDataFalse.selectOption,
                                  newPlantID: newPlantID,
                                  nextDialog: true,
                                );
                              });
                        } else if (active == false) {
                          //show a dialog with error
                          print('Check Connection');
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AppDialogCheckNetwork();
                              });
                        }
                        //reset holding value to null
                        provAppDataFalse.selectOption = null;
                        //TODO ensure orphan works correctly
                        //give the library time to reload
                        await Future.delayed(Duration(seconds: 5))
                            .then((value) {
                          //now check for orphaned plants
                          List<String> orphaned = AppData.orphanedPlantCheck(
                            collections:
                                provAppDataFalse.currentUserCollections,
                            plants: provAppDataFalse.currentUserPlants,
                          );

                          //re-home the plants to the Orphaned Shelf
                          rehomeOrphanedPlants(
                              orphaned: orphaned, context: context);
                        });
                      },
                      child: Icon(
                        Icons.add_circle_outline,
                        size: AppTextSize.huge * width,
                      ),
                    ),
                  )
                : SizedBox(),
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                    //this is a workaround to prevent listview jump when loading the contained streams
                    minHeight: 0.9 * MediaQuery.of(context).size.width),
                child: Consumer<UserData>(builder: (context, user, _) {
                  if (user != null) {
                    //there was an issue where only currentUserInfo existed
                    //this meant it the file was saved over when visiting a connection library!
                    if (connectionLibrary == false) {
                      //save the logged in user data
                      provAppDataFalse.currentUserInfo = user;

                      //take this time to make sure the device is registered
                      //get the token
                      Provider.of<PushNotificationService>(context,
                              listen: false)
                          .getDevicePushToken()
                          .then((token) {
                        //check to see if the device token is missing from the list
                        if (!user.devicePushTokens.contains(token)) {
                          //if missing add it to the user profile
                          provCloudDBFalse.updateUserArray(
                              action: true,
                              entries: [token],
                              arrayKey: UserKeys.devicePushTokens);
                        }
                      });
                    } else {
                      //save the friend data
                      provAppDataFalse.connectionUserInfo = user;
                    }
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 4.0),
                        ProfileHeader(
                          connectionLibrary: connectionLibrary,
                          user: user,
                        ),
                        (connectionLibrary != false)
                            ? SizedBox()
                            : Container(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 3.0),
                                    SectionHeader(
                                      title: 'Activity Journal',
                                      //provide the add button
                                      trailing: (connectionLibrary == false)
                                          ? AddJournalButton(
                                              documentID: user.id,
                                              collection: DBFolder.users,
                                              documentKey: UserKeys.journal)
                                          : SizedBox(),
                                    ),
                                    SizedBox(height: 1.0),
                                    Column(
                                      children: <Widget>[
                                        UIBuilders.displayActivityJournalTiles(
                                            connectionLibrary:
                                                connectionLibrary,
                                            journals: user.journal,
                                            userPlantCount: user.plants,
                                            documentID: user.id,
                                            limit: 3,
                                            context: context)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                        Column(
                          children: <Widget>[
                            Consumer<List<CollectionData>>(
                              builder: (context,
                                  List<CollectionData> collections, _) {
                                if (collections == null) return Column();
                                if (connectionLibrary == false) {
                                  provAppDataFalse.currentUserCollections =
                                      collections;

                                  //UPDATE SHELF COUNT
                                  //initialize
                                  int filterTally = 0;
                                  bool wishListFound = false;
                                  bool sellListFound = false;
                                  bool compostListFound = false;
                                  //exclude any any auto-generated or hidden shelves from the count
                                  for (CollectionData collection
                                      in provAppDataFalse
                                          .currentUserCollections) {
                                    if (!DBDefaultDocument.collectionAutoGen
                                        .contains(collection.id)) {
                                      filterTally++;
                                    }
                                    //check for wish visibility
                                    if (collection.id ==
                                        DBDefaultDocument.wishList) {
                                      wishListFound = true;
                                    }
                                    //check for sell visibility
                                    if (collection.id ==
                                        DBDefaultDocument.sellList) {
                                      sellListFound = true;
                                    }
                                    //check for compost visibility
                                    if (collection.id ==
                                        DBDefaultDocument.compostList) {
                                      compostListFound = true;
                                    }
                                  }

                                  //TODO creating these may overwrite sometimes
                                  //create wishlist if not found
                                  if (wishListFound == false) {
                                    Map<String, dynamic> upload =
                                        AppData.newDefaultCollection(
                                                collectionID:
                                                    DBDefaultDocument.wishList,
                                                collectionName: 'Wishlist')
                                            .toMap();
                                    CloudDB.setDocumentL2(
                                        collectionL1: DBFolder.users,
                                        documentL1:
                                            provAppDataFalse.currentUserInfo.id,
                                        collectionL2: DBFolder.collections,
                                        documentL2: DBDefaultDocument.wishList,
                                        data: upload,
                                        merge: true);
                                  }

                                  //create sell if not found
                                  if (sellListFound == false) {
                                    Map<String, dynamic> upload =
                                        AppData.newDefaultCollection(
                                                collectionID:
                                                    DBDefaultDocument.sellList,
                                                collectionName: 'Sell or Trade')
                                            .toMap();
                                    CloudDB.setDocumentL2(
                                        collectionL1: DBFolder.users,
                                        documentL1:
                                            provAppDataFalse.currentUserInfo.id,
                                        collectionL2: DBFolder.collections,
                                        documentL2: DBDefaultDocument.sellList,
                                        data: upload,
                                        merge: true);
                                  }

                                  //create compost if not found
                                  if (compostListFound == false) {
                                    Map<String, dynamic> upload =
                                        AppData.newDefaultCollection(
                                                collectionID: DBDefaultDocument
                                                    .compostList,
                                                collectionName: 'Compost')
                                            .toMap();
                                    CloudDB.setDocumentL2(
                                        collectionL1: DBFolder.users,
                                        documentL1:
                                            provAppDataFalse.currentUserInfo.id,
                                        collectionL2: DBFolder.collections,
                                        documentL2:
                                            DBDefaultDocument.compostList,
                                        data: upload,
                                        merge: true);
                                  }

                                  //update tally in user document
                                  if (provAppDataFalse.currentUserCollections !=
                                          null &&
                                      provAppDataFalse.currentUserInfo != null
                                      //don't bother updating if the values are the same
                                      &&
                                      filterTally !=
                                          provAppDataFalse
                                              .currentUserInfo.collections) {
                                    Map countData = AppData.updatePairFull(
                                        key: UserKeys.collections,
                                        value: filterTally);
                                    provCloudDBFalse.updateUserDocument(
                                      data: countData,
                                    );
                                  }
                                } else {
                                  provAppDataFalse.connectionCollections =
                                      collections;
                                }
                                return Consumer<List<PlantData>>(
                                  builder:
                                      (context, List<PlantData> plants, _) {
                                    if (plants != null) {
                                      if (connectionLibrary == false) {
                                        //save plants for use elsewhere
                                        provAppDataFalse.currentUserPlants =
                                            plants;
                                        //update tally in user document
                                        if (plants != null &&
                                            //there was an issue on sign out until I added
                                            //another Navigator.pop to close both layers
                                            provAppDataFalse.currentUserInfo !=
                                                null) {
                                          //*****UPDATE COUNTS*****//

                                          //update photo count
                                          int tally = 0;
                                          for (PlantData plant
                                              in provAppDataFalse
                                                  .currentUserPlants) {
                                            int photos = plant.imageSets.length;
                                            tally = tally + photos;
                                          }
                                          //filter out certain plants from count
                                          int plantCount = 0;
                                          for (CollectionData collection
                                              in collections) {
                                            if (!DBDefaultDocument
                                                .collectionNoCountPlants
                                                .contains(collection.id)) {
                                              plantCount = plantCount +
                                                  collection.plants.length;
                                            }
                                          }

                                          if (
                                              //don't bother updating if the values are the same
                                              plantCount !=
                                                  provAppDataFalse
                                                      .currentUserInfo.plants) {
                                            Map<String, dynamic> countData = {
                                              UserKeys.plants: plantCount
                                            };
                                            provCloudDBFalse.updateUserDocument(
                                              data: countData,
                                            );
                                          } else if (
                                              //don't bother updating if the values are the same
                                              tally !=
                                                  provAppDataFalse
                                                      .currentUserInfo.photos) {
                                            Map photoCountData =
                                                AppData.updatePairFull(
                                                    key: UserKeys.photos,
                                                    value: tally);
                                            provCloudDBFalse.updateUserDocument(
                                              data: photoCountData,
                                            );
                                          }
                                        }
                                      } else {
                                        //save plants for use elsewhere
                                        provAppDataFalse.connectionPlants =
                                            plants;
                                      }
                                      return Column(
                                        children: <Widget>[
                                          //show a title and way to build new shelves
                                          (showAddButton == true)
                                              ? ButtonAdd(
                                                  buttonText:
                                                      'Plant ${GlobalStrings.collections}'
                                                          .toUpperCase(),
                                                  onPress: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return DialogScreenInput(
                                                              title:
                                                                  'Build new ${GlobalStrings.collection}',
                                                              acceptText:
                                                                  'Create',
                                                              acceptOnPress:
                                                                  () {
                                                                //create a map from the data
                                                                CollectionData
                                                                    collection =
                                                                    provAppDataFalse
                                                                        .newCollection();
                                                                //upload new collection data
                                                                provCloudDBFalse.insertDocumentToCollection(
                                                                    data: collection
                                                                        .toMap(),
                                                                    collection:
                                                                        DBFolder
                                                                            .collections,
                                                                    documentName:
                                                                        collection
                                                                            .id);
                                                                //pop context
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              onChange:
                                                                  (input) {
                                                                provAppDataFalse
                                                                        .newDataInput =
                                                                    input;
                                                              },
                                                              cancelText:
                                                                  'Cancel',
                                                              hintText: null);
                                                        });
                                                  },
                                                )
                                              : SizedBox(),
                                          SizedBox(height: 1.0),
                                          UIBuilders.displayCollections(
                                              //sort personal and hide default shelves
                                              //based on Library owner preference
                                              user: user,
                                              connectionLibrary:
                                                  connectionLibrary,
                                              groupID: null,
                                              groupColor: null,
                                              userCollections:
                                                  connectionLibrary == false
                                                      ? provAppDataFalse
                                                          .currentUserCollections
                                                      : provAppDataFalse
                                                          .connectionCollections),
                                          //Add an InfoTip for Account
                                          (connectionLibrary == false &&
                                                  provAppDataFalse
                                                          .currentUserInfo
                                                          .collections ==
                                                      0)
                                              ? InfoTip(
                                                  onPress: () {},
                                                  showAlways: true,
                                                  text:
                                                      'Tap the bottom right icon and then the "Account" button to manage your settings.  '
                                                      'You can set/update information as well as change certain viewing preferences.  \n\n'
                                                      'Feel free to explore the "About" section for an overview of the app and lesser known capabilities.  \n\n'
//                                              'Your Library and Plants are visible to other plant lovers.'
                                                  )
                                              : SizedBox(),
                                          //Add an InfoTip for Shelf
                                          (connectionLibrary == false &&
                                                  provAppDataFalse
                                                          .currentUserInfo
                                                          .collections ==
                                                      0)
                                              ? InfoTip(
                                                  onPress: () {},
                                                  showAlways: true,
                                                  text:
                                                      'Your Library currently contains only default ${GlobalStrings.collections}.  '
                                                      'These show a star beside the name and have special properties.  \n\n'
                                                      'Tap the "+" next to Plant ${GlobalStrings.collections}" to build your first personal ${GlobalStrings.collection}.  \n\n'
                                                      'A Houseplants or Orchids ${GlobalStrings.collection} might be a good place to start!  \n\n'
//                                              'Your Library and Plants are visible to other plant lovers.'
                                                  )
                                              : SizedBox(),
                                        ],
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                }),
              ),
              SizedBox(height: 5.0),
            ],
          ),
        ),
        //only show the nav bar for user library not connection
        bottomBar: (showBottomNavBar == true)
            ? BottomBar(
                selectionNumber: 3,
              )
            : SizedBox(),
      ),
    );
  }
}
