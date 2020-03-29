import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/library/widgets/plant_tile.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/custom_tabs.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:provider/provider.dart';

//not in use
class TabStreamWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContainerWrapper(
      child: Column(
        children: <Widget>[
          SectionHeader(title: 'Plants'),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 60.0 * MediaQuery.of(context).size.width * kScaleFactor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomTab(
                  symbol: Icon(
                    Icons.control_point_duplicate,
                    color: AppTextColor.white,
                    size: AppTextSize.huge * MediaQuery.of(context).size.width,
                  ),
                  onPress: () {
                    Provider.of<AppData>(context)
                        .setInputCustomTabSelected(tabNumber: 1);
                    Provider.of<AppData>(context)
                        .setPlantQueryField(queryField: PlantKeys.clones);
                  },
                  tabNumber: 1,
                  tabSelected: Provider.of<AppData>(context).customTabSelected,
                ),
                CustomTab(
                  symbol: Icon(
                    Icons.fiber_new,
                    color: AppTextColor.white,
                    size: AppTextSize.huge * MediaQuery.of(context).size.width,
                  ),
                  onPress: () {
                    Provider.of<AppData>(context)
                        .setInputCustomTabSelected(tabNumber: 2);
                    Provider.of<AppData>(context)
                        .setPlantQueryField(queryField: PlantKeys.id);
                  },
                  tabNumber: 2,
                  tabSelected: Provider.of<AppData>(context).customTabSelected,
                ),
                CustomTab(
                  symbol: Icon(
                    Icons.thumb_up,
                    color: AppTextColor.white,
                    size: AppTextSize.huge * MediaQuery.of(context).size.width,
                  ),
                  onPress: () {
                    Provider.of<AppData>(context)
                        .setInputCustomTabSelected(tabNumber: 3);
                    Provider.of<AppData>(context)
                        .setPlantQueryField(queryField: PlantKeys.likes);
                  },
                  tabNumber: 3,
                  tabSelected: Provider.of<AppData>(context).customTabSelected,
                ),
              ],
            ),
          ),
          StreamProvider<List<PlantData>>.value(
            value: Provider.of<CloudDB>(context)
                .streamCommunityPlantsTopDescending(
                    field: Provider.of<AppData>(context).plantQueryField),
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
    );
  }
}
