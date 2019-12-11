import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/friend_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/screens/connections/widgets/connection_card.dart';
import 'package:plant_collector/screens/connections/widgets/request_card.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ConnectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      screenTitle: 'Connections',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            SizedBox(
              height: 10.0,
            ),
            StreamProvider<QuerySnapshot>.value(
              value: Provider.of<CloudDB>(context).streamRequests(),
              child: Consumer<QuerySnapshot>(
                builder: (context, QuerySnapshot requestSnap, _) {
                  if (requestSnap != null && requestSnap.documents.length > 0) {
                    List<Widget> requestList = [];
                    for (DocumentSnapshot request in requestSnap.documents) {
                      UserData req = UserData.fromMap(map: request.data);
                      requestList.add(
                        RequestCard(user: req),
                      );
                    }
                    return ContainerWrapper(
                      child: Column(
                        children: <Widget>[
                          SectionHeader(
                            title: 'Requests',
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: requestList,
                            childAspectRatio: 1.5,
                          )
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            StreamProvider<QuerySnapshot>.value(
              value: Provider.of<CloudDB>(context).streamConnections(),
              child: Consumer<QuerySnapshot>(
                builder: (context, QuerySnapshot connectionsSnap, _) {
                  if (connectionsSnap != null &&
                      connectionsSnap.documents != null) {
                    List<Widget> connectionList = [];
                    for (DocumentSnapshot connection
                        in connectionsSnap.documents) {
                      FriendData friend =
                          FriendData.fromMap(map: connection.data);
                      connectionList.add(
                        FutureProvider<Map>.value(
                          value: Provider.of<CloudDB>(context)
                              .getConnectionProfile(connectionID: friend.id),
                          child: Consumer<Map>(
                            builder: (context, Map connectionMap, _) {
                              if (connectionMap != null) {
                                UserData user =
                                    UserData.fromMap(map: connectionMap);
                                return ConnectionCard(user: user);
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                        ),
                      );
                    }
                    return ContainerWrapper(
                      child: Column(
                        children: <Widget>[
                          SectionHeader(
                            title: 'Connections',
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: connectionList,
                            childAspectRatio: 1.5,
                          ),
                          ButtonAdd(
                            buttonColor: kGreenDark,
                            buttonText: 'Add Friend',
                            onPress: () {
                              //determine if user data saved
                              bool userData = (Provider.of<AppData>(context)
                                      .currentUserInfo !=
                                  null);
                              //determine if user name set
                              bool userNameSet = (Provider.of<AppData>(context)
                                          .currentUserInfo
                                          .name !=
                                      null &&
                                  Provider.of<AppData>(context)
                                          .currentUserInfo
                                          .name !=
                                      '');
                              //first, direct user to create a user name
                              if (userData && !userNameSet) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DialogScreenInput(
                                          title:
                                              'Before adding a friend, first create your user name.',
                                          acceptText: 'Add',
                                          acceptOnPress: () {
                                            //update user document to add user name
                                            Provider.of<CloudDB>(context)
                                                .updateUserDocument(
                                              data: CloudDB.updatePairFull(
                                                  key: UserKeys.name,
                                                  value: Provider.of<AppData>(
                                                          context)
                                                      .newDataInput),
                                            );
                                            //pop the context
                                            Navigator.pop(context);
                                          },
                                          onChange: (input) {
                                            Provider.of<AppData>(context)
                                                .newDataInput = input;
                                          },
                                          cancelText: 'Cancel',
                                          hintText: null);
                                    });
                              }
                              //then direct the user to add friend
                              if (userData && userNameSet) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DialogScreenInput(
                                          title: 'Type your friend\'s email.',
                                          acceptText: 'Add',
                                          acceptOnPress: () async {
                                            //try to find if user is registered from email
                                            String friendID =
                                                await CloudDB.getUserFromEmail(
                                                    userEmail:
                                                        Provider.of<AppData>(
                                                                context)
                                                            .newDataInput);
                                            //look for ID in friend list
                                            bool friend = false;
                                            for (DocumentSnapshot connection
                                                in connectionsSnap.documents) {
                                              if (connection.data
                                                  .containsValue(friendID)) {
                                                friend = true;
                                              }
                                            }
                                            //check if user is inputted their own email
                                            bool sameEmail =
                                                (Provider.of<AppData>(context)
                                                        .newDataInput ==
                                                    Provider.of<UserAuth>(
                                                            context)
                                                        .signedInUser
                                                        .email);
                                            Navigator.pop(context);
                                            //determine dialog text
                                            String title;
                                            String dialogText;
                                            String buttonText = 'OK';
                                            Function onPressed = () {};
                                            if (sameEmail == true) {
                                              //so use can't send request to self
                                              title = 'Cannot Send';
                                              dialogText =
                                                  'It\'s great that you want to be friends with yourself!'
                                                  '\n\nUnfortunately you can\'t send yourself a request.';
                                            } else if (friend == true) {
                                              //so user can't send another request to same friend
                                              title = 'Cannot Send';
                                              dialogText =
                                                  'That must be one great friend!'
                                                  '\n\nYou\'re already connected so we won\'t send another request.';
                                            } else if (friendID != null) {
                                              //if all good send the request to friend
                                              Provider.of<CloudDB>(context)
                                                  .sendConnectionRequest(
                                                      connectionID: friendID);
                                              title = 'Request Sent';
                                              dialogText =
                                                  'A request has been sent.  You will be able to share collections once it is accepted.';
                                            } else {
                                              //if all else fails, send an invite via share
                                              title = 'Send Invite?';
                                              dialogText =
                                                  'No user was found with this email address.  Would you like to invite them?';
                                              buttonText = 'Invite';
                                              onPressed = () {
                                                Share.share(
                                                    //TODO when ready link to download app
                                                    'I\'m using Plant Collector to keep a record of my plants and share my collection with friends.'
                                                    '\n\n Check it out here: <future download link>');
                                              };
                                            }
                                            //show a dialog to provide feedback
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return DialogConfirm(
                                                  hideCancel: true,
                                                  title: title,
                                                  text: dialogText,
                                                  buttonText: buttonText,
                                                  onPressed: () {
                                                    onPressed();
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          onChange: (input) {
                                            Provider.of<AppData>(context)
                                                .newDataInput = input;
                                          },
                                          cancelText: 'Cancel',
                                          hintText: null);
                                    });
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
