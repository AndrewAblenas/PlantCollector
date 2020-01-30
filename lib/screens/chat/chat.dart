import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/message_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/message.dart';
import 'package:plant_collector/widgets/chat_avatar.dart';
import 'package:plant_collector/screens/chat/widgets/message_types/message_template.dart';
import 'package:plant_collector/screens/chat/widgets/compose_message.dart';
import 'package:plant_collector/screens/library/library.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  final UserData friend;
  ChatScreen({@required this.friend});
  @override
  Widget build(BuildContext context) {
    Provider.of<AppData>(context).setCurrentChatId(connectionID: friend.id);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
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
                    Container(
                      width: 50.0,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 30.0,
                          color: AppTextColor.white,
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => LibraryScreen(
                              userID: friend.id,
                              connectionLibrary: true,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 50.0 *
                            MediaQuery.of(context).size.width *
                            kScaleFactor,
                        width: 50.0 *
                            MediaQuery.of(context).size.width *
                            kScaleFactor,
                        child: ChatAvatar(
                          avatarLink: friend.avatar,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    friend.name != null
                        ? Text(
                            friend.name,
                            style: TextStyle(
                              fontSize: AppTextSize.huge *
                                  MediaQuery.of(context).size.width,
                              fontWeight: AppTextWeight.medium,
                              color: AppTextColor.white,
                            ),
                          )
                        : SizedBox(),
                    Expanded(child: SizedBox()),
                    SizedBox(
                      width: 70.0,
                    ),
                  ],
                ),
              ),
//            ),
              Container(
                height: 1.0,
                width: double.infinity,
                color: kGreenDark,
              ),
              StreamProvider<QuerySnapshot>.value(
                value: Provider.of<CloudDB>(context).streamConvoMessages(
                  connectionID: friend.id,
                ),
                child: Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kGreenDark, kGreenLight],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Consumer<QuerySnapshot>(
                      builder: (context, QuerySnapshot messages, _) {
                        List<Widget> messageList = [];
                        List<String> unreadList = [];
                        if (messages != null && messages.documents != null) {
                          for (DocumentSnapshot snap in messages.documents) {
                            MessageData message =
                                MessageData.fromMap(map: snap.data);
                            //message from other user
                            if (message.sender ==
                                Provider.of<AppData>(context)
                                    .getCurrentChatId()) {
                              messageList.add(
                                MessageTemplate(
                                  alignment: MainAxisAlignment.start,
                                  color: kGreenMedium,
                                  content: Message.messageTypeRouting(
                                    //prevent other user edits
                                    connectionLibrary: true,
                                    message: message,
                                    textColor: AppTextColor.white,
                                    alignment: MainAxisAlignment.start,
                                  ),
                                ),
                              );
                              //add to list of unread if false
                              if (message.read == false) {
                                unreadList.add(snap.reference.path);
                              }
                              //message from current user
                            } else {
                              messageList.add(
                                MessageTemplate(
                                  alignment: MainAxisAlignment.end,
                                  color: AppTextColor.white,
                                  content: Message.messageTypeRouting(
                                    //prevent current user edits so view is consistent
                                    connectionLibrary: true,
                                    message: message,
                                    textColor: AppTextColor.dark,
                                    alignment: MainAxisAlignment.end,
                                  ),
                                ),
                              );
                            }
                          }
                        }
                        if (unreadList.length >= 1) {
                          for (String reference in unreadList) {
                            CloudDB.readMessage(reference: reference);
                          }
                        }
                        return ListView(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          children: messageList,
                          reverse: true,
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
                  minHeight: 3.5 *
                      AppTextSize.medium *
                      MediaQuery.of(context).size.width,
                  maxHeight: 6.0 *
                      AppTextSize.medium *
                      MediaQuery.of(context).size.width,
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
                  child: ComposeMessage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
