import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/communication_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/friends/widgets/button_add_friend.dart';
import 'package:plant_collector/screens/friends/widgets/connection_card.dart';
import 'package:plant_collector/screens/friends/widgets/request_card.dart';
import 'package:plant_collector/screens/friends/widgets/social_updates.dart';
import 'package:plant_collector/screens/library/widgets/announcements.dart';
import 'package:plant_collector/screens/library/widgets/communications.dart';
import 'package:plant_collector/screens/results/results.dart';
import 'package:plant_collector/screens/search/widgets/search_bar_submit.dart';
import 'package:plant_collector/screens/search/widgets/search_tile_user.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/info_tip.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //set providers for re-use
    AppData provAppData = Provider.of<AppData>(context, listen: false);

    return ScreenTemplate(
      implyLeading: false,
      screenTitle: GlobalStrings.friends,
      backgroundColor: kGreenLight,
      bottomBar: BottomBar(selectionNumber: 2),
      body: StreamProvider<UserData>.value(
        value: CloudDB.streamUserData(userID: provAppData.currentUserInfo.id),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: ListView(
            children: [
              SizedBox(height: 3.0),
              Consumer<UserData>(
                builder: (context, UserData user, _) {
                  if (user == null || user.requestsReceived.length < 1) {
                    return SizedBox();
                  } else {
                    List<Widget> requestList = [];
                    for (String request in user.requestsReceived) {
                      List blocked = user.blocked;
                      //only add card if not blocked
                      if (!blocked.contains(request))
                        requestList.add(
                          FutureProvider<Map>.value(
                            value: CloudDB.getConnectionProfile(
                                connectionID: request),
                            child: Consumer<Map>(
                                builder: (context, Map friend, _) {
                              if (friend == null) {
                                return SizedBox();
                              } else {
                                UserData profile =
                                    UserData.fromMap(map: friend);
                                return RequestCard(user: profile);
                              }
                            }),
                          ),
                        );
                    }
                    return ContainerWrapper(
                      child: Column(
                        children: <Widget>[
                          SectionHeader(
                            title: 'Requests',
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.0),
                            child: ListView(
                              shrinkWrap: true,
                              primary: false,
                              children: requestList,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              Container(
                constraints: BoxConstraints(
                    //this is a workaround to prevent listview jump when loading the contained streams
                    minHeight: 0.45 * MediaQuery.of(context).size.width),
                child: SocialUpdates(),
              ),
              Consumer<UserData>(builder: (context, UserData user, _) {
                if (user != null && user.id != null) {
                  return Column(
                    children: <Widget>[
                      StreamProvider<List<CommunicationData>>.value(
                        value: CloudDB.streamAdminToUser(user.id),
                        child: Communications(
                          title: 'Account',
                          color: Colors.yellowAccent,
                        ),
                      ),
                      FutureProvider<List<CommunicationData>>.value(
                        value: CloudDB.streamAnnouncements(),
                        child: Announcements(
                          title: 'Announcements',
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      )
                    ],
                  );
                } else {
                  return SizedBox();
                }
              }),
              SearchBarSubmit(
                onPress: () async {
                  if (provAppData.newDataInput.length > 0) {
                    List<UserData> results = await CloudDB.userSearchExact(
                        input: provAppData.newDataInput);
                    if (results != null) {
                      List<Widget> resultWidgets = [];
                      for (UserData user in results) {
                        resultWidgets.add(SearchUserTile(user: user));
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultsScreen(
                            searchResults: resultWidgets,
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonAddFriend(
                        friends: provAppData.currentUserInfo.friends),
                  ),
                  SizedBox(width: 5.0),
                  Expanded(
                    child: ButtonAdd(
                      icon: Icons.share,
                      scale: 0.6,
                      buttonText: 'Share App',
                      onPress: () {
                        Share.share(GlobalStrings.checkItOut,
                            subject: 'I\'m using the Plant Collector App!');
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      SectionHeader(
                        title: 'Connections',
                      ),
                      Consumer<UserData>(builder: (context, UserData user, _) {
                        if (user == null || user.friends.length < 1) {
                          return InfoTip(
                            onPress: () {},
                            showAlways: true,
                            text:
                                'If you know who you\'re looking for, you can search for them by username or email here.  \n\n'
                                'Otherwise, head on over to the ${GlobalStrings.discover} screen (bottom left button) to find Top Collectors or new ${GlobalStrings.friends} via their ${GlobalStrings.plants}.  ',
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              FutureProvider<List<UserData>>.value(
                                  value: CloudDB.getProfiles(
                                      connectionsList: user.friends),
                                  child: Consumer<List<UserData>>(
                                      builder: (context, profiles, _) {
                                    if (profiles != null) {
                                      //create a blank list for the cards
                                      List<Widget> connectionsCards = [];
                                      //generate cards
                                      for (UserData profile in profiles) {
                                        //
                                        //create a list of connection cards
                                        connectionsCards.add(
                                          ConnectionCard(
                                            user: profile,
                                            isRequest: false,
                                          ),
                                        );
                                      }
                                      return ListView(
                                        shrinkWrap: true,
                                        primary: false,
//                                            crossAxisCount: 1,
                                        children: connectionsCards,
//                                            childAspectRatio: 5,
                                      );
                                    } else {
                                      return Container(
                                        width: double.infinity,
                                        child: TileWhite(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.all(6.0),
                                                padding: EdgeInsets.all(3.0),
                                                height: 0.06 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                width: 0.06 *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 4.0,
                                                ),
                                              ),
                                              Text(
                                                'Checking Friends for Updates',
                                                style: TextStyle(
                                                  fontSize: AppTextSize.medium *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  color: AppTextColor.black,
                                                  fontWeight:
                                                      AppTextWeight.medium,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  })),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          );
                        }
                      }),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
