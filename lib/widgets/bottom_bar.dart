import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/discover/discover.dart';
import 'package:plant_collector/screens/friends/friends.dart';
import 'package:plant_collector/screens/search/search.dart';
import 'package:plant_collector/screens/settings/settings.dart';
import 'package:provider/provider.dart';

//BOTTOM NAVIGATION BAR
class BottomBar extends StatelessWidget {
  final int selectionNumber;
  BottomBar({@required this.selectionNumber});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0 * MediaQuery.of(context).size.width * kScaleFactor,
      color: kGreenDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //if you change the order and tab numbers, make sure to update screens tab numbers too
          BottomTab(
            symbol: Icon(
              Icons.blur_circular,
              color: AppTextColor.white,
              size: AppTextSize.huge * MediaQuery.of(context).size.width,
            ),
            navigate: () {
              //set default custom tab number to 2 on page load
              if (Provider.of<AppData>(context).customTabSelected == null)
                //set the number directly to prevent call of the notify listeners
                Provider.of<AppData>(context).customTabSelected = 2;

              //if the tab selected is null then assign a value
              if (Provider.of<AppData>(context).customFeedSelected == null) {
                Provider.of<AppData>(context).customFeedSelected = 3;
                Provider.of<AppData>(context).customFeedType = PlantData;
                Provider.of<AppData>(context).customFeedQueryField =
                    PlantKeys.created;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiscoverScreen(),
                ),
              );
            },
            tabSelected: selectionNumber,
            tabNumber: 1,
          ),
          BottomTab(
            symbol: Icon(
              Icons.people,
              color: AppTextColor.white,
              size: AppTextSize.huge * MediaQuery.of(context).size.width,
            ),
            navigate: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendsScreen(),
                ),
              );
            },
            tabSelected: selectionNumber,
            tabNumber: 2,
          ),
          BottomTab(
            symbol: Padding(
              padding: EdgeInsets.all(
                  5.0 * MediaQuery.of(context).size.width * kScaleFactor),
              child: Image(
                image: AssetImage('assets/images/app_icon_white_128.png'),
                height: AppTextSize.medium * MediaQuery.of(context).size.width,
              ),
            ),
            navigate: null,
            tabSelected: selectionNumber,
            tabNumber: 3,
          ),
          BottomTab(
            symbol: Icon(
              Icons.search,
              color: AppTextColor.white,
              size: AppTextSize.huge * MediaQuery.of(context).size.width,
            ),
            navigate: () {
              Provider.of<AppData>(context).setNewDataInput('');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
            tabSelected: selectionNumber,
            tabNumber: 4,
          ),
          BottomTab(
            symbol: Icon(
              Icons.settings,
              color: AppTextColor.white,
              size: AppTextSize.huge * MediaQuery.of(context).size.width,
            ),
            navigate: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
            tabSelected: selectionNumber,
            tabNumber: 5,
          ),
        ],
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
  BottomTab({
    @required this.symbol,
    @required this.navigate,
    this.tabSelected,
    @required this.tabNumber,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          //only navigate if user clicks on a tab that isn't currently selected
          if (tabSelected != tabNumber) {
            //don't pop context when leaving Library (tab 3), just navigate
            if (tabSelected == 3) {
              navigate();
              //when navigating to Library from any page, pop to get back
            } else if (tabNumber == 3) {
              //run an orphaned plant check every time this button is hidden
              //this decision to place it here is arbitrary
              List<String> orphaned =
                  Provider.of<CloudDB>(context).orphanedPlantCheck(
                collections:
                    Provider.of<AppData>(context).currentUserCollections,
                plants: Provider.of<AppData>(context).currentUserPlants,
              );
              print('Orphaned Plant List: $orphaned');
              if (orphaned.length > 0) {
                //CHECK COLLECTION FIRST
                //first check if orphaned collection exists
                bool matchCollection = false;
                String collectionID = DBDefaultDocument.orphaned;
                for (CollectionData collection
                    in Provider.of<AppData>(context).currentUserCollections) {
                  if (collection.id == collectionID) matchCollection = true;
                }
                //provide default document
                Map defaultCollection = Provider.of<CloudDB>(context)
                    .newDefaultCollection(
                      collectionName: collectionID,
                    )
                    .toMap();
                //now complete cloning
                Provider.of<CloudDB>(context).updateDefaultDocumentL2(
                  collectionL2: DBFolder.collections,
                  documentL2: collectionID,
                  key: CollectionKeys.plants,
                  entries: orphaned,
                  match: matchCollection,
                  defaultDocument: defaultCollection,
                );
              }
              Navigator.pop(context);
            } else {
              //otherwise pop the window and open the next
              Navigator.pop(context);
              navigate();
            }
          }
        },
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: tabSelected == tabNumber
                ? kBackgroundGradient
                : kBackgroundGradientSolidDark,
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
    );
  }
}
