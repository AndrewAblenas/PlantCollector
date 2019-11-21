import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/classes.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/screens/library/widgets/stat_card_row.dart';
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
  LibraryScreen({this.userID});
  @override
  Widget build(BuildContext context) {
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
              image: AssetImage('assets/images/logo_128.png'),
              height: 26.0,
            ),
            const SizedBox(
              width: 5.0,
            ),
            const Text(
              'Collections',
              style: kAppBarTitle,
            ),
            const SizedBox(
              width: 50.0,
            ),
          ],
        ),
        leading: PopupMenuButton<Function>(
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
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 0.0,
          left: 10.0,
          right: 10.0,
          bottom: 0.0,
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20.0),
            FutureBuilder(
              //this is to prevent the cards from showing 0 and not updating on app start
              future: Provider.of<UIBuilders>(context).statCardDelay(),
              builder: (context, snap) {
                if (snap.data == null) {
                  return StatCardRow();
                }
                return StatCardRow();
              },
            ),
            Consumer<QuerySnapshot>(
                builder: (context, QuerySnapshot groupSnap, _) {
              if (groupSnap != null) {
                //save for use anywhere
                Provider.of<CloudDB>(context).groups = groupSnap.documents
                    .map((doc) => groupMapFromSnapshot(groupMap: doc.data))
                    .toList();
                return StreamProvider<QuerySnapshot>.value(
                  value: Provider.of<CloudDB>(context).streamCollections(),
                  child: Provider.of<UIBuilders>(context).displayGroups(
                      userGroups: Provider.of<CloudDB>(context).groups),
                );
              } else {
                return SizedBox();
              }
            }),
            SizedBox(
              height: 15,
            ),
            ButtonAdd(
              buttonText: 'Create New Group',
              buttonColor: kGreenDark,
              dialog: DialogInput(
                title: 'Create Group',
                text: 'Please provide a new Group name.',
                onPressedSubmit: () {
                  Map data = Provider.of<AppData>(context).groupNewDB().toMap();
                  Provider.of<CloudDB>(context).insertDocumentToCollection(
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
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
