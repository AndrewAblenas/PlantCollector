import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant/bloom_data.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/communication_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/models/data_types/plant/growth_data.dart';
import 'package:plant_collector/models/data_types/plant/image_data.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/dialog/dialog_item_bloom.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_select.dart';
import 'package:plant_collector/screens/library/widgets/collection_card.dart';
import 'package:plant_collector/screens/plant/widgets/add_journal_button.dart';
import 'package:plant_collector/screens/plant/widgets/journal_tile.dart';
import 'package:plant_collector/screens/plant/widgets/plant_flowering.dart';
import 'package:plant_collector/screens/plant/widgets/plant_photo_default.dart';
import 'package:plant_collector/screens/search/widgets/search_tile_plant.dart';
import 'package:plant_collector/widgets/dialogs/color_picker/button_color.dart';
import 'package:plant_collector/widgets/dialogs/select/dialog_functions.dart';
import 'package:plant_collector/screens/account/widgets/settings_card.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/screens/plant/widgets/plant_info_card.dart';
import 'package:plant_collector/screens/plant/widgets/plant_photo.dart';
import 'package:date_format/date_format.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:plant_collector/widgets/tile_white.dart';

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

  //build icons
  static Icon communicationDataIcon(
      {@required String type, @required double size}) {
    Icon icon;
    if (type == CommunicationTypes.standard) {
      icon = Icon(
        Icons.message,
        color: kGreenDark,
        size: size,
      );
    } else if (type == CommunicationTypes.alert) {
      icon = Icon(
        Icons.error,
        color: Colors.orange,
        size: size,
      );
    } else if (type == CommunicationTypes.warning) {
      icon = Icon(
        Icons.warning,
        color: Colors.red,
        size: size,
      );
    } else {
      icon = Icon(
        Icons.message,
        color: kGreenDark,
        size: size,
      );
    }
    return icon;
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
            plant.hybrid.toLowerCase().contains(searchInput) ||
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
  static Column displayCollections({
    @required List<CollectionData> userCollections,
    @required String groupID,
    @required Color groupColor,
    @required bool connectionLibrary,
    @required UserData user,
  }) {
    //check that they aren't default
    List<Widget> collectionList = [];
    Column collectionColumn;
    //make sure that there are collections in the list
    if (userCollections != null && userCollections.length > 0) {
      //sort if needed
      if (user.sortAlphabetically == true) {
        userCollections.sort((a, b) => (a.name).compareTo((b.name)));
      }
      for (CollectionData collection in userCollections) {
        //connection view check for defaults
        bool defaultView =
            DBDefaultDocument.collectionHideEmpty.contains(collection.id);
        //hide default collections when empty
        bool hidePublicNoPlants =
            ((defaultView == true && collection.plants.length == 0));
        //user can decide to hide sell and wish lists
        bool hideUserChoice = (user.showSellList == false &&
                collection.id == DBDefaultDocument.sellList) ||
            (user.showWishList == false &&
                collection.id == DBDefaultDocument.wishList);
        if (hidePublicNoPlants == false && hideUserChoice == false) {
          //add collection card for each collection
          collectionList.add(
            CollectionCard(
              connectionLibrary: connectionLibrary,
              defaultView: defaultView,
              collection: collection,
//      collectionPlantTotal: collectionPlantTotal,
              colorTheme: groupColor,
              groupID: groupID,
              showSellList: user.showSellList,
              showWishList: user.showWishList,
            ),
          );
        }
      }
      //set the column to return
      collectionColumn = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: collectionList,
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
      {@required String plantOwner,
      @required bool connectionLibrary,
      @required String plantID,
      @required List<ImageData> imageSets,
      @required String thumbnail,
      @required bool largeWidget}) {
    //initialize the widget list
    List<Widget> imageTileList = [];
    //check to make sure list is not null
    if (imageSets != null) {
      //look through list
      for (ImageData imageSet in imageSets) {
        //get date from image name (more efficient than meta?)
//        String frontRemoved = imageSet.full.split('_image_')[1];
//        String epochSeconds = frontRemoved.split('.jpg')[0];
        String date = formatDate(
            DateTime.fromMillisecondsSinceEpoch(imageSet.date),
            [MM, ' ', d, ', ', yyyy]);

        //create image tiles
        imageTileList.add(
          PlantPhoto(
            plantOwner: plantOwner,
            connectionLibrary: connectionLibrary,
            imageSet: imageSet,
            currentThumbnail: thumbnail,
            imageDate: date,
            largeWidget: largeWidget,
          ),
        );
      }
    } else {}
    //if nothing in the list add a blank placeholder
    //should only show on connection true with no photos
    if (imageTileList.length <= 0 && connectionLibrary == true)
      imageTileList.add(PlantPhotoDefault(largeWidget: largeWidget));
    print('generateImageTileWidgets: COMPLETE');
    return imageTileList;
  }

  //REFORMAT PLANT INFO TO SHARE
  static String sharePlant({@required Map plantMap}) {
    String plantShare = 'Check out this Plant!\n\n';
    if (plantMap != null) {
      for (String key in PlantKeys.listStringKeys)
        if (plantMap[key] != null && plantMap[key] != '') {
          plantShare =
              plantShare + '${PlantKeys.descriptors[key]}: ${plantMap[key]}\n';
        }
    }
    return plantShare + '\n${GlobalStrings.checkItOut}';
  }

  //FORMAT INFORMATION TO DISPLAY NAME PROPERLY
  static String formatPlantInfoCardText(
      {@required String type, @required String displayText}) {
    if (displayText != null && displayText != '') {
      if (type == PlantKeys.genus) {
        displayText = displayText[0].toUpperCase() + displayText.substring(1);
      } else if (type == PlantKeys.species) {
        displayText = displayText.toLowerCase();
      } else if (type == PlantKeys.hybrid) {
        List<String> splitList = displayText.split(' ');
        List<String> newList = [];
        for (String word in splitList) {
          word = word[0].toUpperCase() + word.substring(1);
          newList.add(word);
        }
        displayText = newList.join(' ');
      } else if (type == PlantKeys.variety) {
        List<String> splitList = displayText.split(' ');
        List<String> newList = [];
        for (String word in splitList) {
          word = word[0].toUpperCase() + word.substring(1);
          newList.add(word);
        }
        displayText = "'" + newList.join(' ') + "'";
      } else if (PlantKeys.listDatePickerKeys.contains(type)) {
        int integer = int.parse(displayText);
        DateTime date = DateTime.fromMillisecondsSinceEpoch(integer);
        displayText = formatDate(date, [MM, ' ', d, ', ', yyyy]);
      } else {
        displayText = displayText;
      }
    }
    return displayText;
  }

  //ITALICIZE PLANT NAME
  static bool italicizePlantName({@required String type}) {
    bool italicize = false;
    if (type == PlantKeys.genus || type == PlantKeys.species) {
      italicize = true;
    }
    return italicize;
  }

  static List<Widget> buildPlantName(
      {@required List<List<String>> substrings,
      @required BuildContext context}) {
    //passing a list with index 0 as key and 1 as value
    List<Widget> list = [];
    for (List<String> substring in substrings) {
      if (substring[1] != null && substring[1] != '') {
        String name = formatPlantInfoCardText(
            type: substring[0], displayText: substring[1]);
        bool italicize = italicizePlantName(type: substring[0]);
        Widget section = Container(
          child: Text(
            name,
            softWrap: true,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontStyle:
                  (italicize == true) ? FontStyle.italic : FontStyle.normal,
              color: AppTextColor.black,
              fontWeight: AppTextWeight.medium,
              fontSize: AppTextSize.tiny * MediaQuery.of(context).size.width,
            ),
          ),
        );
        list.add(section);
        list.add(SizedBox(
          width: 0.01 * MediaQuery.of(context).size.width,
        ));
      }
    }
    return list;
  }

  //GENERATE INFO CARD WIDGETS
  static Column displayInfoCards(
      {@required bool connectionLibrary,
      @required PlantData plant,
      @required BuildContext context}) {
    //create blank list to hold info card widgets
    List<Widget> infoCardList = [];
    //create list to hold combined name and bool to check each piece of data
    List<Widget> combinedNameList = [];
    bool showContainer = true;

    //create a list of only the keys you want visible
    List<String> keyList = PlantKeys.listVisibleKeys.toList();
    //remove bloom to show elsewhere
    keyList
        .removeWhere((item) => PlantKeys.listDateDayOfYearKeys.contains(item));

    //need null check to deal with issues on plant delete
    //connection library check will hide journal unless plant belongs to user
    if (plant != null) {
      Map plantMap = plant.toMap();

      //for  all these strings in the list
      for (String key in keyList) {
        //check to see that they aren't set to default value (hidden)
        if (plantMap[key] != null &&
            plantMap[key] != DefaultTypeValue.defaultString &&
            //default date acquired
            plantMap[key] != DefaultTypeValue.defaultInt) {
          //if not default then create a widget and add to the list
          String displayLabel = PlantKeys.descriptors[key];
          //display info differently depending on what it is
          String displayText = formatPlantInfoCardText(
            type: key,
            displayText: plantMap[key].toString(),
          );
          bool italicize = italicizePlantName(type: key);

          //save previous bool
          bool showContainerPrevious = showContainer;
          //get new bool
          showContainer = !PlantKeys.listPlantNameKeys.contains(key);
          //if show container is set to true then the sublist is complete
          //add this to the overall list appropriately wrapped
          if (showContainer == true &&
              showContainerPrevious == false &&
              combinedNameList.length > 0) {
            infoCardList.add(
              TileWhite(
                  bottomPadding: 0.0,
                  child: Column(
                    children: combinedNameList,
                  )),
            );
            //after add, reset list to blank
            combinedNameList = [];
          }

          Widget item = PlantInfoCard(
            showContainer: showContainer,
            dateCreated: plant.created,
            connectionLibrary: connectionLibrary,
            plantID: plant.id,
            cardKey: key.toString(),
            displayLabel: displayLabel,
            displayText: displayText,
            italicize: italicize,
          );

          (showContainer == true)
              ? infoCardList.add(item)
              : combinedNameList.add(item);
        }
      }
      //this is needed in case no none name fields follow
      //if nothing pulled the trigger and reset the list to empty
      if (combinedNameList.length > 0) {
        infoCardList.add(
          TileWhite(
              bottomPadding: 0.0,
              child: Column(
                children: combinedNameList,
              )),
        );
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
      {@required List journals,
      @required String plantID,
      @required bool connectionLibrary}) {
    //initialize blank list of widgets
    List<Widget> journalEntries = [];

    //create a journal entry for each item in list
    for (Map entry in journals) {
      JournalData entryBuild = JournalData.fromMap(map: entry);

      //allow the post to be edited only for 24hrs
      bool showEdit = false;
      if (connectionLibrary == false) {
        showEdit = (DateTime.now().millisecondsSinceEpoch -
                    int.parse(entryBuild.date) <=
                86400000)
            ? true
            : false;
      }

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
    //now include the add button only for user library
    journalEntries.add((connectionLibrary == false)
        ? AddJournalButton(plantID: plantID)
        : SizedBox());
    //add the header for all
    journalEntries.add(SectionHeader(
      title: 'JOURNAL',
    ));

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

  //Create date buttons
  static List<Widget> dateButtonsList(
      {@required List numbers, @required int index1, @required int index2}) {
    List<Widget> list = [];
    for (int number in numbers) {
      list.add(NumberButton(
        value: number,
        index1: index1,
        index2: index2,
      ));
    }
    return list;
  }

  //Build sequence widget
  static List<Widget> buildSequenceWidget({
    @required List<Map> sequenceData,
    @required Type dataType,
    @required String plantID,
    @required connectionLibrary,
  }) {
    //check data type

    //list to return to widgets
    List<Widget> list = [];

    //go through each entry in the blooms list
    for (Map sequence in sequenceData) {
      List<Widget> bloomList = [];
      int previousValue = 0;

      for (String key in sequence.keys.toList()) {
        int currentValue = sequence[key];
        if (previousValue != 0 && currentValue != 0) {
          int duration;
          if (currentValue > previousValue) {
            duration = currentValue - previousValue;
          } else if (currentValue == previousValue) {
            duration = 1;
          } else {
            duration = 365 + currentValue - previousValue;
          }
          Gradient gradient;
          //STYLING
          String label;
          //BLOOM RELATED
          if (key == BloomKeys.first) {
            gradient = kGradientGreenHorizontalDarkMedLight;
            label = 'Bud';
          } else if (key == BloomKeys.last) {
            gradient = kGradientGreenHorizontalLightMedDark;
            label = 'Bloom';
          } else if (key == BloomKeys.seed) {
            gradient = kGradientGreenSolidDark;
            label = 'Seed';
            //GROWTH RELATED
          } else if (key == GrowthKeys.mature) {
            gradient = kGradientGreenVerticalMedLight;
            label = 'Growing';
          } else if (key == GrowthKeys.dormant) {
            gradient = kGradientGreenVerticalDarkMed;
            label = 'Mature';
            //ELSE
          } else {
            gradient = kGradientGreenSolidDark;
            label = '';
          }
          Widget period = SequenceLine(
            duration: duration,
            gradient: gradient,
            label: label,
          );
          bloomList.add(period);
        }
        if (currentValue != 0) {
          String date = getDateFromDayOfYear(dayOfYear: currentValue);
          Widget dateWidget = SequenceDate(date: date);
          bloomList.add(dateWidget);
        }
        previousValue = (currentValue != 0) ? currentValue : previousValue;
      }
      Widget sequenceRow = (bloomList.length > 0)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: bloomList,
            )
          : Text(
              'tap to add details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: AppTextWeight.medium,
                color: AppTextColor.light,
              ),
            );
      list.add(FullSequence(
        plantID: plantID,
        connectionLibrary: connectionLibrary,
        sequenceRow: sequenceRow,
        sequenceMap: sequence,
        dataType: dataType,
      ));
    }
    return list;
  }

  //get days and make list
  static List<int> daysInMonth({@required int month}) {
    int totalDays;
    List<int> months30 = [4, 6, 9, 11];
    if (month == 2) {
      totalDays = 28;
    } else if (months30.contains(month)) {
      totalDays = 30;
    } else {
      totalDays = 31;
    }
    List<int> list = List<int>.generate(totalDays, (i) => i + 1);
    return list;
  }

  //get days and make list
  static String getDateFromDayOfYear({@required int dayOfYear}) {
    //return the index (month number)
    int index = DatesCustom.monthDayCutoffs
        .indexWhere((element) => (dayOfYear <= element));
    //get formatting for month number
    String month = DatesCustom.monthAbbreviations[index];
    //get the day number and format
    //day of year minus previous month cutoff
    String day =
        (dayOfYear - DatesCustom.monthDayCutoffs[index - 1]).toString();
    day = (day == '0') ? DatesCustom.monthDayCount[index].toString() : day;
    String formattedDate = month + '\n' + day;
    return formattedDate;
  }

  //get days and make list
  static int getMonthFromDayOfYear({@required int dayOfYear}) {
    int index = DatesCustom.monthDayCutoffs
        .indexWhere((element) => (dayOfYear <= element));
    return index;
  }

  static int getMonthDayFromDayOfYear({@required int dayOfYear}) {
    //get the month
    int index = getMonthFromDayOfYear(dayOfYear: dayOfYear);
    //day value is already in the month (month 12, day 0 = 365 day)
    if (DatesCustom.monthDayCutoffs[index] == dayOfYear) {
      return 0;
    } else {
      //get cutoff for previous month
      index = (index >= 1) ? (index - 1) : 0;
      //day of year minus previous month cutoff for day of month
      int day = (dayOfYear - DatesCustom.monthDayCutoffs[index]);
      day = (day == 0) ? DatesCustom.monthDayCount[index] : day;
      return day;
    }
  }

  static int getDayOfYear({@required int month, @required int day}) {
    //generate a list of months but exclude the last one
    if (day == 0) {
      return DatesCustom.monthDayCutoffs[month];
    } else if (month >= 1) {
      return DatesCustom.monthDayCutoffs[month - 1] + day;
    } else if (month == 0 && day == 0) {
      return 0;
    } else {
      return 0;
    }
  }

//CREATE PLANT LIST BUTTONS
  static List<Widget> createDialogWidgetList({@required PlantData plant}) {
    //create a blank list to populate with widgets
    List<Widget> listItems = [];
    //create list of all plant keys in the constant map
    List list = PlantKeys.listVisibleKeys;
//    list.remove(PlantKeys.thumbnail);
    //create list of plant keys not displayed in plant screen
    List<String> plantKeysNotDisplayed = [];
    //needed for delete plant to prevent null[] call
    if (plant != null) {
      Map plantMap = plant.toMap();
      for (String key in list) {
        if (plantMap[key] == DefaultTypeValue.defaultString ||
            plantMap[key] == DefaultTypeValue.defaultInt ||
            (PlantKeys.listDateDayOfYearKeys.contains(key) &&
                plantMap[key].length == 0) ||
            plantMap[key] == null) {
          plantKeysNotDisplayed.add(key);
        }
      }
    }
//    plantKeysNotDisplayed.remove(PlantKeys.images);
    for (String key in plantKeysNotDisplayed) {
      Map showListInput;
      if (key == PlantKeys.bloomSequence) {
        showListInput = BloomKeys.descriptors;
      }
      listItems.add(
        DialogItemPlant(
          showListInput: showListInput,
          timeCreated: plant.created,
          buttonKey: key,
          buttonText: PlantKeys.descriptors[key],
          plantID: plant.id,
        ),
      );
    }
    return listItems;
  }

  static List<Widget> generateDateButtons({@required Map map}) {
    List<Widget> widgets = [SizedBox()];
    List<String> keys = map.keys.toList();
    for (String key in keys) {
      int keyIndex = keys.indexOf(key);
      Widget widget = DayOfYearSelector(buttonText: map[key], index: keyIndex);
      widgets.add(widget);
    }
    return widgets;
  }
  //END OF SECTION
}
