import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_select.dart';
import 'package:plant_collector/screens/library/widgets/group_delete.dart';
import 'package:plant_collector/screens/library/widgets/collection_card.dart';
import 'package:plant_collector/screens/library/widgets/group_card.dart';
import 'package:plant_collector/screens/plant/widgets/clone_button.dart';
import 'package:plant_collector/screens/plant/widgets/journal_button.dart';
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

  //Generate Group widgets
  static Column displayGroups(
      {@required List<GroupData> userGroups,
      @required bool connectionLibrary}) {
    List<Widget> groupList = [];
    Column groupColumn;
    if (userGroups != null && userGroups.length >= 1) {
      userGroups.sort((a, b) => (a.order).compareTo((b.order)));
      for (GroupData group in userGroups) {
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
        children: <Widget>[
          InfoTip(
              text: 'You\'re Library is currently empty.  \n'
                  'Tap the "Create New Group" button below to get started.  ')
        ],
      );
    }
    return groupColumn;
  }

  //GENERATE COLLECTION WIDGETS
  static Column displayCollections(
      {@required List<CollectionData> userCollections,
      @required String groupID,
      @required Color groupColor,
      @required bool connectionLibrary}) {
    List<CollectionCard> collectionList = [];
    Column collectionColumn;
    if (userCollections != null && userCollections.length > 0) {
      for (CollectionData collection in userCollections) {
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
          InfoTip(
              text: 'Groups are used to organize your plant collections.  \n\n'
                  'You can rename this Group by holding down on the name.  Set the color by tapping the name.  \n\n'
                  'You can only delete a Group when it is empty, via the button below.'),
          groupID == null ? null : GroupDelete(groupID: groupID),
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

  //MAKE COLLECTION CARD
  static CollectionCard makeCollectionCard(
      {@required bool connectionLibrary,
      @required CollectionData collection,
      @required Color collectionTheme,
      @required String groupID}) {
    //get plant list
    List<dynamic> plantList = collection.plants;
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
        print(epochSeconds);
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
    print('generateImageTileWidgets: COMPLETE');
    return imageTileList;
  }

  //REFORMAT PLANT INFO TO SHARE
  static String sharePlant({@required Map plantMap}) {
    //TODO this needs to be greatly enhanced in how info is displayed
    String plantShare;
    if (plantMap != null) {
      List<String> keyList = PlantKeys.descriptors.keys.toList();
      keyList.remove(PlantKeys.id);
      keyList.remove(PlantKeys.thumbnail);
      keyList.remove(PlantKeys.images);
      for (String key in keyList)
        if (plantMap[key] != null) {
          if (plantShare == null) {
            plantShare = '${PlantKeys.descriptors[key]}: ${plantMap[key]}\n';
          } else {
            plantShare = plantShare +
                '${PlantKeys.descriptors[key]}: ${plantMap[key]}\n';
          }
        }
    }
    return plantShare + 'Shared via Plant Collector\n<future app store link>';
  }

  //GENERATE INFO CARD WIDGETS
  static Column displayInfoCards(
      {@required bool connectionLibrary,
      @required PlantData plant,
      @required BuildContext context}) {
    //create blank list to hold info card widgets
    List<Widget> infoCardList = [];
    //create a list of all key values possible
    List<String> keyList = PlantKeys.descriptors.keys.toList();
    //remove what you don't want the user to see/edit
    keyList.remove(PlantKeys.id);
    keyList.remove(PlantKeys.thumbnail);
    keyList.remove(PlantKeys.images);
    //need null check to deal with issues on plant delete
    //connection library check will hide journal unless plant belongs to user
    if (plant != null) {
      //first add a journal button
      infoCardList.add(
        connectionLibrary == false
            ? JournalButton(plant: plant)
            : CloneButton(plant: plant),
      );
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
          buttonColor: kGreenDark,
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
