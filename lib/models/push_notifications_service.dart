import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:plant_collector/formats/tab_transitions.dart';
import 'package:plant_collector/screens/discover/discover.dart';
import 'package:plant_collector/screens/friends/friends.dart';

class PushNotificationService extends ChangeNotifier {
  //initialize messaging
  final FirebaseMessaging _fcm = FirebaseMessaging();

  //navigate to desired page
  static void navigateToPushedScreen(
      {@required Map<String, dynamic> message, BuildContext context}) {
    //get the page route
    String reference = message['data']['screen'];

    if (reference != null) {
      //just set this as the default most updates are here
      Widget screen = FriendsScreen();
      if (reference == 'FriendsScreen') {
        screen = FriendsScreen();
      } else if (reference == 'DiscoverScreen') {
        screen = DiscoverScreen();
      }
      Route route = transitionNone(nextPage: screen);

      //clear dialogs
      Navigator.popUntil(
          context, (Route<dynamic> appRoute) => appRoute is PageRoute);

      //check to see if current
      if (!route.isCurrent) {
        Navigator.of(context).push(route);
      }
    }
  }

  Future initialize({@required BuildContext context}) async {
    if (Platform.isIOS) {
      //request permission for iOS
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    //now configure
    _fcm.configure(
        //called when app is running in the foreground and push notification is received
        onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
//      navigateToPushedScreen(message: message, context: context);
    },
        //called when app is closed and is opened via a push notification is received
        onLaunch: (Map<String, dynamic> message) async {
      print('onMessage: $message');
//      navigateToPushedScreen(message: message, context: context);
    },
        //called when app is sleeping and is opened via a push notification is received
        onResume: (Map<String, dynamic> message) async {
      print('onMessage: $message');
//      navigateToPushedScreen(message: message, context: context);
    });
  }

  Future<String> getDevicePushToken() async {
    return _fcm.getToken();
  }
}
