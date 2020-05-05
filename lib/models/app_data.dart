import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/models/data_types/message_data.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';

class AppData extends ChangeNotifier {
  //Plant Library Variables
//  String newPlantVariety;
//  String currentPlantID;
  //Collection Library variablesFav
  String newDataInput;
  List newListInput;
  int newListInputIndex;
//  String selectedDialogButtonItem;
//  bool hideButton;
  //Discover Page state - Custom Tabs
  int customFeedSelected;
  Type customFeedType;
  String customFeedQueryField;
  //Search Page state - Tab Bar Top
  int tabBarTopSelected;
  //Search Page - Selected Fields
  Map<String, dynamic> searchQueryInput = {};
  //search bar live input
  String searchBarLiveInput;
  //Custom Tabs
  int customTabSelected;
  String plantQueryField;
  //used to pass ID to image tile
  String forwardingPlantID;
//  File cameraCapture;
//  List<File> imageFileList;
//  String localPathSaved;
  //Formatting
  Column collectionColumn = Column();
  //current user
  List<GroupData> currentUserGroups;
  List<CollectionData> currentUserCollections;
  List<PlantData> currentUserPlants;
  UserData currentUserInfo;
  UserData connectionUserInfo;
  //connection
  List<GroupData> connectionGroups;
  List<CollectionData> connectionCollections;
  List<PlantData> connectionPlants;
  //tips
  bool showTips;

  //*****************VALIDATE USERNAME*****************//

  //One Capital Letter, One Small Letter
  static bool validateUsernameContents(String username) {
    String pattern = r'^[a-z0-9_.]+$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(username);
  }

  //PASSWORD LENGTH
  static bool validateUsernameLength(String username) {
    bool state;
    if (username != null) {
      (username.length >= 3 && username.length <= 20)
          ? state = true
          : state = false;
    } else {
      state = false;
    }
    return state;
  }

  //*****************SIGN OUT CLEAR DATA*****************//

  void clearAppData() {
    //to be used at logout

    //Collection Library variablesFav
    newDataInput = null;
    //Discover Page state - Custom Tabs
    customFeedSelected = null;
    customFeedType = null;
    customFeedQueryField = null;
    //Search Page state - Tab Bar Top
    tabBarTopSelected = null;
    //Search Page - Selected Fields
    searchQueryInput = {};
    //search bar live input
    searchBarLiveInput = null;
    //Custom Tabs
    customTabSelected = null;
    plantQueryField = null;
    //used to pass ID to image tile
    forwardingPlantID = null;
    //Formatting
    collectionColumn = Column();
    //current user
    currentUserInfo = null;
    currentUserGroups = null;
    currentUserCollections = null;
    currentUserPlants = null;
    //connection
    connectionUserInfo = null;
    connectionGroups = null;
    connectionCollections = null;
    connectionPlants = null;
    //tips
    showTips = null;
  }

  //*****************NOTIFICATIONS*****************//

  List<dynamic> getFriendsList() {
    if (currentUserInfo != null) {
      List<dynamic> friendsList = currentUserInfo.friends;
      return friendsList;
    } else {
      return [];
    }
  }

  //*****************NOTIFICATIONS*****************//

  FlutterLocalNotificationsPlugin notifications;

  //*****************CHAT RELATED*****************//

  //decide whether or not to show tips
  void showTipsHelpers() {
    if (currentUserCollections != null) {
      int filteredTotal = 0;
      for (CollectionData collection in currentUserCollections) {
        if (DBDefaultDocument.collectionAutoGen.contains(collection.id)) {
          filteredTotal++;
        }
      }
      showTips = (filteredTotal < 3);
    }
  }

  //*****************CHAT RELATED*****************//

  //chat
  String currentChatId;

  //set current chat Id
  void setCurrentChatId({@required String connectionID}) {
    currentChatId = connectionID;
  }

  //get current chat Id
  String getCurrentChatId() {
    return currentChatId;
  }

//*****************CREATE DIRECTORIES*****************

  //Take the returned user ID and set it as a static to use in directory paths
//  void setUserID({String userID}) {
//    if (userID != null) {
//      userID = userID;
//      userIDStatic = userID;
//    } else {
//      userIDStatic = 'default';
//    }
//  }
//
//  void setConnectionID({String userID}) {
//    if (userID != null) {
//      userID = userID;
//      userIDStatic = userID;
//    } else {
//      userIDStatic = 'default';
//    }
//  }

//  Future createDirectories({@required String user}) async {
//    //get the relative path
//    String path = await _localPath;
//
//    //generate the plant folder string
//    pathPlants = '$path/$kFolderUsers/$user/$kFolderPlants';
//    //create directory
//    await new Directory(pathPlants).create(recursive: true);
//
//    //generate the user folder string
//    pathSettings = '$path/$kFolderUsers/$user/$kFolderSettings';
//    //create directory
//    await new Directory(pathSettings).create(recursive: true);
//
//    //create user file
//    await new File('$pathSettings/user.txt').create(recursive: true);
//  }

  //save user file
//  Future<void> userFileSave(User user) async {
//    //await the local path
//    String path = await _localPath;
//    //generate the user file string
//    pathSettings = '$path/$kFolderUsers/$user/$kFolderSettings/user.txt';
//    //encode user
//    String encoded = jsonEncode(user.toMap());
//    //save encoded
//    File(pathSettings).writeAsStringSync(encoded);
//  }

  //LOCAL PATH
//  Future<String> get _localPath async {
//    final directory = await getApplicationDocumentsDirectory();
//    localPathSaved = directory.path;
//    return directory.path;
//  }

  //get user file
//  Future<User> userFileGet(String user) async {
//    //await the local path
//    String path = await _localPath;
//    //generate the user file string
//    pathSettings = '$path/$kFolderUsers/$user/$kFolderSettings/user.txt';
//    //
//    Map<String, dynamic> file =
//        jsonDecode(await File(pathSettings).readAsString());
////create user from map
//    return userFromMap(userMap: file);
//  }

  //*****************CAMERA/IMAGE/FOLDER METHODS*****************

  //METHOD TO DELETE PLANT FOLDER
//  Future<void> folderPlantDelete({@required plantID}) async {
//    Directory folder = Directory('$pathPlants/$plantID');
//    folder.delete(recursive: true);
//  }

  //*****************GROUP METHODS*****************

  //METHOD TO CREATE NEW Group
  GroupData createGroup() {
    String generateGroupID = generateID(prefix: 'group_');
    String newCollectionName = newDataInput;
    final group = GroupData(
      id: generateGroupID,
      name: newCollectionName,
      collections: [],
      order: 0,
      color: [],
    );
    return group;
  }

  //*****************COLLECTION METHODS*****************

  //METHOD TO CREATE NEW COLLECTION
  CollectionData newCollection() {
    String generateCollectionID = generateID(prefix: 'collection_');
    String newCollectionName = newDataInput;
    final collection = CollectionData(
      id: generateCollectionID,
      name: newCollectionName,
      plants: [],
      creator: null,
      color: [],
    );
    return collection;
  }

  //*****************PLANT METHODS*****************

  //METHOD TO CREATE NEW PLANT
  Map plantNew({@required String collectionID}) {
    String newPlantID = generateID(prefix: 'plant_');
    Map<String, dynamic> plant = PlantData(
      id: newPlantID,
      name: newDataInput,
      owner: currentUserInfo.id,
      created: DateTime.now().millisecondsSinceEpoch,
      isVisible: false,
      want: (collectionID == DBDefaultDocument.wishList) ? true : false,
      sell: (collectionID == DBDefaultDocument.sellList) ? true : false,
    ).toMap();
    return plant;
  }

  //METHOD TO CREATE NEW DEFAULT COLLECTION
  static CollectionData newDefaultCollection(
      {@required String collectionID, String collectionName}) {
    final collection = CollectionData(
      id: collectionID,
      name: (collectionName == null) ? collectionID : collectionName,
      plants: [],
      creator: null,
      color: [],
    );
    return collection;
  }

  //create message
  static MessageData createMessage(
      {@required String text,
      @required String type,
      @required String media,
      @required senderID}) {
    return MessageData(
        sender: senderID,
        time: DateTime.now().millisecondsSinceEpoch,
        text: text,
        read: false,
        type: type,
        media: media);
  }

  //get an individual map given an ID from a list of maps
  static Map getDocumentFromList(
      {@required List<Map> documents, @required String value}) {
    Map match;
    if (documents != null) {
      for (Map document in documents) {
        if (document.containsValue(value)) {
          match = document;
        }
      }
    }
    return match;
  }

  //generate map to insert data to db (when value isn't from user input)
  static Map<String, dynamic> updatePairFull(
      {@required String key, @required value}) {
    return {key: value};
  }

  //GET VALUE FROM MAP
  static String getValue({@required Map data, @required String key}) {
    String value;
    if (data != null) {
      value = data[key];
    } else {
      value = null;
    }
    return value;
  }

  //GET IMAGE COUNT
  static String getImageCount({@required List<Map> plants}) {
    int imageCount;
    if (plants != null) {
      for (Map plant in plants) {
        List images = plant[PlantKeys.images];
        if (images != null) {
          imageCount = (imageCount == null ? 0 : imageCount + images.length);
        } else {}
      }
    } else {
      imageCount = 0;
    }
    print('getImageCount: Complete');
    return imageCount == null ? '0' : imageCount.toString();
  }

  //clean plant to clone
  static Map cleanPlant({
    @required Map plantData,
    @required String newPlantID,
    @required String newUserID,
  }) {
    PlantData plant = PlantData(
        id: newPlantID,
        name: plantData[PlantKeys.name],
        genus: plantData[PlantKeys.genus],
        species: plantData[PlantKeys.species],
        variety: plantData[PlantKeys.variety],
        thumbnail: plantData[PlantKeys.thumbnail],
        owner: newUserID,
        created: timeNowMS(),
        //not visible until new images added
        isVisible: false);

    return plant.toMap();
  }

  //get time now in MS
  static timeNowMS() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static List<String> orphanedPlantCheck({
    @required List<CollectionData> collections,
    @required List<PlantData> plants,
  }) {
    //LOOK TO SEE IF ANY USER PLANTS AREN'T LISTED IN THE USER COLLECTIONS
    List<String> orphaned = [];
    if (collections != null && plants != null) {
      List<String> collectionPlantIDs = [];
      for (CollectionData collection in collections) {
        collectionPlantIDs.addAll(collection.plants.cast());
      }
      for (PlantData plant in plants) {
        if (!collectionPlantIDs.contains(plant.id)) {
          orphaned.add(plant.id);
        }
      }
    }
    return orphaned;
  }

  //pack user feedback
  static Map userFeedback({
    @required String date,
    @required String title,
    @required String text,
    @required String type,
    @required String platform,
    @required String userID,
    @required String userEmail,
  }) {
    return {
      'date': date,
      'title': title,
      'text': text,
      'type': type,
      'platform': platform,
      'userID': userID,
      'userEmail': userEmail,
    };
  }

  //generate list of plants for Shelf
  static List<PlantData> getPlantsFromList(
      {@required List<dynamic> collectionPlantIDs,
      @required List<PlantData> plants}) {
    List<PlantData> collectionPlants = [];
    if (collectionPlantIDs != null && plants != null) {
      for (String ID in collectionPlantIDs) {
        for (PlantData plant in plants) {
          if (plant.id == ID) {
            collectionPlants.add(plant);
          }
        }
      }
    }
    return collectionPlants;
  }

  //METHOD TO GENERATE A NEW ID
  static String generateID({@required String prefix}) {
    String newPlantID =
        prefix + DateTime.now().millisecondsSinceEpoch.toString();
    return newPlantID;
  }

  static String feedbackDate() {
    return formatDate(
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch),
        [yyyy, '-', mm, '-', dd]);
  }

  static bool isNew({@required String idWithTime}) {
    List split = idWithTime.split('_');
    int time = int.parse(split[1]);
    //consider new if less than three days old
    return DateTime.now().millisecondsSinceEpoch - time <= 86400000 * 3;
  }

  static bool isRecentUpdate({@required int lastUpdate}) {
    //consider recent update if less than three days old
    return DateTime.now().millisecondsSinceEpoch - lastUpdate <= 86400000 * 3;
  }

  //get days and make list
  static int daysInMonth({@required int month}) {
    int totalDays;
    List<int> months30 = [4, 6, 9, 11];
    if (month == 2) {
      totalDays = 28;
    } else if (months30.contains(month)) {
      totalDays = 30;
    } else {
      totalDays = 31;
    }
    return totalDays;
  }

  //*****************JOURNAL METHODS*****************

  //CREATE JOURNAL ENTRY
  JournalData journalNew({@required String title}) {
    String date = generateID(prefix: '');
    String id = 'entry_' + date;
    JournalData entry =
        JournalData(id: id, date: date, title: title, entry: null);
    return entry;
  }

  //*****************BUILDER FUNCTIONS AND RELATED*****************

  void notify() {
    notifyListeners();
  }

//METHOD TO SET NEW DATA INPUT
  void setInputNewData(value) {
    newDataInput = value;
    notifyListeners();
  }

  //METHOD TO SET LIST INPUT
  void setInputNewList({@required int index, @required value}) {
    newListInput[index] = value;
    notifyListeners();
  }

  //METHOD TO SET NEW DATA INPUT SEARCH BAR LIVE
  void setInputSearchBarLive(value) {
    searchBarLiveInput = value;
    notifyListeners();
  }

  //METHOD TO SET CUSTOM TAB INPUT
  void setInputCustomTabSelected({@required int tabNumber}) {
    customTabSelected = tabNumber;
    notifyListeners();
  }

  void setTabBarTopSelected({@required int tabNumber}) {
    tabBarTopSelected = tabNumber;
    notifyListeners();
  }

  void setCustomFeedSelected({
    @required int selectedNumber,
    @required Type selectedType,
    @required String selectedQueryField,
  }) {
    customFeedSelected = selectedNumber;
    customFeedType = selectedType;
    customFeedQueryField = selectedQueryField;
    notifyListeners();
  }

  //METHOD TO SET CUSTOM TAB QUERY FIELD
  void setPlantQueryField({@required String queryField}) {
    plantQueryField = queryField;
    notifyListeners();
  }

  //METHOD TO GET PLANT TILE THUMB
  static Widget getPlantTileThumb({@required String thumbURL}) {
    try {
      return CachedNetworkImage(
          imageUrl: thumbURL,
          fit: BoxFit.cover,
          errorWidget: (context, error, _) {
            return Image.asset(
              'assets/images/default.png',
              fit: BoxFit.fill,
            );
          });
    } catch (e) {
      print(e);
      return Image.asset(
        'assets/images/default.png',
        fit: BoxFit.fill,
      );
    }
  }

  //GENERATE IMAGE TILE WIDGET LIST
//  List<Widget> createImageTileList({String plantID}) {
//    //initialize the widget list
//    List<Widget> imageTileList = [];
//    //access imageFileList saved on plant tile press
//    List<File> imageFiles = imageFileList;
//    //check to make sure file is not null
//    if (imageFiles != null) {
//      //look through list
//      for (File file in imageFiles) {
//        //split off the extension
//        List splitExtension = p.basename(file.path).split('.');
//        //split the file name at underscores to get seconds since epoch
//        List splitList = splitExtension[0].toString().split('_');
//        //the format is collection_****_plant_TIMEDATE so take index 3 for ms since epoch
//        int sinceEpoch = int.parse(splitList[3]);
//        //turn into a date
//        DateTime imageDate = DateTime.fromMillisecondsSinceEpoch(sinceEpoch);
//        //convert into a more readable string
//        String date = formatDate(imageDate, [MM, ' ', d, ', ', yyyy]);
//        //create image tiles
//        imageTileList.add(
//          TileImage(imageURL: file, imageDate: date),
//        );
//      }
//    } else {}
//    //add an image add button to the list
//    imageTileList.add(ButtonAddImage(plantID: plantID));
//    print('createImageTileList: COMPLETE');
//    return imageTileList;
//  }

  //*****************APP DATA SECTION END*****************
}
