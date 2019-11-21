import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/user.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/screens/login/login.dart';
import 'package:plant_collector/screens/library/library.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';

class RouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
        future: Provider.of<UserAuth>(context).getCurrentUser(),
        builder: (context, snap) {
          if (snap != null) {
            FirebaseUser user = snap.data;
            if (user == null) {
              print('login');
              return LoginScreen();
            }
            //TODO many different classes depend on the userID, is there a better way to set?
            Provider.of<UserAuth>(context).signedInUser = user;
            Provider.of<AppData>(context).setUserID(userIDString: user.uid);
            Provider.of<CloudDB>(context).setUserID(uid: user.uid);
            Provider.of<CloudStore>(context).setUserFolderID(user.uid);
            //set up the group stream so it's ready for the library page
            return StreamProvider<QuerySnapshot>.value(
                value: Provider.of<CloudDB>(context).streamGroups(),
                child: LibraryScreen());
          } else {
            return Scaffold(
              backgroundColor: kGreenLight,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
