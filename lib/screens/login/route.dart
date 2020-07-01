import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/user.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/screens/login/login.dart';
import 'package:plant_collector/screens/library/library.dart';

//routing screen
class RouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //check to see if the current user is still signed in
    return FutureBuilder<FirebaseUser>(
        future: Provider.of<UserAuth>(context).getCurrentUser(),
        builder: (context, snap) {
          if (snap != null) {
            FirebaseUser user = snap.data;
            if (user == null) {
              //if not signed in go to login
              return LoginScreen();
            }

            //otherwise save user data and head to main Library screen
            Provider.of<UserAuth>(context).signedInUser = user;
            return LibraryScreen(
              userID: user.uid,
              connectionLibrary: false,
            );
          } else {
            //loading indicator while waiting
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
