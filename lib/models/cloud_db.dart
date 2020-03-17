import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/friend_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/models/data_types/message_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/request_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';

class CloudDB extends ChangeNotifier {
  //initialize Firestore instance
  static Firestore _db = Firestore.instance;
  //path variable
  static String usersPath = 'users';
  static String conversationsPath = 'conversations';
  static String messagesPath = 'messages';

  //variables
  String currentUserFolder;
  List<List<Map>> libraryBundle;
  String connectionUserFolder;

  //*****************INITIALIZE*****************//

  //this is to provide the user ID to this class
  void setUserFolder({@required String userID}) {
    currentUserFolder = userID;
  }

  //this is to provide the user ID to this class
  void setConnectionFolder({@required String connectionID}) {
    connectionUserFolder = connectionID;
  }

  //*****************REFERENCES*****************

  //expose the db
  DocumentReference getDB() {
    return _db.collection(usersPath).document(currentUserFolder);
  }

  //*****************STREAMS*****************

  //get a snapshot of the top user files
  Stream<DocumentSnapshot> streamMostPlants() {
    return _db
        .collection(DBFolder.app)
        .document(DBFolder.userStatsTop)
        .snapshots();
  }

  //get a snapshot of the top user files
  Future<DocumentSnapshot> streamCommunication() {
    try {
      return _db
          .collection(DBFolder.app)
          .document(DBDocument.communication)
          .get();
    } catch (e) {
      print(e);
      return null;
    }
  }

  //get a snapshot of the top user files
  Future<List<UserData>> userSearchExact({@required String input}) {
    String inputCap = input;
    inputCap[0].toUpperCase();
    try {
      return _db
          .collection(usersPath)
          .where(UserKeys.name, isEqualTo: input)
          .limit(50)
          .getDocuments()
          .then((snap) => snap.documents
              .map((doc) => UserData.fromMap(map: doc.data))
              .toList());
    } catch (e) {
      print(e);
      return null;
    }
  }

  //provide a stream of one specific plant document
  //NOTE userID is required as it may be from a connection in chat
  Stream<DocumentSnapshot> streamPlant(
      {@required String plantID, @required userID}) {
    return _db.collection(DBFolder.plants).document(plantID).snapshots();
  }

  //provide a stream of all user plants
  static Stream<List<PlantData>> streamPlantsData({@required userID}) {
    //stream
    Stream<QuerySnapshot> stream = _db
        .collection(DBFolder.plants)
        .where(PlantKeys.owner, isEqualTo: userID)
        .snapshots();
    //return specific data type
    return stream.map((snap) =>
        snap.documents.map((doc) => PlantData.fromMap(map: doc.data)).toList());
  }

  //*****************COMMUNITY STREAMS*****************

  //provide a stream to the top collectors document
  Stream<DocumentSnapshot> streamCommunityTopUsersByPlants() {
    return _db
        .collection(DBFolder.app)
        .document(DBFolder.userStatsTop)
        .snapshots();
  }

  Stream<List<PlantData>> streamCommunityPlantsTopDescending(
      {@required String field}) {
    //Provide a stream of the top plants sorted by field in descending order

    //stream
    Stream<QuerySnapshot> stream = _db
        .collection(DBFolder.plants)
        .orderBy(field, descending: true)
        .limit(45)
        .snapshots();
    //return specific data type
    return stream.map((snap) =>
        snap.documents.map((doc) => PlantData.fromMap(map: doc.data)).toList());
  }

  //provide a stream of all groups
//  Stream<QuerySnapshot> streamGroups({@required userID}) {
//    return _db
//        .collection(usersPath)
//        .document(userID)
//        .collection(DBFolder.groups)
//        .snapshots();
//  }

  //provide a stream of all groups
  static Stream<List<GroupData>> streamGroupsData({@required userID}) {
    //stream
    Stream<QuerySnapshot> stream = _db
        .collection(usersPath)
        .document(userID)
        .collection(DBFolder.groups)
        .snapshots();
    //return specific data type
    return stream.map((snap) =>
        snap.documents.map((doc) => GroupData.fromMap(map: doc.data)).toList());
  }

  //provide a stream of all collections
//  Stream<QuerySnapshot> streamCollections({@required userID}) {
//    return _db
//        .collection(usersPath)
//        .document(userID)
//        .collection(DBFolder.collections)
//        .snapshots();
//  }

  //provide a stream of all collections
  static Stream<List<CollectionData>> streamCollectionsData(
      {@required userID}) {
    //stream
    Stream<QuerySnapshot> stream = _db
        .collection(usersPath)
        .document(userID)
        .collection(DBFolder.collections)
        .snapshots();
    //return specific data type
    return stream.map((snap) => snap.documents
        .map((doc) => CollectionData.fromMap(map: doc.data))
        .toList());
  }

  //provide a stream of all collections
  static Future<List<CollectionData>> futureCollectionsData(
      {@required userID}) async {
    //stream
    QuerySnapshot snap = await _db
        .collection(usersPath)
        .document(userID)
        .collection(DBFolder.collections)
        .getDocuments();

    //return specific data type
    return snap.documents
        .map((item) => CollectionData.fromMap(map: item.data))
        .toList();
  }

  //provide a stream of requests
//  Stream<QuerySnapshot> streamRequests() {
//    return _db
//        .collection(usersPath)
//        .document(currentUserFolder)
//        .collection(DBFolder.requests)
//        .snapshots();
//  }

  //provide a stream of requests
  Stream<List<RequestData>> streamRequestsData() {
    //stream
    Stream<QuerySnapshot> stream = _db
        .collection(usersPath)
        .document(currentUserFolder)
        .collection(DBFolder.requests)
        .snapshots();
    //return specific data type
    return stream.map((snap) => snap.documents
        .map((doc) => RequestData.fromMap(map: doc.data))
        .toList());
  }

  //provide a stream of connections
//  Stream<QuerySnapshot> streamConnections() {
//    return _db
//        .collection(usersPath)
//        .document(currentUserFolder)
//        .collection(DBFolder.friends)
//        .snapshots();
//  }

  //provide a stream of friends
  Stream<List<FriendData>> streamFriendsData() {
    //stream
    Stream<QuerySnapshot> stream = _db
        .collection(usersPath)
        .document(currentUserFolder)
        .collection(DBFolder.friends)
        .snapshots();
    //return specific data type
    return stream.map((snap) => snap.documents
        .map((doc) => FriendData.fromMap(map: doc.data))
        .toList());
  }

  //provide a future of friends
  Future<List<UserData>> futureUsersData(
      {@required List<FriendData> friendList}) async {
    try {
      List<UserData> list = [];
      for (FriendData friend in friendList) {
        Map data = await getConnectionProfile(connectionID: friend.id);
        //ZIP in chat started data
        data[UserKeys.chatStarted] = friend.chatStarted;
        list.add(UserData.fromMap(map: data));
      }
      //return specific data type
      return list;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //provide a stream of messages for a specific conversation
  Stream<QuerySnapshot> streamConvoMessages({@required String connectionID}) {
    String document = conversationDocumentName(connectionId: connectionID);
    if (document != null) {
      return _db
          .collection(conversationsPath)
          .document(document)
          .collection(messagesPath)
          .orderBy(MessageKeys.time, descending: true)
          .limit(20)
          .snapshots();
    } else {
      return null;
    }
  }

  //NOT WORKING DELETE
  //check if messages exist
  bool messagesExist({@required String connectionID}) {
    String document = conversationDocumentName(connectionId: connectionID);
    if (document != null) {
      bool exists = true;
      _db.collection(conversationsPath).document(document).get().then(
        (DocumentSnapshot snap) {
          exists = snap.exists;
        },
      );
      return exists;
    } else {
      return false;
    }
  }

  //generate conversation document name
  String conversationDocumentName({@required String connectionId}) {
    if (connectionId != null) {
      List<String> list = [currentUserFolder, connectionId];
      list.sort((a, b) => (a).compareTo(b));
      return list[0] + '_' + list[1];
    } else {
      return null;
    }
  }

  //update item in user document array
  Future<void> updateUserArray(
      {@required bool action,
      @required List entries,
      @required String arrayKey}) async {
    if (entries != null)
    //create, write, and/or merge
    if (action == true) {
      return await _db
          .collection(usersPath)
          .document(currentUserFolder)
          .updateData({arrayKey: FieldValue.arrayUnion(entries)});
    } else if (action == false) {
      return await _db
          .collection(usersPath)
          .document(currentUserFolder)
          .updateData({arrayKey: FieldValue.arrayRemove(entries)});
    }
  }

  //provide a stream of user document
  static Stream<UserData> streamUserData({@required userID}) {
    Stream<DocumentSnapshot> stream =
        _db.collection(usersPath).document(userID).snapshots();
    //return specific data type
    return stream.map((doc) => UserData.fromMap(map: doc.data));
  }

  //provide a stream of user document
  static Future<UserData> futureUserData({@required userID}) async {
    DocumentSnapshot future =
        await _db.collection(usersPath).document(userID).get();
    //return specific data type
    return UserData.fromMap(map: future.data);
  }

  //create message
  MessageData createMessage(
      {@required String text, @required String type, @required String media}) {
    return MessageData(
        sender: currentUserFolder,
        time: DateTime.now().millisecondsSinceEpoch,
        text: text,
        read: false,
        type: type,
        media: media);
  }

  //send a message
  static Future<DocumentReference> sendMessage(
      {@required MessageData message, @required String document}) {
    //DB reference for message
    CollectionReference messagesRef = _db
        .collection(conversationsPath)
        .document(document)
        .collection(messagesPath);
    //make sure message sender and text exist
    if (message.sender != null && message.text != null) {
      //upload message to DB
      return messagesRef.add(
        message.toMap(),
      );
    } else {
      return null;
    }
  }

  //update message read status
  static Future<void> readMessage({@required String reference}) {
    return _db.document(reference).updateData({
      MessageKeys.read: true,
    });
  }

  //delete messages
  static Future<DocumentReference> deleteMessageHistory(
      {@required String document}) {
    if (document != null) {
      return _db
          .collection(conversationsPath)
          .document(document)
          .collection(messagesPath)
          .document()
          .delete();
    } else {
      return null;
    }
  }

  //*****************CONNECTION METHODS*****************//

  //search for user via email
  static Future<String> getUserFromEmail({@required String userEmail}) async {
    String match;
    if (userEmail != null) {
      //search through users to find matching email
      QuerySnapshot result = await _db
          .collection(usersPath)
          .where(UserKeys.email, isEqualTo: userEmail)
          .getDocuments();
      if (result.documents != null && result.documents.length > 0) {
        //there should only be one match, get and return ID
        match = result.documents[0].data[UserKeys.id];
      } else {
        match = null;
      }
    }
    return match;
  }

  //send connection request
  Future<bool> sendConnectionRequest({@required String connectionID}) async {
    bool success;
    if (connectionID != null) {
      UserData user = UserData.fromMap(map: (await getDB().get()).data);
      //search through users to find matching email
      try {
        await _db
            .collection(usersPath)
            .document(connectionID)
            .collection(DBFolder.requests)
            .document(currentUserFolder)
            .setData(
              user.toMap(),
            );
        success = true;
      } catch (e) {
        success = false;
      }
    }
    return success;
  }

  //Remove connection request
  Future removeConnectionRequest({@required String connectionID}) {
    return _db
        .collection(usersPath)
        .document(currentUserFolder)
        .collection(DBFolder.requests)
        .document(connectionID)
        .delete();
  }

  //Add reference to connection in user connection folder
  Future addConnectionDocument(
      {@required String pathID, @required String documentID}) {
    return _db
        .collection(usersPath)
        .document(pathID)
        .collection(DBFolder.friends)
        .document(documentID)
        .setData({
      UserKeys.id: documentID,
    });
  }

  //Update reference to connection in user connection folder
  Future updateConnectionDocument(
      {@required String pathID,
      @required String documentID,
      @required String key,
      @required value}) {
    return _db
        .collection(usersPath)
        .document(pathID)
        .collection(DBFolder.friends)
        .document(documentID)
        .setData(updatePairFull(key: key, value: value), merge: true);
  }

  //Accept connection request
  Future<bool> acceptConnectionRequest({@required String connectionID}) async {
    bool success;
    if (connectionID != null) {
      try {
        //create document for current user in connections
        await addConnectionDocument(
            pathID: currentUserFolder, documentID: connectionID);
        //remove document from current user requests
        await removeConnectionRequest(connectionID: connectionID);
        //create document for connection
        await addConnectionDocument(
            pathID: connectionID, documentID: currentUserFolder);
        //if completed
        success = true;
      } catch (e) {
        success = false;
      }
    }
    return success;
  }

  //get connection profile data
  Future<Map> getConnectionProfile({@required String connectionID}) async {
    return (await _db.collection(usersPath).document(connectionID).get()).data;
  }

  //remove connection
  void removeConnection({@required String connectionID}) {
    //remove from user records
    _db
        .collection(usersPath)
        .document(currentUserFolder)
        .collection(DBFolder.friends)
        .document(connectionID)
        .delete();
    //remove from connection records
    _db
        .collection(usersPath)
        .document(connectionID)
        .collection(DBFolder.friends)
        .document(currentUserFolder)
        .delete();
  }

  //*****************USER DOCUMENT SPECIFIC*****************//

  //create a user document and save to db upon registration
  Future<void> addUserDocument({@required Map data, @required String userID}) {
    //look into database instance, then collection, for ID, create if doesn't exist
    return _db.collection(usersPath).document(userID).setData(data);
  }

  //create a user document on registration and update in the future
  Future<void> updateUserDocument({@required Map data}) {
    //look into database instance, then collection, for ID, create if doesn't exist
    try {
      return _db
          .collection(usersPath)
          .document(currentUserFolder)
          .updateData(data);
    } catch (e) {
      return (e);
    }
  }

  //*****************HELPERS*****************

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

  //check if thumbnail is null (to load default image for plant tiles)
  bool hasThumbnail({@required String documentID}) {
    bool thumbnailFound;
    _db
        .collection(DBFolder.plants)
        .document(documentID)
        .get()
        .then((DocumentSnapshot data) {
      if (data.data[PlantKeys.thumbnail] == null) {
        thumbnailFound = false;
      } else {
        thumbnailFound = true;
      }
    });
    return thumbnailFound;
  }
  //*****************USER COLLECTION SPECIFIC*****************

  //clean plant to clone
  Map cleanPlant({
    @required Map plantData,
    @required String id,
  }) {
    PlantData plant = PlantData(
      id: id,
      name: plantData[PlantKeys.name],
      genus: plantData[PlantKeys.genus],
      species: plantData[PlantKeys.species],
      variety: plantData[PlantKeys.variety],
      bloom: plantData[PlantKeys.bloom],
      owner: currentUserFolder,
    );

    return plant.toMap();
  }

  //generate list of maps for Group
  static List<CollectionData> getMapsFromList(
      {@required List<dynamic> groupCollectionIDs,
      @required List<CollectionData> collections}) {
    List<CollectionData> groupCollections = [];
    if (groupCollectionIDs != null && collections != null) {
      for (String ID in groupCollectionIDs) {
        for (CollectionData collection in collections) {
          if (collection.id == ID) {
            groupCollections.add(collection);
          }
        }
      }
    }
    return groupCollections;
  }

  //generate list of plants for Group
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

  //*****************USER COLLECTION SPECIFIC*****************

  //query specific document in specific collection
  DocumentReference getCollectionDocumentRef(
      {@required String documentID, @required String collection}) {
    final DocumentReference docRef = _db
        .collection(usersPath)
        .document(currentUserFolder)
        .collection(collection)
        .document(documentID);
    return docRef;
  }

  //update a piece of data in a user collection (userPlants, userCollections, or userSets)
  Future<void> updateDocumentInCollection(
      {@required Map data,
      @required String collection,
      @required String documentName}) {
    //create, write, and/or merge
    return _db
        .collection(usersPath)
        .document(currentUserFolder)
        .collection(collection)
        .document(documentName)
        .updateData(data);
  }

  //update a piece of data in a other friend collection (userPlants, userCollections, or userSets)
  Future<void> updateDocumentInCollectionOther(
      {@required Map data,
      @required String collection,
      @required String documentName}) {
    //create, write, and/or merge
    return _db
        .collection(usersPath)
        .document(connectionUserFolder)
        .collection(collection)
        .document(documentName)
        .updateData(data);
  }

  //add or overwrite document in a user collection (userPlants, userCollections, or userSets)
  Future<void> insertDocumentToCollection(
      {@required Map data,
      @required String collection,
      @required String documentName,
      bool merge}) {
    //create, write, and/or merge
    return _db
        .collection(usersPath)
        .document(currentUserFolder)
        .collection(collection)
        .document(documentName)
        .setData(data, merge: merge != null ? merge : false);
  }

  //add or remove item in specific array in specific document in specific collection
  Future<void> updateArrayInDocumentInCollection(
      {@required String arrayKey,
      @required List entries,
      @required String folder,
      @required String documentName,
      //true to add false to remove
      @required bool action}) async {
    if (entries != null) {
      //create, write, and/or merge
      if (action == true) {
        return await _db
            .collection(usersPath)
            .document(currentUserFolder)
            .collection(folder)
            .document(documentName)
            .updateData({arrayKey: FieldValue.arrayUnion(entries)});
      } else if (action == false) {
        return await _db
            .collection(usersPath)
            .document(currentUserFolder)
            .collection(folder)
            .document(documentName)
            .updateData({arrayKey: FieldValue.arrayRemove(entries)});
      }
    } else {}
  }

  //add or remove item in specific array in specific document in specific collection of other user
  Future<void> updateArrayInDocumentInOtherCollection(
      {@required String arrayKey,
      @required List entries,
      @required String folder,
      @required String documentName,
      //true to add false to remove
      @required bool action}) async {
    if (entries != null) {
      //create, write, and/or merge
      if (action == true) {
        return await _db
            .collection(usersPath)
            .document(connectionUserFolder)
            .collection(folder)
            .document(documentName)
            .updateData({arrayKey: FieldValue.arrayUnion(entries)});
      } else if (action == false) {
        return await _db
            .collection(usersPath)
            .document(connectionUserFolder)
            .collection(folder)
            .document(documentName)
            .updateData({arrayKey: FieldValue.arrayRemove(entries)});
      }
    } else {}
  }

  //delete specific document in specific collection
  Future<void> deleteDocumentFromCollection(
      {@required String documentID, @required String collection}) {
    String userDoc = currentUserFolder;
    return _db
        .collection(usersPath)
        .document(userDoc)
        .collection(collection)
        .document(documentID)
        .delete();
  }

  //query all documents in specific collection
  Future<QuerySnapshot> getCollection({@required String collection}) async {
    String userDoc = currentUserFolder;
    return _db
        .collection(usersPath)
        .document(userDoc)
        .collection('$collection')
        .getDocuments();
  }

  //delete all documents in specific collection
  Future<void> deleteCollection({@required String collection}) {
    String userDoc = currentUserFolder;
    return _db
        .collection(usersPath)
        .document(userDoc)
        .collection(collection)
        .document()
        .delete();
  }

  //*****************USER COLLECTION BACKUP*****************

  //UPDATE userPlants AND userCollections WITH DATA FROM A LIST
  void uploadLibraryBundle({@required List bundle}) {
    for (List<Map> library in bundle) {
      for (Map item in library) {
        insertDocumentToCollection(
            data: item,
            collection: item[CollectionKeys.id] != null
                ? DBFolder.collections
                : DBFolder.plants,
            documentName: item[CollectionKeys.id] != null
                ? item[CollectionKeys.id]
                : item[PlantKeys.id]);
      }
    }
  }

  //DOWNLOAD userPlants AND userCollections AND PACKAGE DATA TO LIST
  Future<List> downloadLibraryBundle() async {
    List<Map> plants = [];
    QuerySnapshot plantList = await getCollection(collection: DBFolder.plants);
    for (DocumentSnapshot plant in plantList.documents) {
      plants.add(plant.data);
    }
    List<Map> collections = [];
    QuerySnapshot collectionList =
        await getCollection(collection: DBFolder.collections);
    for (DocumentSnapshot collection in collectionList.documents) {
      collections.add(collection.data);
    }
    libraryBundle = [plants, collections];
    print('downloadLibraryBundle: Complete');
    return libraryBundle;
  }

  //*****************GENERAL*****************

  static Future<void> removeDocument(String id) {
    return _db.collection(usersPath).document(id).delete();
  }

  //*****************//LEVEL 1 AND LEVEL 2 METHODS//*****************//

  //TEMP METHOD TO MOVE PLANTS
  Future<void> transferPlants() async {
    //get all the user information
    DocumentSnapshot snap = await _db
        .collection(DBFolder.app)
        .document(DBFolder.userStatsTop)
        .get();
    //get the list
    List userList = snap.data[DBFields.byPlants];
    for (Map user in userList) {
      String userID = user[UserKeys.id];

      QuerySnapshot plantSnap = await _db
          .collection(usersPath)
          .document(userID)
          .collection('userPlants')
          .getDocuments();

      List<DocumentSnapshot> plantList = plantSnap.documents;

      for (DocumentSnapshot snap in plantList) {
        Map plant = snap.data;
        plant[PlantKeys.owner] = userID;
        setDocumentL1(
            collection: DBFolder.plants,
            document: plant[PlantKeys.id],
            data: plant);
      }
    }
  }

  //SET DOCUMENT LEVEL 1
  Future<void> setDocumentL1(
      {@required String collection,
      @required String document,
      @required Map data}) {
    return _db.collection(collection).document(document).setData(data);
  }

  //SET DOCUMENT LEVEL 2
  Future<void> setDocumentL2(
      {@required String collectionL1,
      @required String documentL1,
      @required String collectionL2,
      @required String documentL2,
      @required Map data,
      @required bool merge}) {
    return _db
        .collection(collectionL1)
        .document(documentL1)
        .collection(collectionL2)
        .document(documentL2)
        .setData(data, merge: merge);
  }

  //UPDATE DOCUMENT LEVEL 1
  Future<void> updateDocumentL1(
      {@required String collection,
      @required String document,
      @required Map data}) {
    return _db
        .collection(collection)
        .document(document)
        .updateData(data.cast());
  }

  //GET DOCUMENT LEVEL 1
  Future<DocumentSnapshot> getDocumentL1(
      {@required String collection, @required String document}) {
    return _db.collection(collection).document(document).get();
  }

  //UPDATE ARRAY IN DOCUMENT LEVEL 1
  Future<void> updateDocumentL1Array(
      {@required String collection,
      @required String document,
      @required String key,
      @required List entries,
      @required bool action}) async {
    if (entries != null)
    //create, write, and/or merge
    if (action == true) {
      return _db
          .collection(collection)
          .document(document)
          .updateData({key: FieldValue.arrayUnion(entries)});
    } else if (action == false) {
      return _db
          .collection(collection)
          .document(document)
          .updateData({key: FieldValue.arrayRemove(entries)});
    }
  }

  //UPDATE ARRAY IN DOCUMENT LEVEL 1
  Future<void> updateDocumentL2Array(
      {@required String collectionL1,
      @required String documentL1,
      @required String collectionL2,
      @required String documentL2,
      @required String key,
      @required List entries,
      @required bool action}) async {
    if (entries != null)
    //create, write, and/or merge
    if (action == true) {
      return await _db
          .collection(collectionL1)
          .document(documentL1)
          .collection(collectionL2)
          .document(documentL2)
          .updateData({key: FieldValue.arrayUnion(entries)});
    } else if (action == false) {
      print('arrayRemove');
      return await _db
          .collection(collectionL1)
          .document(documentL1)
          .collection(collectionL2)
          .document(documentL2)
          .updateData({key: FieldValue.arrayRemove(entries)});
    }
  }

  //DELETE DOCUMENT L1
  Future<void> deleteDocumentL1(
      {@required String collection, @required String document}) {
    return _db.collection(collection).document(document).delete();
  }

  //DELETE DOCUMENT L2
  Future<void> deleteDocumentL2({
    @required String collectionL1,
    @required String documentL1,
    @required String collectionL2,
    @required String documentL2,
  }) {
    return _db
        .collection(collectionL1)
        .document(documentL1)
        .collection(collectionL2)
        .document(documentL2)
        .delete();
  }

  //*****************LEVEL 1 CUSTOMIZED METHODS*****************

  List<String> orphanedPlantCheck({
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

  //QUARANTINE
  Future<void> quarantinePlant({@required String plantID}) async {
    try {
      //get the document
      DocumentSnapshot document =
          await getDocumentL1(collection: DBFolder.plants, document: plantID);
      //copy it to quarantine
      setDocumentL1(
          collection: DBFolder.quarantinePlants,
          document: plantID,
          data: document.data);
      //delete the original
      deleteDocumentL1(collection: DBFolder.plants, document: plantID);
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUserDocument(
      {@required String userID, @required String userEmail}) {
    //CREATE USER DOCUMENT
    //create new user then pack into a map
    Map data = UserData(
      id: userID,
      email: userEmail,
      join: DateTime.now().millisecondsSinceEpoch,
    ).toMap();
    //set the user document
    return setDocumentL1(
        collection: DBFolder.users, document: userID, data: data);
  }

  //UPDATE CLONE COUNT
  Future<void> updatePlantCloneCount(
      {@required String plantID, @required int currentValue}) {
    return updateDocumentL1(
        collection: DBFolder.plants,
        document: plantID,
        data: {PlantKeys.clones: currentValue + 1});
  }

  //like or unlike a plant
  Future<void> updatePlantLike(
      {@required String plantID,
      @required int likes,
      @required List likeList}) {
    //if the plant is in the user list, set action to remove (false) and subtract one like
    //if the plant is NOT in the sure list, set action to add (true) and add one like
    bool action = !likeList.contains(plantID);
    int add = (action == true) ? 1 : -1;
    //update the plant like count
    updateDocumentL1(
        data: updatePairFull(key: PlantKeys.likes, value: likes + add),
        collection: DBFolder.plants,
        document: plantID);
    //update the user list of likes
    return updateUserArray(
        action: action, entries: [plantID], arrayKey: UserKeys.likedPlants);
  }

  //*****************DATA HELPERS*****************

  //METHOD TO CHECK IF DEFAULT EXISTS
  Future<void> updateDefaultDocumentL2(
      {@required String collectionL2,
      @required String documentL2,
      @required String key,
      @required List<String> entries,
      @required bool match,
      @required Map defaultDocument}) async {
    //CHECK EXISTS, IF NOT CREATE, OTHERWISE CREATE DEFAULT DOCUMENT AND UPDATE

    //if no match is found create the default collection, keep merge just in case
    if (match == false) {
      //upload new collection data
      await setDocumentL2(
          collectionL1: DBFolder.users,
          documentL1: currentUserFolder,
          collectionL2: collectionL2,
          documentL2: documentL2,
          data: defaultDocument,
          merge: true);
    }

    //update with the new value regardless
    return updateDocumentL2Array(
      collectionL1: DBFolder.users,
      documentL1: currentUserFolder,
      collectionL2: collectionL2,
      documentL2: documentL2,
      key: key,
      entries: entries,
      action: true,
    );
  }

  //METHOD TO CREATE NEW DEFAULT COLLECTION
  CollectionData newDefaultCollection({@required String collectionName}) {
    final collection = CollectionData(
      id: collectionName,
      name: collectionName,
      plants: [],
      creator: null,
    );
    return collection;
  }

  //METHOD TO CREATE NEW DEFAULT COLLECTION
  GroupData newDefaultGroup({@required String groupName}) {
    final group = GroupData(
      id: groupName,
      name: groupName,
      collections: [],
      order: 0,
      color: [],
    );
    return group;
  }

  //update or remove entry in plant journal
  Future<void> journalEntryUpdate(
      {@required String plantID,
      @required List journals,
      @required Map entry}) {
    print(journals);
    print(entry);
    //updated journal list
    List updatedJournal = [];

    //replace the entry
    for (Map journal in journals) {
      if (journal[JournalKeys.id] == entry[JournalKeys.id]) {
        updatedJournal.add(entry);
      } else {
        updatedJournal.add(journal);
      }
    }

    //upload the updated list
    return updateDocumentL1(
      collection: DBFolder.plants,
      document: plantID,
      data: updatePairFull(key: PlantKeys.journal, value: updatedJournal),
    );
  }

  //CREATE A JOURNAL ENTRY
  Future<void> journalEntryCreate(
      {@required Map entry, @required String plantID}) {
    //update the document
    return updateDocumentL1Array(
        collection: DBFolder.plants,
        document: plantID,
        key: PlantKeys.journal,
        entries: [entry],
        action: true);
  }

  //CREATE A DOCUMENT
  Future<void> createDocument(
      {@required Map data, @required String collection}) {
    try {
      return _db.collection(collection).document().setData(
            data.cast<String, dynamic>(),
          );
    } catch (e) {
      print(e);
      return null;
    }
  }

  //*****************GENERAL*****************
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

  //SECTION END
}
