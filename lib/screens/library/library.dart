import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/friend_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/request_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/library/widgets/social_updates.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/screens/library/widgets/profile_header.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/widgets/menu_item.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/formats/text.dart';
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
      Provider.of<CloudDB>(context).setConnectionFolder(connectionID: userID);
      Provider.of<CloudStore>(context)
          .setConnectionFolder(connectionID: userID);
      Provider.of<AppData>(context).showTips = false;
    }
    return MultiProvider(
      providers: [
        StreamProvider<List<RequestData>>.value(
          value: Provider.of<CloudDB>(context).streamRequestsData(),
        ),
        StreamProvider<List<FriendData>>.value(
          value: Provider.of<CloudDB>(context).streamFriendsData(),
        ),
        StreamProvider<UserData>.value(
          value: CloudDB.streamUserData(userID: userID),
        ),
        StreamProvider<List<GroupData>>.value(
          value: CloudDB.streamGroupsData(userID: userID),
        ),
        StreamProvider<List<CollectionData>>.value(
          value: CloudDB.streamCollectionsData(userID: userID),
        ),
        StreamProvider<List<PlantData>>.value(
          value: CloudDB.streamPlantsData(userID: userID),
        ),
      ],
      child: Scaffold(
        backgroundColor: kGreenLight,
        appBar: AppBar(
          backgroundColor: kGreenDark,
          centerTitle: true,
          elevation: 20.0,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Image(
                image: AssetImage('assets/images/app_icon_white_128.png'),
                height: 26.0,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                connectionLibrary == false
                    ? 'Collections'
                    : 'Connection Profile',
                style: kAppBarTitle,
              ),
              const SizedBox(
                width: 50.0,
              ),
            ],
          ),
          leading: connectionLibrary == false
              ? PopupMenuButton<Function>(
                  onSelected: (value) {
                    value();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: () {
                        Navigator.pushNamed(context, 'about');
                      },
                      child: MenuItem(
                        icon: Icons.info_outline,
                        label: 'About',
                      ),
                    ),
                    PopupMenuItem(
                      value: () {
                        Navigator.pushNamed(context, 'account');
                      },
                      child: MenuItem(
                        icon: Icons.account_box,
                        label: 'Account',
                      ),
                    ),
                    PopupMenuItem(
                      value: () {
                        Navigator.pushNamed(context, 'connections');
                      },
                      child: MenuItem(
                        icon: Icons.people,
                        label: 'Community',
                      ),
                    ),
                    PopupMenuItem(
                      value: () {
                        Navigator.pushNamed(context, 'feedback');
                      },
                      child: MenuItem(
                        icon: Icons.feedback,
                        label: 'Feedback',
                      ),
                    ),
//                PopupMenuItem(
//                  value: () {
//                    Navigator.pushNamed(context, 'settings');
//                  },
//                  child: MenuItem(
//                    icon: Icons.settings_applications,
//                    label: 'Settings',
//                  ),
//                ),
//                PopupMenuItem(
//                  value: () {
//                  },
//                  child: MenuItem(
//                    icon: Icons.cloud_upload,
//                    label: 'Update Collection from File',
//                  ),
//                ),
//                PopupMenuItem(
//                  value: () async {
//                  },
//                  child: MenuItem(
//                    icon: Icons.cloud_download,
//                    label: 'Download Collection File',
//                  ),
//                ),
                    PopupMenuItem(
                      value: () {
                        //TODO problem here related to sign out
                        Provider.of<UserAuth>(context).signOutUser();
                        Provider.of<UserAuth>(context).signedInUser = null;
                        Provider.of<AppData>(context).currentUserGroups = null;
                        Provider.of<AppData>(context).currentUserCollections =
                            null;
                        Provider.of<AppData>(context).currentUserPlants = null;
                        Navigator.pushNamed(context, 'login');
                      },
                      child: MenuItem(
                        icon: Icons.exit_to_app,
                        label: 'Sign Out',
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.list,
                    color: Colors.white,
                    size: 40.0,
                  ),
                )
              : null,
        ),
        body: Container(
          padding: EdgeInsets.only(
            top: 0.0,
            left: 0.01 * MediaQuery.of(context).size.width,
            right: 0.01 * MediaQuery.of(context).size.width,
            bottom: 0.0,
          ),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20.0),
              Container(
                constraints: BoxConstraints(
                    //this is a workaround to prevent listview jump when loading the contained streams
                    minHeight: 1.05 * MediaQuery.of(context).size.width),
                child: ProfileHeader(
                  connectionLibrary: connectionLibrary,
                ),
              ),
              connectionLibrary == false
                  ? Container(
                      constraints: BoxConstraints(
                          //this is a workaround to prevent listview jump when loading the contained streams
                          minHeight: 0.45 * MediaQuery.of(context).size.width),
                      child: SocialUpdates())
                  : SizedBox(),
              Consumer<List<GroupData>>(
                  builder: (context, List<GroupData> groups, _) {
                if (groups != null) {
                  if (connectionLibrary == false) {
                    //save for use anywhere
                    Provider.of<AppData>(context).currentUserGroups = groups;
                    //update tally in user document
                    if (groups != null &&
                        Provider.of<AppData>(context).currentUserInfo != null
                        //don't bother updating if the values are the same
                        &&
                        groups.length !=
                            Provider.of<AppData>(context)
                                .currentUserInfo
                                .groups) {
                      //update group count key value pair
                      Map countData = CloudDB.updatePairFull(
                          key: UserKeys.groups, value: groups.length);
                      //upload to DB
                      Provider.of<CloudDB>(context).updateUserDocument(
                        data: countData,
                      );
                    }
                  } else {
                    //save for use anywhere
                    Provider.of<AppData>(context).connectionGroups = groups;
                  }
                  return UIBuilders.displayGroups(
                      connectionLibrary: connectionLibrary,
                      userGroups: connectionLibrary == false
                          ? Provider.of<AppData>(context).currentUserGroups
                          : Provider.of<AppData>(context).connectionGroups);
                } else {
                  return SizedBox();
                }
              }),
              SizedBox(
                height: 15,
              ),
              connectionLibrary == false
                  ? ButtonAdd(
                      buttonText: 'Create New Group',
                      buttonColor: kGreenDark,
                      onPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DialogScreenInput(
                                  title: 'Create new Group',
                                  acceptText: 'Create',
                                  acceptOnPress: () {
                                    //create initial group map
                                    GroupData group =
                                        Provider.of<AppData>(context)
                                            .createGroup();
                                    //upload to groups
                                    Provider.of<CloudDB>(context)
                                        .insertDocumentToCollection(
                                            data: group.toMap(),
                                            collection: DBFolder.groups,
                                            documentName: group.id);
                                    //close the screen
                                    Navigator.pop(context);
                                  },
                                  onChange: (input) {
                                    Provider.of<AppData>(context).newDataInput =
                                        input;
                                  },
                                  cancelText: 'Cancel',
                                  hintText: null);
                            });
                      },
                    )
                  : SizedBox(),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
