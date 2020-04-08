import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/communication_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/library/widgets/announcements.dart';
import 'package:plant_collector/screens/library/widgets/communications.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/screens/library/widgets/profile_header.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
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
  LibraryScreen({@required this.userID, @required this.connectionLibrary});
  @override
  Widget build(BuildContext context) {
    if (connectionLibrary == false) {
      //make current user ID available to CloudDB and CloudStore instances
      Provider.of<CloudDB>(context).setUserFolder(userID: userID);
      Provider.of<CloudStore>(context).setUserFolder(userID: userID);
      Provider.of<AppData>(context).showTipsHelpers();
    } else {
      //make friend ID available to CloudDB and CloudStore instances to display friend library
//      Provider.of<CloudDB>(context).setConnectionFolder(connectionID: userID);
      Provider.of<CloudStore>(context)
          .setConnectionFolder(connectionID: userID);
      Provider.of<AppData>(context).showTips = false;
    }
    //*****SET WIDGET VISIBILITY START*****//

    //title text and spacing
    String screenTitle = (connectionLibrary == false)
        ? 'My ${GlobalStrings.library}'
        : '${GlobalStrings.friend} ${GlobalStrings.library}';
//    double screenTitleSizedBoxWidth = (connectionLibrary == false) ? 0.0 : 50.0;

    //show admin messages/announcements only if library belongs to the current user
    bool showMessagesAnnouncements = (connectionLibrary == false &&
        Provider.of<UserAuth>(context).signedInUser != null);

    //show add shelf only if library belongs to the current user
    bool showAddButton = (connectionLibrary == false);

    //show add shelf only if library belongs to the current user
    bool showBottomNavBar = (connectionLibrary == false);

    //do not show title back button if library belongs to the current user
    bool showTitleBackButton = (connectionLibrary == true);

    //*****SET WIDGET VISIBILITY END*****//

    return MultiProvider(
      providers: [
//        StreamProvider<List<RequestData>>.value(
//          value: Provider.of<CloudDB>(context).streamRequestsData(),
//        ),
//        StreamProvider<List<FriendData>>.value(
//          value: Provider.of<CloudDB>(context).streamFriendsData(),
//        ),
        StreamProvider<UserData>.value(
          value: CloudDB.streamUserData(userID: userID),
        ),
//        StreamProvider<List<GroupData>>.value(
//          value: CloudDB.streamGroupsData(userID: userID),
//        ),
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
        body: Container(
//          decoration: BoxDecoration(
//            gradient: kBackgroundGradientBlues,
//          ),
          padding: EdgeInsets.only(
            top: 0.0,
            left: 0.01 * MediaQuery.of(context).size.width,
            right: 0.01 * MediaQuery.of(context).size.width,
            bottom: 0.0,
          ),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10.0),
              //show direct user messages and announcements on user library only
              (showMessagesAnnouncements == true)
                  ? Column(
                      children: <Widget>[
                        StreamProvider<List<CommunicationData>>.value(
                          value:
                              Provider.of<CloudDB>(context).streamAdminToUser(),
                          child: Communications(
                            title: 'Account',
                            color: Colors.yellowAccent,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        FutureProvider<List<CommunicationData>>.value(
                          value: Provider.of<CloudDB>(context)
                              .streamAnnouncements(),
                          child: Announcements(
                            title: 'Announcements',
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: 10.0),
              Container(
                constraints: BoxConstraints(
                    //this is a workaround to prevent listview jump when loading the contained streams
                    minHeight: 1.05 * MediaQuery.of(context).size.width),
                child: Consumer<UserData>(builder: (context, user, _) {
                  if (user != null) {
                    //there was an issue where only currentUserInfo existed
                    //this meant it the file was saved over when visiting a connection library!
                    connectionLibrary == false
                        ? Provider.of<AppData>(context).currentUserInfo = user
                        : Provider.of<AppData>(context).connectionUserInfo =
                            user;
                    return ProfileHeader(
                      connectionLibrary: connectionLibrary,
                      user: user,
                    );
                  } else {
                    return SizedBox();
                  }
                }),
              ),
              ContainerWrapper(
                turnOffShadow: true,
                child: Column(
                  children: <Widget>[
                    Consumer<List<CollectionData>>(
                      builder: (context, List<CollectionData> collections, _) {
                        if (collections == null) return Column();
                        if (connectionLibrary == false) {
                          Provider.of<AppData>(context).currentUserCollections =
                              collections;
                          //initialize
                          int filterTally = 0;
                          //exclude any any auto-generated
                          for (CollectionData collection
                              in Provider.of<AppData>(context)
                                  .currentUserCollections) {
                            if (!DBDefaultDocument.collectionExclude
                                .contains(collection.id)) {
                              filterTally++;
                            }
                          }
                          //update tally in user document
                          if (Provider.of<AppData>(context)
                                      .currentUserCollections !=
                                  null &&
                              Provider.of<AppData>(context).currentUserInfo !=
                                  null
                              //don't bother updating if the values are the same
                              &&
                              filterTally !=
                                  Provider.of<AppData>(context)
                                      .currentUserInfo
                                      .collections) {
                            Map countData = CloudDB.updatePairFull(
                                key: UserKeys.collections, value: filterTally);
                            Provider.of<CloudDB>(context).updateUserDocument(
                              data: countData,
                            );
                          }
                        } else {
                          Provider.of<AppData>(context).connectionCollections =
                              collections;
                        }
                        return Consumer<List<PlantData>>(
                          builder: (context, List<PlantData> plants, _) {
                            if (plants != null) {
                              if (connectionLibrary == false) {
                                //save plants for use elsewhere
                                Provider.of<AppData>(context)
                                    .currentUserPlants = plants;
                                //update tally in user document
                                if (plants != null &&
                                    //there was an issue on sign out until I added
                                    //another Navigator.pop to close both layers
                                    Provider.of<AppData>(context)
                                            .currentUserInfo !=
                                        null) {
                                  //update photo count
                                  int tally = 0;
                                  for (PlantData plant
                                      in Provider.of<AppData>(context)
                                          .currentUserPlants) {
                                    int photos = plant.images.length;
                                    tally = tally + photos;
                                  }

                                  if (
                                      //don't bother updating if the values are the same
                                      Provider.of<AppData>(context)
                                              .currentUserPlants
                                              .length !=
                                          Provider.of<AppData>(context)
                                              .currentUserInfo
                                              .plants) {
                                    Map countData = CloudDB.updatePairFull(
                                        key: UserKeys.plants,
                                        value: Provider.of<AppData>(context)
                                            .currentUserPlants
                                            .length);
                                    Provider.of<CloudDB>(context)
                                        .updateUserDocument(
                                      data: countData,
                                    );
                                  } else if (
                                      //don't bother updating if the values are the same
                                      tally !=
                                          Provider.of<AppData>(context)
                                              .currentUserInfo
                                              .photos) {
                                    Map photoCountData = CloudDB.updatePairFull(
                                        key: UserKeys.photos, value: tally);
                                    Provider.of<CloudDB>(context)
                                        .updateUserDocument(
                                      data: photoCountData,
                                    );
                                  }
                                }
                              } else {
                                //save plants for use elsewhere
                                Provider.of<AppData>(context).connectionPlants =
                                    plants;
                              }
                              return UIBuilders.displayCollections(
                                  //sort personal and community based on current user preference
                                  sortAlphabetically:
                                      Provider.of<AppData>(context)
                                          .currentUserInfo
                                          .sortAlphabetically,
                                  connectionLibrary: connectionLibrary,
                                  groupID: null,
                                  groupColor: null,
                                  userCollections: connectionLibrary == false
                                      ? Provider.of<AppData>(context)
                                          .currentUserCollections
                                      : Provider.of<AppData>(context)
                                          .connectionCollections);
                            } else {
                              return SizedBox();
                            }
                          },
                        );
                      },
                    ),
                    (showAddButton == true)
                        ? ButtonAdd(
                            buttonText: 'Build New ${GlobalStrings.collection}',
                            onPress: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DialogScreenInput(
                                        title:
                                            'Build new ${GlobalStrings.collection}',
                                        acceptText: 'Create',
                                        acceptOnPress: () {
                                          //create a map from the data
                                          CollectionData collection =
                                              Provider.of<AppData>(context)
                                                  .newCollection();
                                          //upload new collection data
                                          Provider.of<CloudDB>(context)
                                              .insertDocumentToCollection(
                                                  data: collection.toMap(),
                                                  collection:
                                                      DBFolder.collections,
                                                  documentName: collection.id);
                                          //pop context
                                          Navigator.pop(context);
                                        },
                                        onChange: (input) {
                                          Provider.of<AppData>(context)
                                              .newDataInput = input;
                                        },
                                        cancelText: 'Cancel',
                                        hintText: null);
                                  });
                            },
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(height: 10.0),
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
