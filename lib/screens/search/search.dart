import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/screens/search/widgets/search_bar_live.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
//  final List<Widget> searchResults;
//  SearchScreen({@required this.searchResults});
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      bottomBar: BottomBar(selectionNumber: 4),
      screenTitle: 'Search',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 0.03 * MediaQuery.of(context).size.width),
          SearchBarLive(),
          SizedBox(
            height: 0.01 * MediaQuery.of(context).size.width,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.02 * MediaQuery.of(context).size.width,
              ),
              child: Consumer<AppData>(
                builder: (context, AppData data, _) {
                  return GridView.count(
                    childAspectRatio: 5,
                    mainAxisSpacing: 0.01 * MediaQuery.of(context).size.width,
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    primary: false,
                    children: UIBuilders.searchPlants(
                      searchInput: data.newDataInput,
                      plantData: data.currentUserPlants,
                      collections: data.currentUserCollections,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
