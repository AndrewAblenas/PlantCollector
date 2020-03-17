import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/library/widgets/plant_tile.dart';
import 'package:plant_collector/screens/results/results.dart';
import 'package:plant_collector/screens/search/widgets/search_bar_submit.dart';
import 'package:plant_collector/screens/search/widgets/search_tile_user.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/custom_tabs.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      screenTitle: GlobalStrings.discover,
      bottomBar: BottomBar(selectionNumber: 5),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5.0,
        ),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            ContainerWrapper(
              child: Column(
                children: <Widget>[
                  SectionHeader(title: GlobalStrings.announcements),
                  SizedBox(
                    height: 3.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: FutureProvider.value(
                      value:
                          Provider.of<CloudDB>(context).streamCommunication(),
                      child: ContainerWrapper(
                        marginVertical: 2.0,
                        color: AppTextColor.white,
                        child: Consumer<DocumentSnapshot>(
                          builder: (context, DocumentSnapshot future, _) {
                            //make sure future is not null
                            if (future != null) {
                              //extract the data
                              Map communication = future.data;
                              List keys = communication.keys.toList();
                              List<Widget> widgets = [];

                              //get the different
                              for (String key in keys) {
                                List headers = communication[key];

                                for (Map section in headers) {
                                  Widget article = Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        section['title'],
                                        style: TextStyle(
                                          color: AppTextColor.black,
                                          fontWeight: AppTextWeight.medium,
                                          fontSize: AppTextSize.medium *
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5.0),
                                        child: Container(
                                          height: 1.0,
                                          color: kGreenDark,
                                        ),
                                      ),
                                      Text(
                                        section['text'],
                                        style: TextStyle(
                                          color: AppTextColor.black,
                                          fontWeight: AppTextWeight.medium,
                                          fontSize: AppTextSize.small *
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  );
                                  widgets.add(article);
                                }
                              }

                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(
                                  10.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: widgets,
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
//                  AdminButton(
//                      label: 'onTap Copies Plant Data to New Location',
//                      onPress: () {
//                        Provider.of<CloudDB>(context).transferPlants();
//                      }),
                  SizedBox(
                    height: 3.0,
                  ),
                ],
              ),
            ),

            //build the top plants widget
            ContainerWrapper(
              child: Column(
                children: <Widget>[
                  SectionHeader(title: 'Plants'),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    height:
                        60.0 * MediaQuery.of(context).size.width * kScaleFactor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomTab(
                          symbol: Icon(
                            Icons.control_point_duplicate,
                            color: AppTextColor.white,
                            size: AppTextSize.huge *
                                MediaQuery.of(context).size.width,
                          ),
                          onPress: () {
                            Provider.of<AppData>(context)
                                .setCustomTabSelected(tabNumber: 1);
                            Provider.of<AppData>(context).setPlantQueryField(
                                queryField: PlantKeys.clones);
                          },
                          tabNumber: 1,
                          tabSelected:
                              Provider.of<AppData>(context).customTabSelected,
                        ),
                        CustomTab(
                          symbol: Icon(
                            Icons.fiber_new,
                            color: AppTextColor.white,
                            size: AppTextSize.huge *
                                MediaQuery.of(context).size.width,
                          ),
                          onPress: () {
                            Provider.of<AppData>(context)
                                .setCustomTabSelected(tabNumber: 2);
                            Provider.of<AppData>(context)
                                .setPlantQueryField(queryField: PlantKeys.id);
                          },
                          tabNumber: 2,
                          tabSelected:
                              Provider.of<AppData>(context).customTabSelected,
                        ),
                        CustomTab(
                          symbol: Icon(
                            Icons.thumb_up,
                            color: AppTextColor.white,
                            size: AppTextSize.huge *
                                MediaQuery.of(context).size.width,
                          ),
                          onPress: () {
                            Provider.of<AppData>(context)
                                .setCustomTabSelected(tabNumber: 3);
                            Provider.of<AppData>(context).setPlantQueryField(
                                queryField: PlantKeys.likes);
                          },
                          tabNumber: 3,
                          tabSelected:
                              Provider.of<AppData>(context).customTabSelected,
                        ),
                      ],
                    ),
                  ),
                  StreamProvider<List<PlantData>>.value(
                    value: Provider.of<CloudDB>(context)
                        .streamCommunityPlantsTopDescending(
                            field:
                                Provider.of<AppData>(context).plantQueryField),
                    child: Consumer<List<PlantData>>(
                      builder: (context, snap, _) {
                        if (snap == null) {
                          return SizedBox();
                        } else {
                          List<Widget> topPlants = [];
                          for (PlantData plant in snap) {
                            topPlants.add(
                              Padding(
                                padding: EdgeInsets.all(1.0),
                                child: PlantTile(
                                  connectionLibrary: true,
                                  communityView: true,
                                  collectionID: null,
                                  plant: plant,
                                  possibleParents: null,
                                ),
                              ),
                            );
                          }
                          if (topPlants.length == 0) topPlants.add(SizedBox());
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 5.0,
                            ),
                            child: ContainerWrapper(
                              color: AppTextColor.white,
                              marginVertical: 5.0,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  primary: false,
                                  shrinkWrap: true,
                                  children: topPlants,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),

            //Build the top users widget
            StreamProvider<DocumentSnapshot>.value(
              value: Provider.of<CloudDB>(context)
                  .streamCommunityTopUsersByPlants(),
              child: ContainerWrapper(
                child: Column(
                  children: <Widget>[
                    SectionHeader(title: 'Top Collectors'),
                    Consumer<DocumentSnapshot>(
                      builder: (context, DocumentSnapshot snap, _) {
                        if (snap == null) {
                          return SizedBox();
                        } else {
                          List userList = snap.data[DBFields.byPlants];
                          List<Widget> topUsers = [];
                          for (Map user in userList) {
                            UserData profile = UserData.fromMap(map: user);
                            topUsers.add(SearchUserTile(user: profile));
                          }
                          if (topUsers.length == 0) topUsers.add(SizedBox());
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
            SearchBarSubmit(
              onPress: () async {
                if (Provider.of<AppData>(context).newDataInput.length > 0) {
                  List<UserData> results = await Provider.of<CloudDB>(context)
                      .userSearchExact(
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
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
