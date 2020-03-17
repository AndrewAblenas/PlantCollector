import 'dart:core';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';

class AppData extends ChangeNotifier {
  //Plant Library Variables
  String newPlantVariety;
  String currentPlantID;
  //Collection Library variablesFav
  String newDataInput;
  String selectedDialogButtonItem;
  bool hideButton;
  //custom tabs
  int customTabSelected;
  String plantQueryField;
  //used to pass ID to image tile
  String forwardingPlantID;
  File cameraCapture;
  List<File> imageFileList;
  String localPathSaved;
  bool loadingStatus;
  //Formatting
  Column collectionColumn = Column();
  //path and directories
  String pathPlants;
  String pathSettings;
  //stream savers
  //current user
  List<GroupData> currentUserGroups;
  List<CollectionData> currentUserCollections;
  List<PlantData> currentUserPlants;
  UserData currentUserInfo;
  UserData connectionUserInfo;
  bool showTips;
  //connection
  List<GroupData> connectionGroups;
  List<CollectionData> connectionCollections;
  List<PlantData> connectionPlants;
  //*****************NOTIFICATIONS*****************//

  FlutterLocalNotificationsPlugin notifications;

  //*****************CHAT RELATED*****************//

  //decide whether or not to show tips
  void showTipsHelpers() {
    showTips = (currentUserGroups != null &&
        (currentUserGroups.length < 3 || currentUserCollections.length < 3));
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
  Future<void> folderPlantDelete({@required plantID}) async {
    Directory folder = Directory('$pathPlants/$plantID');
    folder.delete(recursive: true);
  }

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
    );
    return collection;
  }

  //*****************PLANT METHODS*****************

  //METHOD TO CREATE NEW PLANT
  PlantData plantNew() {
    String newPlantID = generateID(prefix: 'plant_');
    final plant = PlantData(
      id: newPlantID,
      name: newDataInput,
      owner: currentUserInfo.id,
    );
    return plant;
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

//METHOD TO SET NEW DATA INPUT
  void setNewDataInput(value) {
    newDataInput = value;
    notifyListeners();
  }

  //METHOD TO SET CUSTOM TAB INPUT
  void setCustomTabSelected({@required int tabNumber}) {
    customTabSelected = tabNumber;
    notifyListeners();
  }

  //METHOD TO SET CUSTOM TAB QUERY FIELD
  void setPlantQueryField({@required String queryField}) {
    plantQueryField = queryField;
    notifyListeners();
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
