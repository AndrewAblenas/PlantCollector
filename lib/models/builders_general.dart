import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/screens/library/widgets/group_delete.dart';
import 'package:plant_collector/screens/library/widgets/collection_card.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/screens/library/widgets/group_card.dart';
import 'package:plant_collector/widgets/dialogs/color_picker/button_color.dart';
import 'package:plant_collector/widgets/dialogs/select/dialog_functions.dart';
import 'package:plant_collector/widgets/dialogs/select/dialog_select.dart';
import 'package:plant_collector/screens/account/widgets/settings_card.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/screens/plant/widgets/plant_info_card.dart';
import 'package:plant_collector/screens/plant/widgets/plant_photo.dart';
import 'package:date_format/date_format.dart';
import 'package:plant_collector/screens/plant/widgets/add_photo.dart';

class UIBuilders extends ChangeNotifier {
  //*****************VARIABLES*****************//

  String selectedDialogButton;
  List groupCollections = [];
  bool loadingIndicator;

  //*****************LIBRARY PAGE RELATED BUILDERS*****************

  //Delay build of stat cards until streams have updated and saved value to local
  //this is only an issue on first load as the streams are located lower in the tree
  Future<String> statCardDelay() async {
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    return 'Done';
  }

  //Generate Group widgets
  Column displayGroups(
      {@required List<Map> userGroups, @required bool connectionLibrary}) {
    List<Widget> groupList = [];
    Column groupColumn;
    if (userGroups != null) {
      userGroups.sort((a, b) => (a[kGroupOrder]).compareTo((b[kGroupOrder])));
      for (Map group in userGroups) {
        groupList.add(
          GroupCard(
            connectionLibrary: connectionLibrary,
            group: group,
            groups: userGroups,
          ),
        );
      }
      groupColumn = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: groupList,
      );
    } else {
      groupColumn = Column(
        children: <Widget>[SizedBox()],
      );
    }
    return groupColumn;
  }

  //GENERATE COLLECTION WIDGETS
  Column displayCollections(
      {@required List<Map> userCollections,
      @required String groupID,
      @required Color groupColor,
      @required bool connectionLibrary}) {
    List<CollectionCard> collectionList = [];
    Column collectionColumn;
    if (userCollections != null && userCollections.length > 0) {
      for (Map collection in userCollections) {
        //add collection card for each collection
        collectionList.add(
          makeCollectionCard(
              connectionLibrary: connectionLibrary,
              collection: collection,
              collectionTheme: groupColor,
              groupID: groupID),
        );
      }
      collectionColumn = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: collectionList,
      );
    } else if (userCollections == null ||
        userCollections.length == 0 && connectionLibrary == false) {
      //check if in a group and add delete button
      collectionColumn = Column(
        children: <Widget>[
          groupID == null ? null : GroupDelete(groupID: groupID),
        ],
      );
    }
    return collectionColumn;
  }

  //MAKE COLLECTION CARD
  CollectionCard makeCollectionCard(
      {@required bool connectionLibrary,
      @required Map collection,
      @required Color collectionTheme,
      @required String groupID}) {
    //get plant list
    List<dynamic> plantList = collection[kCollectionPlantList];
    //initialize number of plants in collection to No Plants
    int collectionPlantTotal = 0;
    //if the plant list isn't empty
    if (plantList.isNotEmpty) {
      //then get the number of plants
      collectionPlantTotal = plantList.length;
    }
    //return card
    return CollectionCard(
      connectionLibrary: connectionLibrary,
      collection: collection,
      collectionPlantTotal: collectionPlantTotal,
      colorTheme: collectionTheme,
      groupID: groupID,
    );
  }

//*****************PLANT SCREEN RELATED BUILDERS*****************

  //GENERATE IMAGE TILE LIST FOR THE CAROUSEL
  List<Widget> generateImageTileWidgets(
      {@required bool connectionLibrary,
      @required String plantID,
      @required List<dynamic> listURL,
      @required String thumbnail}) {
    //initialize the widget list
    List<Widget> imageTileList = [];
    //check to make sure list is not null
    if (listURL != null) {
      //look through list
      for (String url in listURL) {
        //get date from image name (more efficient than meta?)
        String frontRemoved = url.split('_image_')[1];
        String epochSeconds = frontRemoved.split('.jpg')[0];
        print(epochSeconds);
        String date = formatDate(
            DateTime.fromMillisecondsSinceEpoch(int.parse(epochSeconds)),
            [MM, ' ', d, ', ', yyyy]);
        //create image tiles
        imageTileList.add(
          PlantPhoto(
              connectionLibrary: connectionLibrary,
              imageURL: url,
              imageDate: date),
        );
      }
    } else {}
    //add an image add button to the list
    if (connectionLibrary == false) {
      imageTileList.add(
        AddPhoto(
          plantID: plantID,
        ),
      );
    }
    print('generateImageTileWidgets: COMPLETE');
    return imageTileList;
  }

  //REFORMAT PLANT INFO TO SHARE
  String sharePlant({@required Map plantMap}) {
    String plantShare;
    if (plantMap != null) {
      List<String> keyList = kPlantKeyDescriptorsMap.keys.toList();
      keyList.remove(kPlantID);
      keyList.remove(kPlantThumbnail);
      keyList.remove(kPlantImageList);
      for (String key in keyList)
        if (plantMap[key] != null) {
          if (plantShare == null) {
            plantShare = '${kPlantKeyDescriptorsMap[key]}: ${plantMap[key]}\n';
          } else {
            plantShare = plantShare +
                '${kPlantKeyDescriptorsMap[key]}: ${plantMap[key]}\n';
          }
        }
    }
    return plantShare + 'Shared via Plant Collector\n<future app store link>';
  }

  //GENERATE INFO CARD WIDGETS
  Column displayInfoCards(
      {@required bool connectionLibrary,
      @required String plantID,
      @required Map plant}) {
    //create blank list to hold info card widgets
    List<Widget> infoCardList = [];
    //create a list of all key values possible
    List<String> keyList = kPlantKeyDescriptorsMap.keys.toList();
    //remove what you don't want the user to see/edit
    keyList.remove(kPlantID);
    keyList.remove(kPlantThumbnail);
    keyList.remove(kPlantImageList);
    //need this to deal with issues on plant delete
    if (plant != null) {
      //for  all these strings in the list
      for (String key in keyList) {
        //check to see that they aren't set to default value (hidden)
        if (plant[key] != null) {
          //if not default then create a widget and add to the list
          String displayLabel = kPlantKeyDescriptorsMap[key];
          String displayText = plant[key];
          infoCardList.add(
            PlantInfoCard(
              connectionLibrary: connectionLibrary,
              plantID: plantID,
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
          buttonColor: kGreenDark,
          dialog: DialogSelect(
            title: 'Add Information',
            text: 'Please select the type of new information below:',
            plantID: plantID,
            menuItems: createDialogWidgetList(plantID: plantID, plant: plant),
          ),
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

//*****************ACCOUNT SCREEN RELATED BUILDERS*****************

//GENERATE ACCOUNT TILE
  Column displayAccountCards({@required Map accountInfo}) {
    Column column;
    if (accountInfo != null) {
      //create blank list for widgets
      List<Widget> accountCardList = [];
      //create a key list
      List<String> keyList = kUserKeyDescriptorsMap.keys.toList();
      keyList.remove(kUserID);
      for (String value in keyList) {
        String displayLabel = kUserKeyDescriptorsMap[value];
        String displayText = accountInfo[value].toString();
        accountCardList.add(
          SettingsCard(
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
  List<Widget> createDialogGroupButtons({
    @required String selectedItemID,
    @required String currentParentID,
    @required List<dynamic> possibleParents,
  }) {
    List<Widget> widgetList = [];
    for (Map group in possibleParents) {
      if (!group.containsValue(currentParentID)) {
        widgetList.add(
          DialogItemGroup(
            buttonText: group[kGroupName],
            buttonPossibleParentID: group[kGroupID],
            entryID: selectedItemID,
            currentParentID: currentParentID,
          ),
        );
      }
    }
    return widgetList;
  }

//Dialog buttons to move Plant to different Collection
  List<Widget> createDialogCollectionButtons({
    @required String selectedItemID,
    @required String currentParentID,
    @required List<dynamic> possibleParents,
  }) {
    List<Widget> widgetList = [];
    for (Map collection in possibleParents) {
      if (!collection.containsValue(currentParentID)) {
        widgetList.add(
          DialogItemCollection(
            buttonText: collection[kCollectionName],
            buttonPossibleParentID: collection[kCollectionID],
            entryID: selectedItemID,
            currentParentID: currentParentID,
          ),
        );
      }
    }
    return widgetList;
  }

//Create color buttons
  List<Widget> colorButtonsList(
      {@required List<Color> colors,
      @required Function onPress,
      @required groupID}) {
    List<Widget> list = [];
    for (Color color in colors) {
      list.add(ButtonColor(
        color: color,
        onPress: onPress,
        groupID: groupID,
      ));
    }
    return list;
  }

//CREATE PLANT LIST BUTTONS
  List<Widget> createDialogWidgetList(
      {@required String plantID, @required Map plant}) {
    //create a blank list to populate with widgets
    List<Widget> listItems = [];
    //create list of all plant keys in the constant map
    List list = kPlantKeyDescriptorsMap.keys.toList();
    list.remove(kPlantThumbnail);
    //create list of plant keys not displayed in plant screen
    List<String> plantKeysNotDisplayed = [];
    //needed for delete plant to prevent null[] call
    if (plant != null) {
      for (String key in list) {
        if (plant[key] == null || !plant.containsKey(key)) {
          plantKeysNotDisplayed.add(key);
        }
      }
    }
    plantKeysNotDisplayed.remove(kPlantImageList);
    for (String key in plantKeysNotDisplayed) {
      listItems.add(
        DialogItemPlant(
          buttonKey: key,
          buttonText: kPlantKeyDescriptorsMap[key],
          plantID: plantID,
        ),
      );
    }
    return listItems;
  }

  //END OF SECTION
}
