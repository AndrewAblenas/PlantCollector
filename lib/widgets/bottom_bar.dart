import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/tab_transitions.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/discover/discover.dart';
import 'package:plant_collector/screens/friends/friends.dart';
import 'package:plant_collector/screens/search/search.dart';
import 'package:plant_collector/screens/settings/settings.dart';
import 'package:plant_collector/widgets/set_username_bundle.dart';
import 'package:provider/provider.dart';

//BOTTOM NAVIGATION BAR
class BottomBar extends StatelessWidget {
  final int selectionNumber;
  BottomBar({@required this.selectionNumber});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData>.value(
      value: Provider.of<CloudDB>(context).streamCurrentUser(),
      child: StreamProvider<bool>.value(
        value: Provider.of<CloudDB>(context).checkForUnreadMessages(),
        child: Container(
          height: 60.0 * MediaQuery.of(context).size.width * kScaleFactor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //if you change the order and tab numbers, make sure to update screens tab numbers too
              Expanded(
                child: BottomTab(
                  offset: 2,
                  symbol: Icon(
                    Icons.blur_circular,
                    color: AppTextColor.white,
                    size: AppTextSize.huge * MediaQuery.of(context).size.width,
                  ),
                  navigate: () {
                    //set default custom tab number to 2 on page load
                    if (Provider.of<AppData>(context, listen: false)
                            .customTabSelected ==
                        null)
                      //set the number directly to prevent call of the notify listeners
                      Provider.of<AppData>(context, listen: false)
                          .customTabSelected = 2;

                    //if the tab selected is null then assign a value
                    if (Provider.of<AppData>(context, listen: false)
                            .customFeedSelected ==
                        null) {
                      Provider.of<AppData>(context, listen: false)
                          .customFeedSelected = 3;
                      Provider.of<AppData>(context, listen: false)
                          .customFeedType = PlantData;
                      Provider.of<AppData>(context, listen: false)
                          .customFeedQueryField = PlantKeys.created;
                    }

//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => DiscoverScreen(),
//                    ),
//                  );
                    Navigator.of(context)
                        .push(transitionNone(nextPage: DiscoverScreen()));
                  },
                  tabSelected: selectionNumber,
                  tabNumber: 1,
                ),
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    BottomTab(
                      offset: 1,
                      symbol: Icon(
                        Icons.people,
                        color: AppTextColor.white,
                        size: AppTextSize.huge *
                            MediaQuery.of(context).size.width,
                      ),
                      navigate: () {
                        Navigator.of(context)
                            .push(transitionNone(nextPage: FriendsScreen()));
                        //show dialog to prompt for user handle
                        if (Provider.of<AppData>(context, listen: false)
                                .currentUserInfo
                                .uniquePublicID ==
                            '') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SetUsernameBundle();
                              });
                        }
                      },
                      tabSelected: selectionNumber,
                      tabNumber: 2,
                    ),
                    Consumer<bool>(builder: (context, bool unreadMessages, _) {
                      return Consumer<UserData>(
                          builder: (context, UserData user, _) {
                        //don't show anything if no data or no requests and no messages
                        if (user != null &&
                            user.id != null &&
                            (user.requestsReceived.length >= 1 ||
                                unreadMessages == true)) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  transitionNone(nextPage: FriendsScreen()));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Icon(
                                    Icons.message,
                                    size: AppTextSize.large *
                                        MediaQuery.of(context).size.width,
                                    color: kGreenLight,
                                  ),
                                ),
                                SizedBox(
                                  height: 10 *
                                      kScaleFactor *
                                      MediaQuery.of(context).size.width,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      });
                    }),
                  ],
                ),
              ),
              Expanded(
                child: BottomTab(
                  symbol: Padding(
                    padding: EdgeInsets.all(
                        5.0 * MediaQuery.of(context).size.width * kScaleFactor),
                    child: Image(
                      image: AssetImage('assets/images/app_icon_white_128.png'),
                      height: AppTextSize.medium *
                          MediaQuery.of(context).size.width,
                    ),
                  ),
                  navigate: null,
                  tabSelected: selectionNumber,
                  tabNumber: 3,
                ),
              ),
              Expanded(
                child: BottomTab(
                  offset: 1,
                  symbol: Icon(
                    Icons.search,
                    color: AppTextColor.white,
                    size: AppTextSize.huge * MediaQuery.of(context).size.width,
                  ),
                  navigate: () {
                    Provider.of<AppData>(context, listen: false)
                        .setInputSearchBarLive('');
                    if (Provider.of<AppData>(context, listen: false)
                            .tabBarTopSelected ==
                        null) {
                      Provider.of<AppData>(context, listen: false)
                          .tabBarTopSelected = 1;
                    }
                    //reset map
                    Provider.of<AppData>(context, listen: false)
                        .searchQueryInput = {};
                    Navigator.of(context)
                        .push(transitionNone(nextPage: SearchScreen()));
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => SearchScreen(),
//                    ),
//                  );
                  },
                  tabSelected: selectionNumber,
                  tabNumber: 4,
                ),
              ),
              Expanded(
                child: BottomTab(
                  offset: 2,
                  symbol: Icon(
                    Icons.settings,
                    color: AppTextColor.white,
                    size: AppTextSize.huge * MediaQuery.of(context).size.width,
                  ),
                  navigate: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => SettingsScreen(),
//                    ),
//                  );
                    Navigator.of(context)
                        .push(transitionNone(nextPage: SettingsScreen()));
                  },
                  tabSelected: selectionNumber,
                  tabNumber: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//TAB
class BottomTab extends StatelessWidget {
  final Function navigate;
  final Widget symbol;
  final int tabSelected;
  final int tabNumber;
  final int offset;
  BottomTab(
      {@required this.symbol,
      @required this.navigate,
      this.tabSelected,
      @required this.tabNumber,
      this.offset = 0});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //only navigate if user clicks on a tab that isn't currently selected
        if (tabSelected != tabNumber) {
          //don't pop context when leaving Library (tab 3), just navigate
          if (tabSelected == 3) {
            navigate();
            //when navigating to Library from any page, pop to get back
          } else if (tabNumber == 3) {
            Navigator.pop(context);
          } else {
            //otherwise pop the window and open the next
            Navigator.pop(context);
            navigate();
          }
        }
      },
      child: Column(
        children: <Widget>[
          Expanded(flex: offset, child: SizedBox()),
          Expanded(
            flex: 10,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: tabSelected == tabNumber
                    ? kBackgroundGradient
                    : kGradientGreenSolidDark90,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      5.0 * MediaQuery.of(context).size.width * kScaleFactor),
                  topRight: Radius.circular(
                      5.0 * MediaQuery.of(context).size.width * kScaleFactor),
                ),
              ),
              child: symbol,
            ),
          ),
        ],
      ),
    );
  }
}
