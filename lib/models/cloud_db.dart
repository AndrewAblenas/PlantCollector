import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/friend_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
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
  //streams
//  Stream userDocumentStream;
//  Stream userGroupsStream;
//  Stream userCollectionsStream;
//  Stream userPlantsStream;
//  Stream userConnectionsStream;
//  Stream userRequestsStream;
//  Stream userMessagesStream;
  //set user streams
//  void setUserStreams({@required userID}) {
//    userDocumentStream = streamUserDocument(userID: userID);
//    userGroupsStream = streamGroups(userID: userID);
//    userCollectionsStream = streamCollections(userID: userID);
//    userPlantsStream = streamPlants(userID: userID);
//    userConnectionsStream = streamConnections();
//    userRequestsStream = streamRequests();
//  }

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

  //provide a stream of all plants
//  Stream<QuerySnapshot> streamPlants({@required userID}) {
//    return _db
//        .collection(usersPath)
//        .document(userID)
//        .collection(DBFolder.plants)
//        .snapshots();
//  }

  //provide a journal stream for a plant
  Stream<DocumentSnapshot> streamJournal(
      {@required String plantID, @required userID}) {
    return _db
        .collection(usersPath)
        .document(userID)
        .collection(DBFolder.plants)
        .document(plantID)
        .collection(DBFolder.records)
        .document('journal')
        .snapshots();
  }

  //provide a stream of one specific plant document
  //NOTE userID is required as it may be from a connection in chat
  Stream<DocumentSnapshot> streamPlant(
      {@required String plantID, @required userID}) {
    return _db
        .collection(usersPath)
        .document(userID)
        .collection(DBFolder.plants)
        .document(plantID)
        .snapshots();
  }

  //provide a stream of all plants
  static Stream<List<PlantData>> streamPlantsData({@required userID}) {
    //stream
    Stream<QuerySnapshot> stream = _db
        .collection(usersPath)
        .document(userID)
        .collection(DBFolder.plants)
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

  //provide a stream of user document
  static Stream<UserData> streamUserData({@required userID}) {
    Stream<DocumentSnapshot> stream =
        _db.collection(usersPath).document(userID).snapshots();
    //return specific data type
    return stream.map((doc) => UserData.fromMap(map: doc.data));
  }

  //provide a stream of all messages
  //TODO figure this out, might need to restructure data?
//  Stream<QuerySnapshot> streamAllMessages({@required String document}) {
//    if (document != null) {
//      return _db
//          .collection(conversationsPath)
//          .where('users', arrayContains: currentUserFolder)
//          .getDocuments().
//          .collection(messagesPath)
//          .orderBy(kMessageTime, descending: true)
//          .limit(20)
//          .snapshots();
//    } else {
//      return null;
//    }
//  }

  //TODO
  //add user reference to shared message document
//  static Future<void> addConvoParticipants ({@required String document, @required String userID, @required String friendID}) {
//    return _db
//        .collection(conversationsPath)
//        .document(document)
//        .setData({
//      'users': [userID, friendID]
//    });
//  }

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
  //TODO check that this works
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
      //TODO problem here on logout, it tries to run and there are permission issues
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
    String collection = DBFolder.plants;
    _db
        .collection(usersPath)
        .document(currentUserFolder)
        .collection(collection)
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
  static Map cleanPlant({@required Map plantData, @required String id}) {
    plantData[PlantKeys.id] = id;
    plantData[PlantKeys.images] = [];
    plantData[PlantKeys.thumbnail] = '';
    plantData[PlantKeys.quantity] = '';
    return plantData;
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

  //add or overwrite a journal entry
  Future<void> journalCreateEntry(
      {@required String arrayKey,
      @required Map entry,
      @required String documentName}) {
    //create, write, and/or merge
    return _db
        .collection(usersPath)
        .document(currentUserFolder)
        .collection(DBFolder.plants)
        .document(documentName)
        .collection(DBFolder.records)
        .document('journal')
        .setData({arrayKey: entry}, merge: true);
  }

  //update or remove entry in plant journal
  Future<void> journalEntryUpdate(
      {@required String arrayKey,
      @required Map entry,
      @required String documentName,
      //true to add false to remove
      @required bool action}) async {
    if (entry != null) {
      //create, write, and/or merge
      if (action == true) {
        return await _db
            .collection(usersPath)
            .document(currentUserFolder)
            .collection(DBFolder.plants)
            .document(documentName)
            .collection(DBFolder.records)
            .document('journal')
            .updateData({arrayKey: entry});
      } else if (action == false) {
        return await _db
            .collection(usersPath)
            .document(currentUserFolder)
            .collection(DBFolder.plants)
            .document(documentName)
            .collection(DBFolder.records)
            .document('journal')
            .updateData({arrayKey: entry});
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

  //UPDATE AN EXISTING DOCUMENT
  Future<void> updateDocument({@required Map data}) {
    return _db
        .collection(usersPath)
        .document(currentUserFolder)
        .updateData(data);
  }

  //SECTION END
}
