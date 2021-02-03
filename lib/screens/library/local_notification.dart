import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/screens/library/library.dart';
import 'package:provider/provider.dart';

class LocalNotificationWrapper extends StatefulWidget {
  final Widget child;
  final String userId;
  LocalNotificationWrapper({
    @required this.child,
    @required this.userId,
  });
  @override
  _LocalNotificationWrapperState createState() =>
      _LocalNotificationWrapperState();
}

class _LocalNotificationWrapperState extends State<LocalNotificationWrapper> {
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    final settingsAndroid = new AndroidInitializationSettings('app_icon');
    final settingIOS = new IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) =>
          onSelectNotification(payload),
    );
    final initializationSettings =
        new InitializationSettings(android: settingsAndroid, iOS: settingIOS);

    notifications.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  //TODO send to chat screen
  //TODO messages currently only notify if the app is open, clicking doesn't always navigate...
  //What happens when a notification is selected
  Future onSelectNotification(String payload) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LibraryScreen(
          userID: widget.userId,
          connectionLibrary: false,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    Provider.of<AppData>(context, listen: false).notifications = notifications;
    return widget.child;
  }
}
