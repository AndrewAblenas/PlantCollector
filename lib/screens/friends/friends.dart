import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/friend_data.dart';
import 'package:plant_collector/models/data_types/request_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/friends/widgets/button_add_friend.dart';
import 'package:plant_collector/screens/friends/widgets/connection_card.dart';
import 'package:plant_collector/screens/friends/widgets/request_card.dart';
import 'package:plant_collector/screens/friends/widgets/social_updates.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/info_tip.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:provider/provider.dart';

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
                                    ButtonAddFriend(friends: friends),
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
