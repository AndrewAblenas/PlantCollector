import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/friend_data.dart';
import 'package:plant_collector/models/data_types/request_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/screens/friends/widgets/connection_card.dart';
import 'package:plant_collector/screens/friends/widgets/request_card.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/friends/widgets/social_updates.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/info_tip.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      screenTitle: GlobalStrings.friends,
      bottomBar: BottomBar(selectionNumber: 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            SizedBox(
              height: 10.0,
            ),
            StreamProvider<List<RequestData>>.value(
              value: Provider.of<CloudDB>(context).streamRequestsData(),
              child: Consumer<List<RequestData>>(
                builder: (context, List<RequestData> list, _) {
                  if (list != null && list.length >= 1) {
                    List<Widget> requestList = [];
                    for (RequestData request in list) {
                      List blocked =
                          (Provider.of<AppData>(context).currentUserInfo !=
                                  null)
                              ? Provider.of<AppData>(context)
                                  .currentUserInfo
                                  .blocked
                              : [];
                      UserData user = UserData.fromMap(map: request.toMap());
                      //only add card if not blocked
                      if (!blocked.contains(user.id))
                        requestList.add(
                          RequestCard(user: user),
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
                            primary: false,
                            crossAxisCount: 1,
                            children: requestList,
                            childAspectRatio: 5,
                          ),
                          SizedBox(
                            height: 5.0,
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
            StreamProvider<List<FriendData>>.value(
              value: Provider.of<CloudDB>(context).streamFriendsData(),
              child: Consumer<List<FriendData>>(
                builder: (context, List<FriendData> friends, _) {
                  if (friends != null) {
                    return FutureProvider<List<UserData>>.value(
                      value: Provider.of<CloudDB>(context)
                          .futureUsersData(friendList: friends),
                      child: Consumer<List<UserData>>(
                          builder: (context, List<UserData> users, _) {
                        if (users != null) {
                          List<Widget> connectionsCards = [];
                          for (UserData user in users) {
                            //create a list of connection cards
                            connectionsCards.add(
                              ConnectionCard(
                                user: user,
                                isRequest: false,
                              ),
                            );
                          }
                          return Column(
                            children: <Widget>[
                              Container(
                                constraints: BoxConstraints(
                                    //this is a workaround to prevent listview jump when loading the contained streams
                                    minHeight: 0.45 *
                                        MediaQuery.of(context).size.width),
                                child: SocialUpdates(),
                              ),
                              ContainerWrapper(
                                child: Column(
                                  children: <Widget>[
                                    SectionHeader(
                                      title: 'Connections',
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    ButtonAdd(
                                      buttonColor: kGreenDark,
                                      textColor: AppTextColor.white,
                                      icon: Icons.person_add,
                                      buttonText: 'Add Friend',
                                      onPress: () {
                                        //determine if user data saved
                                        bool userData =
                                            (Provider.of<AppData>(context)
                                                    .currentUserInfo !=
                                                null);
                                        //determine if user name set
                                        bool userNameSet =
                                            (Provider.of<AppData>(context)
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
                                                      Provider.of<CloudDB>(
                                                              context)
                                                          .updateUserDocument(
                                                        data: CloudDB.updatePairFull(
                                                            key: UserKeys.name,
                                                            value: Provider.of<
                                                                        AppData>(
                                                                    context)
                                                                .newDataInput),
                                                      );
                                                      //pop the context
                                                      Navigator.pop(context);
                                                    },
                                                    onChange: (input) {
                                                      Provider.of<AppData>(
                                                              context)
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
                                                    title:
                                                        'Type your friend\'s email.',
                                                    acceptText: 'Add',
                                                    acceptOnPress: () async {
                                                      //try to find if user is registered from email
                                                      String friendID = await CloudDB
                                                          .getUserFromEmail(
                                                              userEmail: Provider
                                                                      .of<AppData>(
                                                                          context)
                                                                  .newDataInput);
                                                      //look for ID in friend list
                                                      bool check = false;
                                                      for (FriendData friend
                                                          in friends) {
                                                        if (friend.id ==
                                                            friendID) {
                                                          check = true;
                                                        }
                                                      }
                                                      //check if user is inputted their own email
                                                      bool sameEmail = (Provider
                                                                  .of<AppData>(
                                                                      context)
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
                                                      Function onPressed =
                                                          () {};
                                                      if (sameEmail == true) {
                                                        //so use can't send request to self
                                                        title = 'Cannot Send';
                                                        dialogText =
                                                            'It\'s great that you want to be friends with yourself!'
                                                            '\n\nUnfortunately you can\'t send yourself a request.';
                                                      } else if (check ==
                                                          true) {
                                                        //so user can't send another request to same friend
                                                        title = 'Cannot Send';
                                                        dialogText =
                                                            'That must be one great friend!'
                                                            '\n\nYou\'re already connected so we won\'t send another request.';
                                                      } else if (friendID !=
                                                          null) {
                                                        //if all good send the request to friend
                                                        Provider.of<CloudDB>(
                                                                context)
                                                            .sendConnectionRequest(
                                                                connectionID:
                                                                    friendID);
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
                                                        builder: (BuildContext
                                                            context) {
                                                          return DialogConfirm(
                                                            hideCancel: true,
                                                            title: title,
                                                            text: dialogText,
                                                            buttonText:
                                                                buttonText,
                                                            onPressed: () {
                                                              onPressed();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    onChange: (input) {
                                                      Provider.of<AppData>(
                                                              context)
                                                          .newDataInput = input;
                                                    },
                                                    cancelText: 'Cancel',
                                                    hintText: null);
                                              });
                                        }
                                      },
                                    ),
                                    //check to see if the user has any friends yet
                                    friends.length >= 1
                                        ? GridView.count(
                                            shrinkWrap: true,
                                            primary: false,
                                            crossAxisCount: 1,
                                            children: connectionsCards,
                                            childAspectRatio: 5,
                                          )
                                        : InfoTip(
                                            text:
                                                'You currently have no connections.  Add some above.',
                                          ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 0.2 * MediaQuery.of(context).size.width,
                              ),
                              Container(
//                                  padding: EdgeInsets.symmetric(
//                                      horizontal: 0.15 *
//                                          MediaQuery.of(context).size.width),
                                  width:
                                      0.5 * MediaQuery.of(context).size.width,
                                  height:
                                      0.5 * MediaQuery.of(context).size.width,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 0.05 *
                                        MediaQuery.of(context).size.width,
                                  )),
                            ],
                          );
                        }
                      }),
                    );
                    //*****
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
