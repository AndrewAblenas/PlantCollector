import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_select.dart';
import 'package:plant_collector/screens/library/widgets/collection_card.dart';
import 'package:plant_collector/screens/plant/widgets/add_journal_button.dart';
import 'package:plant_collector/screens/plant/widgets/journal_tile.dart';
import 'package:plant_collector/screens/plant/widgets/viewer_utility_buttons.dart';
import 'package:plant_collector/screens/search/widgets/search_tile_plant.dart';
import 'package:plant_collector/widgets/dialogs/color_picker/button_color.dart';
import 'package:plant_collector/widgets/dialogs/select/dialog_functions.dart';
import 'package:plant_collector/screens/account/widgets/settings_card.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/screens/plant/widgets/plant_info_card.dart';
import 'package:plant_collector/screens/plant/widgets/plant_photo.dart';
import 'package:date_format/date_format.dart';
import 'package:plant_collector/screens/plant/widgets/add_photo.dart';
import 'package:plant_collector/widgets/info_tip.dart';

class UIBuilders extends ChangeNotifier {
  //*****************LIBRARY PAGE RELATED BUILDERS*****************

  //Delay build of stat cards until streams have updated and saved value to local
  //this is only an issue on first load as the streams are located lower in the tree
  static Future<String> statCardDelay() async {
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    return 'Done';
  }

  //Generate Search plant widgets
  static List<Widget> searchPlants(
      {@required String searchInput,
      @required List<PlantData> plantData,
      @required List<CollectionData> collections}) {
    List<Widget> searchResults = [];
    searchInput.toLowerCase();
    if (searchInput == '') {
      for (PlantData plant in plantData) {
        String collectionID;
        for (CollectionData collection in collections) {
          if (collection.plants.contains(plant.id)) {
            collectionID = collection.id;
          }
        }
        searchResults
            .add(SearchPlantTile(plant: plant, collectionID: collectionID));
      }
    } else {
      for (PlantData plant in plantData) {
        if (plant.name.toLowerCase().contains(searchInput) ||
            plant.genus.toLowerCase().contains(searchInput) ||
            plant.species.toLowerCase().contains(searchInput) ||
            plant.variety.toLowerCase().contains(searchInput)) {
          String collectionID;
          for (CollectionData collection in collections) {
            if (collection.plants.contains(plant.id)) {
              collectionID = collection.id;
            }
          }
          searchResults
              .add(SearchPlantTile(plant: plant, collectionID: collectionID));
        }
      }
    }
    return searchResults.length > 0 ? searchResults : [SizedBox()];
  }

  //Generate Group widgets
//  static Column displayGroups(
//      {@required List<GroupData> userGroups,
//      @required bool connectionLibrary}) {
//    List<Widget> groupList = [];
//    Column groupColumn;
//    if (userGroups != null && userGroups.length >= 1) {
//      userGroups.sort((a, b) => (a.order).compareTo((b.order)));
//      for (GroupData group in userGroups) {
//        groupList.add(
//          GroupCard(
//            connectionLibrary: connectionLibrary,
//            group: group,
//            groups: userGroups,
//          ),
//        );
//      }
//      groupColumn = Column(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
//        children: groupList,
//      );
//    } else {
//      groupColumn = Column(
//        children: <Widget>[
//          InfoTip(
//              text: 'You\'re Library is currently empty.  \n\n'
//                  'Tap the "+ Create New ${GlobalStrings.group}" button to build a shelf.  \n\n'
//                  'A "Houseplants" ${GlobalStrings.group} to display your indoor ${GlobalStrings.collections} might be a good place to start!  ')
//        ],
//      );
//    }
//    return groupColumn;
//  }

  //GENERATE COLLECTION WIDGETS
  static Column displayCollections(
      {@required List<CollectionData> userCollections,
      @required String groupID,
      @required Color groupColor,
      @required bool connectionLibrary}) {
    //check that they aren't default
    List<Widget> collectionList = [];
    Column collectionColumn;
    //make sure that there are collections in the list
    if (userCollections != null && userCollections.length > 0) {
      for (CollectionData collection in userCollections) {
        //connection view check for defaults
        bool defaultView =
            DBDefaultDocument.collectionExclude.contains(collection.id);
        //hide default collections when empty
        bool hide = (defaultView == true && collection.plants.length == 0);
        if (hide == false) {
          //add collection card for each collection
          collectionList.add(
            CollectionCard(
              connectionLibrary: connectionLibrary,
              defaultView: defaultView,
              collection: collection,
//      collectionPlantTotal: collectionPlantTotal,
              colorTheme: groupColor,
              groupID: groupID,
            ),
          );
        }
      }
      //set the column to return
      collectionColumn = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: collectionList,
      );
    } else if (userCollections == null ||
        userCollections.length == 0 && connectionLibrary == false) {
      //check if in a group and add delete button
      collectionColumn = Column(
        children: <Widget>[
          InfoTip(
              onPress: () {},
              showAlways: true,
              text: 'You\'re Library is currently empty.  \n\n'
                  'Tap the "+ Build New ${GlobalStrings.collection}" button to build a ${GlobalStrings.collection}.  \n\n'
                  'A "Houseplants" or "Orchids" ${GlobalStrings.collection} might be a good place to start!  '),
//          groupID == null ? null : GroupDelete(groupID: groupID),
        ],
      );
    } else {
      //set to blank
      collectionColumn = Column(
        children: <Widget>[
          SizedBox(),
        ],
      );
    }
    return collectionColumn;
  }

//*****************PLANT SCREEN RELATED BUILDERS*****************

  //GENERATE IMAGE TILE LIST FOR THE CAROUSEL
  static List<Widget> generateImageTileWidgets(
      {@required bool connectionLibrary,
      @required String plantID,
      @required List<dynamic> listURL,
      @required String thumbnail,
      @required bool largeWidget}) {
    //initialize the widget list
    List<Widget> imageTileList = [];
    //check to make sure list is not null
    if (listURL != null) {
      //look through list
      for (String url in listURL) {
        //get date from image name (more efficient than meta?)
        String frontRemoved = url.split('_image_')[1];
        String epochSeconds = frontRemoved.split('.jpg')[0];
        String date = formatDate(
            DateTime.fromMillisecondsSinceEpoch(int.parse(epochSeconds)),
            [MM, ' ', d, ', ', yyyy]);
        //create image tiles
        imageTileList.add(
          PlantPhoto(
            connectionLibrary: connectionLibrary,
            imageURL: url,
            imageDate: date,
            largeWidget: largeWidget,
          ),
        );
      }
    } else {}
    //add an image add button to the list
    if (connectionLibrary == false) {
      //place image add at the beginning for carousel
      //place at the end if grid view
      int index = (listURL != null && listURL.length >= 8 ? listURL.length : 0);
      imageTileList.insert(
        index,
        AddPhoto(
          plantID: plantID,
          largeWidget: largeWidget,
        ),
      );
    }
    //if nothing in the list add a blank placeholder
    //should only show on connection true with no photos
    if (imageTileList.length <= 0)
      imageTileList.add(Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/default.png'),
          ),
          boxShadow: kShadowBox,
        ),
      ));
    print('generateImageTileWidgets: COMPLETE');
    return imageTileList;
  }

  //REFORMAT PLANT INFO TO SHARE
  static String sharePlant({@required Map plantMap}) {
    //TODO add link
    String plantShare = 'Check out this Plant!\n\n';
    if (plantMap != null) {
      for (String key in PlantKeys.visible)
        if (plantMap[key] != null && plantMap[key] != '') {
          plantShare =
              plantShare + '${PlantKeys.descriptors[key]}: ${plantMap[key]}\n';
        }
    }
    return plantShare + '\nSee it on Plant Collector:\n<future app store link>';
  }

  //GENERATE INFO CARD WIDGETS
  static Column displayInfoCards(
      {@required bool connectionLibrary,
      @required PlantData plant,
      @required BuildContext context}) {
    //create blank list to hold info card widgets
    List<Widget> infoCardList = [];
    //create a list of only the keys you want visible
    List<String> keyList = PlantKeys.visible;
    //add utility bar
    infoCardList.add(
      Row(
        children: <Widget>[
          ViewerUtilityButtons(plant: plant),
        ],
      ),
    );
    //need null check to deal with issues on plant delete
    //connection library check will hide journal unless plant belongs to user
    if (plant != null) {
      //for  all these strings in the list
      for (String key in keyList) {
        //check to see that they aren't set to default value (hidden)
        Map plantMap = plant.toMap();
        if (plantMap[key] != null && plantMap[key] != '') {
          //if not default then create a widget and add to the list
          String displayLabel = PlantKeys.descriptors[key];
          String displayText = plantMap[key];
          infoCardList.add(
            PlantInfoCard(
              connectionLibrary: connectionLibrary,
              plantID: plant.id,
              cardKey: key.toString(),
              displayLabel: displayLabel,
              displayText: displayText,
            ),
          );
        }
      }
    }
    if (infoCardList.length < keyList.length && connectionLibrary == false) {
      infoCardList.add(
        ButtonAdd(
          buttonText: 'Add Information',
          onPress: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogScreenSelect(
                    title: 'Add new information about this Plant',
                    items: createDialogWidgetList(
                      plant: plant,
                    ),
                  );
                });
          },
        ),
      );
    }

    print('displayInfoCards: COMPLETE');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: infoCardList,
    );
  }

  static Image getBadge({@required int userTotalPlants}) {
    //initialize empty string
    String imageFile;

    //determine which image to assign
    if (userTotalPlants == 0 || userTotalPlants == null) {
      imageFile = 'assets/images/badges/BadgeSmallBlackL1.png';
    } else if (userTotalPlants < 10) {
      imageFile = 'assets/images/badges/BadgeSmallBlackL2.png';
    } else if (userTotalPlants < 25) {
      imageFile = 'assets/images/badges/BadgeSmallBlackL3.png';
    } else if (userTotalPlants < 100) {
      imageFile = 'assets/images/badges/BadgeSmallBlackL4.png';
    } else if (userTotalPlants < 500) {
      imageFile = 'assets/images/badges/BadgeSmallBlackL5.png';
    } else {
      imageFile = 'assets/images/badges/BadgeSmallBlackL6.png';
    }

    //return the image
    return Image.asset(imageFile);
  }

  static Column displayJournalTiles(
      {@required List journals, @required String plantID}) {
    //initialize blank list of widgets
    List<Widget> journalEntries = [];

    //create a journal entry for each item in list
    for (Map entry in journals) {
      JournalData entryBuild = JournalData.fromMap(map: entry);

      //allow the post to be edited only for 24hrs
      bool showEdit =
          (DateTime.now().millisecondsSinceEpoch - int.parse(entryBuild.date) <=
                  86400000)
              ? true
              : false;

      //add the journal entry
      journalEntries.add(
        JournalTile(
          journal: entryBuild,
          showDate: true,
          showEdit: showEdit,
          plantID: plantID,
          //to prevent a copy of journal data from being passed to each widget if no edit
          journalList: showEdit == true ? journals : null,
        ),
      );
    }
    //now include the add button
    journalEntries.add(AddJournalButton(plantID: plantID));

    //return the entries in a column
    return Column(
      //reverse the entries so most recent is first
      children: journalEntries.reversed.toList(),
    );
  }

//*****************ACCOUNT SCREEN RELATED BUILDERS*****************

//GENERATE ACCOUNT TILE
  static Column displayAccountCards({@required Map accountInfo}) {
    Column column;
    if (accountInfo != null) {
      //create blank list for widgets
      List<Widget> accountCardList = [];
      //create a key list
      List<String> keyList = UserKeys.descriptors.keys.toList();
      keyList.remove(UserKeys.id);
      for (String value in keyList) {
        String displayLabel = UserKeys.descriptors[value];
        String displayText = accountInfo[value].toString();
        accountCardList.add(
          SettingsCard(
            onPress: null,
            onSubmit: () {},
            cardLabel: displayLabel,
            cardText: displayText,
          ),
        );
      }
      column = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: accountCardList,
      );
    } else {
      column = Column();
    }
    print('displayAccountCards: COMPLETE');
    return column;
  }

  //*****************CONSTRUCTORS FOR BUTTON LISTS IN DIALOGS*****************//

//Dialog buttons to move collection to different Group
  static List<Widget> createDialogGroupButtons({
    @required String selectedItemID,
    @required String currentParentID,
    @required List<GroupData> possibleParents,
  }) {
    List<Widget> widgetList = [];
    for (GroupData group in possibleParents) {
      if (group.id != currentParentID) {
        widgetList.add(
          DialogItemGroup(
            buttonText: group.name,
            buttonPossibleParentID: group.id,
            entryID: selectedItemID,
            currentParentID: currentParentID,
          ),
        );
      }
    }
    return widgetList;
  }

//Dialog buttons to move Plant to different Collection
  static List<Widget> createDialogCollectionButtons({
    @required String selectedItemID,
    @required String currentParentID,
    @required List<CollectionData> possibleParents,
  }) {
    List<Widget> widgetList = [];
    for (CollectionData collection in possibleParents) {
      if (collection.id != currentParentID) {
        widgetList.add(
          DialogItemCollection(
            buttonText: collection.name,
            buttonPossibleParentID: collection.id,
            entryID: selectedItemID,
            currentParentID: currentParentID,
          ),
        );
      }
    }
    return widgetList;
  }

//Create color buttons
  static List<Widget> colorButtonsList(
      {@required List<Color> colors,
      @required Function onPress,
      @required collectionID}) {
    List<Widget> list = [];
    for (Color color in colors) {
      list.add(ButtonColor(
        color: color,
        onPress: onPress,
        collectionID: collectionID,
      ));
    }
    return list;
  }

//CREATE PLANT LIST BUTTONS
  static List<Widget> createDialogWidgetList({@required PlantData plant}) {
    //create a blank list to populate with widgets
    List<Widget> listItems = [];
    //create list of all plant keys in the constant map
    List list = PlantKeys.descriptors.keys.toList();
    list.remove(PlantKeys.thumbnail);
    //create list of plant keys not displayed in plant screen
    List<String> plantKeysNotDisplayed = [];
    //needed for delete plant to prevent null[] call
    if (plant != null) {
      for (String key in list) {
        if (plant.toMap()[key] == '') {
          plantKeysNotDisplayed.add(key);
        }
      }
    }
    plantKeysNotDisplayed.remove(PlantKeys.images);
    for (String key in plantKeysNotDisplayed) {
      listItems.add(
        DialogItemPlant(
          buttonKey: key,
          buttonText: PlantKeys.descriptors[key],
          plantID: plant.id,
        ),
      );
    }
    return listItems;
  }

  //END OF SECTION
}
