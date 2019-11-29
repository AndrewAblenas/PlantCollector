import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/classes.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/screens/library/widgets/profile_header.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/widgets/dialogs/dialog_input.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/widgets/menu_item.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      Provider.of<CloudDB>(context).setUserFolder(userID: userID);
      Provider.of<CloudStore>(context).setUserFolder(userID: userID);
    } else {
      Provider.of<CloudDB>(context).setConnectionFolder(connectionID: userID);
      Provider.of<CloudStore>(context)
          .setConnectionFolder(connectionID: userID);
    }
    return Scaffold(
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
              connectionLibrary == false ? 'Collections' : 'Connection Profile',
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
                      label: 'Connections',
                    ),
                  ),
//                PopupMenuItem(
//                  //TODO settings page
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
//                    //TODO not implemented yet
//                  },
//                  child: MenuItem(
//                    icon: Icons.cloud_upload,
//                    label: 'Update Collection from File',
//                  ),
//                ),
//                PopupMenuItem(
//                  value: () async {
//                    //TODO not implemented yet?
//                  },
//                  child: MenuItem(
//                    icon: Icons.cloud_download,
//                    label: 'Download Collection File',
//                  ),
//                ),
                  PopupMenuItem(
                    value: () {
                      Provider.of<UserAuth>(context).signOutUser();
                      Provider.of<UserAuth>(context).signedInUser = null;
                      Provider.of<CloudDB>(context).currentUserGroups = null;
                      Provider.of<CloudDB>(context).currentUserCollections =
                          null;
                      Provider.of<CloudDB>(context).currentUserPlants = null;
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
      body: StreamProvider<QuerySnapshot>.value(
        value: Provider.of<CloudDB>(context).streamGroups(userID: userID),
        child: Padding(
          padding: EdgeInsets.only(
            top: 0.0,
            left: 10.0,
            right: 10.0,
            bottom: 0.0,
          ),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20.0),
              StreamProvider<DocumentSnapshot>.value(
                value: Provider.of<CloudDB>(context)
                    .streamUserDocument(userID: userID),
                child: ProfileHeader(
                  connectionLibrary: connectionLibrary,
                ),
              ),
              Consumer<QuerySnapshot>(
                  builder: (context, QuerySnapshot groupSnap, _) {
                if (groupSnap != null) {
                  if (connectionLibrary == false) {
                    //save for use anywhere
                    Provider.of<CloudDB>(context).currentUserGroups = groupSnap
                        .documents
                        .map((doc) => groupMapFromSnapshot(groupMap: doc.data))
                        .toList();
                    //update tally in user document
                    if (groupSnap.documents != null &&
                        Provider.of<UserAuth>(context).getCurrentUser() !=
                            null) {
                      Map countData = Provider.of<CloudDB>(context)
                          .updatePairFull(
                              key: kUserTotalGroups,
                              value: groupSnap.documents.length);
                      Provider.of<CloudDB>(context).updateUserDocument(
                          data: countData,
                          userID:
                              Provider.of<CloudDB>(context).currentUserFolder);
                    }
                  } else {
                    //save for use anywhere
                    Provider.of<CloudDB>(context).connectionGroups = groupSnap
                        .documents
                        .map((doc) => groupMapFromSnapshot(groupMap: doc.data))
                        .toList();
                  }
                  return StreamProvider<QuerySnapshot>.value(
                    value: Provider.of<CloudDB>(context)
                        .streamCollections(userID: userID),
                    child: Provider.of<UIBuilders>(context).displayGroups(
                        connectionLibrary: connectionLibrary,
                        userGroups: connectionLibrary == false
                            ? Provider.of<CloudDB>(context).currentUserGroups
                            : Provider.of<CloudDB>(context).connectionGroups),
                  );
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
                      dialog: DialogInput(
                        title: 'Create Group',
                        text: 'Please provide a new Group name.',
                        onPressedSubmit: () {
                          Map data = Provider.of<AppData>(context)
                              .groupNewDB()
                              .toMap();
                          Provider.of<CloudDB>(context)
                              .insertDocumentToCollection(
                                  data: data,
                                  collection: '$kUserGroups',
                                  documentName: data[kGroupID]);
                          Navigator.pop(context);
                        },
                        onChangeInput: (input) {
                          Provider.of<AppData>(context).newDataInput = input;
                        },
                        onPressedCancel: () {
                          Provider.of<AppData>(context).newDataInput = null;
                          Navigator.pop(context);
                        },
                      ),
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
