import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:provider/provider.dart';

class Notifications extends ChangeNotifierProvider {
  //ongoing silent method to show notifications
  static Future showOngoingNotificationSilent(
      {@required FlutterLocalNotificationsPlugin notification,
      @required String title,
      @required String body,
      int id = 0}) async {
    //display the notification
    _showNotificationSilent(
        notification: notification,
        title: title,
        body: body,
        type: _ongoingSilent);
  }

  //show notifications
  static Future _showNotificationSilent({
    @required FlutterLocalNotificationsPlugin notification,
    @required String title,
    @required String body,
    @required NotificationDetails type,
    int id = 0,
  }) async {
    //display the notification
    await notification.show(
      id,
      title,
      body,
      type,
//      payload: 'Default_Sound',
    );
  }

  //platform specific behaviour of notifications
  static NotificationDetails get _ongoingSilent {
    //platform specific information
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: false,
      autoCancel: true,
      playSound: false,
      onlyAlertOnce: true,
      color: kGreenDark,
    );
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    return NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  }

  //SECTION END
}
