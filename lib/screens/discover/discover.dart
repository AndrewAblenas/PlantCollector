import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/simple_button.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/discover/widgets/feed_scroll.dart';
import 'package:plant_collector/screens/library/widgets/plant_tile.dart';
import 'package:plant_collector/screens/search/widgets/search_tile_user.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      implyLeading: false,
      screenTitle: GlobalStrings.discover,
      bottomBar: BottomBar(selectionNumber: 1),
      child: Provider<int>.value(
        value: Provider.of<AppData>(context).customFeedSelected,
        child: Container(
          color: AppTextColor.white,
          height: MediaQuery.of(context).size.height,
          child: Column(children: <Widget>[
            FeedScroll(
              items: <SimpleButton>[
                SimpleButton(
                  icon: Icons.control_point_duplicate,
                  type: PlantData,
                  onPress: () {},
                  queryField: PlantKeys.clones,
                ),
                SimpleButton(
                  icon: Icons.thumb_up,
                  type: PlantData,
                  onPress: () {},
                  queryField: PlantKeys.likes,
                ),
                SimpleButton(
                  icon: Icons.fiber_new,
                  type: PlantData,
                  onPress: () {},
                  queryField: PlantKeys.created,
                ),
                SimpleButton(
                  icon: Icons.autorenew,
                  type: PlantData,
                  onPress: () {},
                  queryField: PlantKeys.update,
                ),
                SimpleButton(
                  icon: Icons.people,
                  type: UserData,
                  onPress: () {},
                  //not needed for top people stream
                  queryField: UserKeys.plants,
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                child: ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: <Widget>[
                    //determine what stream to show
                    (Provider.of<AppData>(context).customFeedType == PlantData)
                        ?
                        //show PlantData stream
                        StreamProvider<List<PlantData>>.value(
                            value: Provider.of<CloudDB>(context)
                                .streamCommunityPlantsTopDescending(
                                    field: Provider.of<AppData>(context)
                                        .customFeedQueryField),
                            child: Consumer<List<PlantData>>(
                              builder: (context, snap, _) {
                                if (snap == null) {
                                  return SizedBox();
                                } else {
                                  String tabText;
                                  int value = Provider.of<AppData>(context)
                                      .customFeedSelected;
                                  if (value == 1) {
                                    tabText = 'Most Cloned Plants';
                                  } else if (value == 2) {
                                    tabText = 'Most GreenThumbed Plants';
                                  } else if (value == 3) {
                                    tabText = 'Newly Added Plants';
                                  } else if (value == 4) {
                                    tabText = 'Recently Updated Plants';
                                  } else if (value == 5) {
                                    tabText = 'Top Plant Collectors';
                                  } else {}
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      StreamDescription(tabText: tabText),
                                      GridView.builder(
                                          shrinkWrap: true,
                                          primary: false,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 1.0,
                                          ),
                                          scrollDirection: Axis.vertical,
                                          itemCount: snap.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding: EdgeInsets.all(1.0),
                                              child: PlantTile(
                                                connectionLibrary: true,
                                                communityView: true,
                                                collectionID: null,
                                                plant: snap[index],
                                                possibleParents: null,
                                              ),
                                            );
                                          }),
                                    ],
                                  );
                                }
                              },
                            ),
                          )
                        :
                        //otherwise deliver the UserData stream
                        StreamProvider<DocumentSnapshot>.value(
                            value: Provider.of<CloudDB>(context)
                                .streamCommunityTopUsersByPlants(),
                            child: Container(
                              color: kGreenMedium,
                              child: Column(
                                children: <Widget>[
                                  StreamDescription(
                                      tabText: 'Top Plant Collectors'),
                                  Consumer<DocumentSnapshot>(
                                    builder:
                                        (context, DocumentSnapshot snap, _) {
                                      if (snap == null) {
                                        return SizedBox();
                                      } else {
                                        List userList =
                                            snap.data[DBFields.byPlants];
                                        List<Widget> topUsers = [];
                                        for (Map user in userList) {
                                          UserData profile =
                                              UserData.fromMap(map: user);
                                          topUsers.add(
                                              SearchUserTile(user: profile));
                                        }
                                        if (topUsers.length == 0)
                                          topUsers.add(SizedBox());
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5.0,
                                            vertical: 5.0,
                                          ),
                                          child: ListView(
                                            primary: false,
                                            shrinkWrap: true,
                                            children: topUsers,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                    //build the top plants widget
                  ],
                ),
              ),
            ),
//                }
//              },
//            ),
          ]),
        ),
      ),
    );
  }
}

class StreamDescription extends StatelessWidget {
  StreamDescription({
    @required this.tabText,
  });

  final String tabText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: kBackgroundGradientMid),
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: Text(
          tabText.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppTextSize.small * MediaQuery.of(context).size.width,
            fontWeight: AppTextWeight.medium,
            color: kGreenLight,
          ),
        ),
      ),
    );
  }
}
