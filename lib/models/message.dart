import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/message_data.dart';
import 'package:plant_collector/screens/chat/widgets/message_types/message_photo.dart';
import 'package:plant_collector/screens/chat/widgets/message_types/message_plant.dart';
import 'package:plant_collector/screens/chat/widgets/message_types/message_sticker.dart';
import 'package:plant_collector/screens/chat/widgets/message_types/message_text.dart';
import 'package:plant_collector/screens/chat/widgets/message_types/message_url.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//*****************CHAT AND MESSAGE RELATED*****************//

class Message extends ChangeNotifierProvider {
  //Check type and create appropriate message bubble contents
  static Widget messageTypeRouting(
      {@required MessageData message,
      @required Color textColor,
      @required bool connectionLibrary,
      @required MainAxisAlignment alignment}) {
//    TextAlign textAlignment = (alignment == MainAxisAlignment.start)
//        ? TextAlign.start
//        : TextAlign.end;
    //default to text if media is blank
    if (message.type == MessageKeys.typeText || message.media == '') {
      return MessageText(
          message: message, textColor: textColor, alignment: TextAlign.start);
    } else if (message.type == MessageKeys.typeUrl) {
      return MessageUrl(
          message: message, textColor: textColor, alignment: TextAlign.start);
    } else if (message.type == MessageKeys.typePhoto) {
      return MessagePhoto(message: message);
    } else if (message.type == MessageKeys.typeSticker) {
      return MessageSticker(message: message);
    } else if (message.type == MessageKeys.typePlant) {
      return MessagePlant(
        connectionLibrary: connectionLibrary,
        message: message,
        textColor: textColor,
      );
    } else {
      return MessageText(
          message: message, textColor: textColor, alignment: TextAlign.start);
    }
  }

  //Search through string for link
  static List<Widget> findLinks(
      {@required String text,
      @required TextStyle textStyle,
      @required TextStyle urlStyle}) {
    //TODO better split pattern
//    text.split(new RegExp(r"http[^\s]\s"));
    List<String> splitList = text.split(' ');
    List<Widget> widgetList = [];
    if (text != null && (text.contains('http:') || text.contains('https:'))) {
      for (String item in splitList) {
        if (item.contains('http:') || item.contains('https:')) {
          widgetList.add(
            FlatButton(
              onPressed: () {
                launchURL(url: item);
              },
              child: Text(
                item + (item != splitList.last ? ' ' : ''),
                style: urlStyle,
              ),
            ),
          );
        } else {
          widgetList.add(
            Text(
              item + (item != splitList.last ? ' ' : ''),
              style: textStyle,
            ),
          );
        }
      }
      return widgetList;
    } else {
      return [
        Text(
          text,
          style: textStyle,
        ),
      ];
    }
  }

//Launch url
  static launchURL({@required String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  //SECTION END
}
