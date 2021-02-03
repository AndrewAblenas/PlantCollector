import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/search/widgets/search_bar_live.dart';
import 'package:plant_collector/widgets/info_tip.dart';
import 'package:provider/provider.dart';

class SearchMyPlants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchBarLive(),
        SizedBox(
          height: 0.01 * MediaQuery.of(context).size.width,
        ),
        Expanded(
          child: Consumer<AppData>(
            builder: (context, AppData data, _) {
              bool hasPlants = (data.currentUserPlants != null &&
                  data.currentUserPlants.length > 0);
              Widget display = (hasPlants == true)
                  ? ListView(
//                                        childAspectRatio: 5,
//                                        crossAxisCount: 1,
                      shrinkWrap: true,
                      primary: false,
                      children: UIBuilders.searchPlants(
                        searchInput: data.searchBarLiveInput,
                        plantData: data.currentUserPlants,
                        collections: data.currentUserCollections,
                      ),
                    )
                  : InfoTip(
                      onPress: () {},
                      showAlways: true,
                      text:
                          'You don\'t currently have any ${GlobalStrings.plants} to search through.  \n\n'
                          'Add some in your ${GlobalStrings.library} (the bottom middle button).  \n\n'
                          'Then you will be able to search through them live here.  ');
              return display;
            },
          ),
        ),
      ],
    );
  }
}
