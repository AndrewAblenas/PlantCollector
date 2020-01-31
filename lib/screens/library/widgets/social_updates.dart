import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/friend_data.dart';
import 'package:plant_collector/models/data_types/message_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/chat/chat.dart';
import 'package:plant_collector/widgets/chat_avatar.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';

class SocialUpdates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContainerWrapper(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'connections');
            },
            child: SectionHeader(
              title: 'Friend Collections',
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          TileWhite(
            bottomPadding: 5.0,
            child: Consumer<List<FriendData>>(
              builder: (context, List<FriendData> friends, _) {
                if (friends != null) {
                  List<Widget> connectionList = [];
                  for (FriendData friend in friends) {
                    connectionList.add(
                      FutureProvider<Map>.value(
                        value: Provider.of<CloudDB>(context)
                            .getConnectionProfile(connectionID: friend.id),
                        child: Consumer<Map>(
                          builder: (context, Map connectionMap, _) {
                            if (connectionMap != null) {
                              UserData user =
                                  UserData.fromMap(map: connectionMap);
                              return Padding(
                                padding: EdgeInsets.all(5.0),
                                child: StreamProvider<QuerySnapshot>.value(
                                  value: Provider.of<CloudDB>(context)
                                      .streamConvoMessages(
                                    connectionID: user.id,
                                  ),
                                  child: Consumer<QuerySnapshot>(
                                    builder:
                                        (context, QuerySnapshot messages, _) {
                                      List<String> unreadList = [];
                                      if (messages != null &&
                                          messages.documents != null) {
                                        for (DocumentSnapshot message
                                            in messages.documents) {
                                          //make sure message isn't empty, is from friend, and hasn't been read
                                          if (message != null &&
                                              message.data[
                                                      MessageKeys.sender] !=
                                                  Provider.of<CloudDB>(context)
                                                      .currentUserFolder &&
                                              message.data[MessageKeys.read] ==
                                                  false) {
                                            unreadList
                                                .add(message.reference.path);
                                          }
                                        }
                                      }
                                      //TODO see local_notification for notes
                                      int unread = unreadList.length;
//                                        if (unread >= 1 &&
//                                            messages.documentChanges.length >=
//                                                1) {
//                                          String messagePlural = (unread == 1)
//                                              ? 'message'
//                                              : 'messages';
//                                          Notifications
//                                              .showOngoingNotificationSilent(
//                                                  notification:
//                                                      Provider.of<AppData>(
//                                                              context)
//                                                          .notifications,
//                                                  title: 'New Messages',
//                                                  body:
//                                                      '${user.name} sent you $unread new $messagePlural.');
//                                        }
                                      return GestureDetector(
                                        onTap: () {
                                          //on tap set unread messages as read
                                          if (unreadList.length >= 1) {
                                            for (String reference
                                                in unreadList) {
                                              CloudDB.readMessage(
                                                  reference: reference);
                                            }
                                          }
                                          //navigate to the chat page with the connection map
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ChatScreen(
                                                friend: user,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          fit: StackFit.loose,
                                          children: <Widget>[
                                            ChatAvatar(
                                              avatarLink: user.avatar,
                                            ),
                                            unread >= 1
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.all(2.0),
                                                    decoration: BoxDecoration(
                                                      color: kGreenDark,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(2.0),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      unread.toString(),
                                                      style: TextStyle(
                                                        fontSize:
                                                            AppTextSize.small *
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                        color:
                                                            AppTextColor.white,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ),
                    );
                  }
                  return GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: 5,
                    children: connectionList,
                    childAspectRatio: 1,
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
