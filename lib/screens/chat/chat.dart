import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/screens/chat/widgets/chat_avatar.dart';
import 'package:plant_collector/screens/chat/widgets/message_template.dart';
import 'package:plant_collector/screens/chat/widgets/send_message.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  final Map connectionMap;
  ChatScreen({@required this.connectionMap});
  @override
  Widget build(BuildContext context) {
    Provider.of<CloudDB>(context)
        .setCurrentChatId(connectionID: connectionMap[kUserID]);
    return ScreenTemplate(
      screenTitle: 'Chat',
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
//            StreamProvider<QuerySnapshot>.value(
//              value: Provider.of<CloudDB>(context).streamConnections(),
//              child:
            Container(
                padding: EdgeInsets.symmetric(
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  color: kGreenMedium,
                ),
                height:
                    AppTextSize.gigantic * MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ChatAvatar(
                      avatarLink: connectionMap[kUserAvatar],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      connectionMap[kUserName],
                      style: TextStyle(
                        fontSize: AppTextSize.huge *
                            MediaQuery.of(context).size.width,
                        fontWeight: AppTextWeight.medium,
                        color: AppTextColor.white,
                      ),
                    ),
                  ],
                )
//                Consumer<QuerySnapshot>(
//                  builder: (context, QuerySnapshot connectionsSnap, _) {
//                    List<Widget> connectionsList = [];
//                    if (connectionsSnap != null) {
//                      for (DocumentSnapshot snap in connectionsSnap.documents) {
//                        connectionsList.add(
//                          ChatAvatar(
//                            connectionId: snap.data[kUserID],
//                          ),
//                        );
//                      }
//                    }
//                    return Center(
//                      child: ListView(
//                        shrinkWrap: true,
//                        primary: false,
//                        scrollDirection: Axis.horizontal,
//                        children: connectionsList,
//                      ),
//                    );
//                  },
//                ),
                ),
//            ),
            Container(
              height: 1.0,
              width: double.infinity,
              color: kGreenDark,
            ),
            StreamProvider<QuerySnapshot>.value(
              value: Provider.of<CloudDB>(context).streamMessages(
                document: Provider.of<CloudDB>(context)
                    .conversationDocumentName(
                        connectionId: connectionMap[kUserID]),
              ),
              child: Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Consumer<QuerySnapshot>(
                    builder: (context, QuerySnapshot messages, _) {
                      List<Widget> messageList = [];
                      if (messages != null && messages.documents != null) {
                        for (DocumentSnapshot snap in messages.documents) {
                          Map messageMap = snap.data;
                          if (messageMap[kMessageSender] ==
                              Provider.of<CloudDB>(context)
                                  .getCurrentChatId()) {
                            messageList.add(
                              MessageTemplate(
                                message: messageMap,
                                alignment: MainAxisAlignment.start,
                                color: kGreenMedium,
                                textColor: AppTextColor.white,
                              ),
                            );
                          } else {
                            messageList.add(
                              MessageTemplate(
                                message: messageMap,
                                alignment: MainAxisAlignment.end,
                                color: AppTextColor.white,
                                textColor: AppTextColor.dark,
                              ),
                            );
                          }
                        }
                      }
                      return Center(
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          children: messageList,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 1.0,
              width: double.infinity,
              color: AppTextColor.light,
            ),
            Container(
              color: AppTextColor.white,
              constraints: BoxConstraints(
                minHeight:
                    4 * AppTextSize.medium * MediaQuery.of(context).size.width,
                maxHeight:
                    6 * AppTextSize.medium * MediaQuery.of(context).size.width,
              ),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: SendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
