import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/friends/widgets/button_add_friend.dart';
import 'package:plant_collector/screens/friends/widgets/connection_card.dart';
import 'package:plant_collector/screens/friends/widgets/request_card.dart';
import 'package:plant_collector/screens/friends/widgets/social_updates.dart';
import 'package:plant_collector/screens/results/results.dart';
import 'package:plant_collector/screens/search/widgets/search_bar_submit.dart';
import 'package:plant_collector/screens/search/widgets/search_tile_user.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/info_tip.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      implyLeading: false,
      screenTitle: GlobalStrings.friends,
      bottomBar: BottomBar(selectionNumber: 2),
      body: StreamProvider<UserData>.value(
        value: CloudDB.streamUserData(
            userID: Provider.of<AppData>(context).currentUserInfo.id),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: ListView(
              children: [
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
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 1.0),
                              child: ListView(
                                shrinkWrap: true,
                                primary: false,
                                children: requestList,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
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
                SearchBarSubmit(
                  onPress: () async {
                    if (Provider.of<AppData>(context).newDataInput.length > 0) {
                      List<UserData> results = await CloudDB.userSearchExact(
                          input: Provider.of<AppData>(context).newDataInput);
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
                Column(
                  children: <Widget>[
                    ContainerWrapper(
                      child: Column(
                        children: <Widget>[
                          SectionHeader(
                            title: 'Connections',
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Consumer<UserData>(
                              builder: (context, UserData user, _) {
                            if (user == null || user.friends.length < 1) {
                              return InfoTip(
                                onPress: () {},
                                showAlways: true,
                                text:
                                    'If you know who you\'re looking for, you can search for them by username or email here.  \n\n'
                                    'Otherwise, head on over to the ${GlobalStrings.discover} screen (bottom left button) to find Top Collectors or new ${GlobalStrings.friends} via their ${GlobalStrings.plants}.  ',
                              );
                            } else {
                              List<Widget> connectionsCards = [];
                              for (String friend in user.friends) {
                                //create a list of connection cards
                                connectionsCards.add(
                                  FutureProvider<Map>.value(
                                    value: CloudDB.getConnectionProfile(
                                        connectionID: friend),
                                    child: Consumer<Map>(
                                        builder: (context, Map friend, _) {
                                      if (friend == null) {
                                        return SizedBox();
                                      } else {
                                        UserData profile =
                                            UserData.fromMap(map: friend);
                                        return ConnectionCard(
                                          user: profile,
                                          isRequest: false,
                                        );
                                      }
                                    }),
                                  ),
                                );
                              }
                              return Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ButtonAddFriend(
                                            friends:
                                                Provider.of<AppData>(context)
                                                    .currentUserInfo
                                                    .friends),
                                      ),
                                      Expanded(
                                        child: ButtonAdd(
                                          scale: 0.6,
                                          icon: Icons.share,
                                          buttonText: 'Share App',
                                          onPress: () {
                                            Share.share(
                                                GlobalStrings.checkItOut,
                                                subject:
                                                    'I\'m using the Plant Collector App!');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  GridView.count(
                                    shrinkWrap: true,
                                    primary: false,
                                    crossAxisCount: 1,
                                    children: connectionsCards,
                                    childAspectRatio: 5,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
