import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:flutter/material.dart';

class CloudDB extends ChangeNotifier {
  //initialize Firestore instance
  static Firestore _db = Firestore.instance;
  //path variable
  static String usersPath = 'users';
  static String conversationsPath = 'conversations';
  static String messagesPath = 'messages';

  //stream savers
  //current user
  List<Map> currentUserGroups;
  List<Map> currentUserCollections;
  List<Map> currentUserPlants;
  //connection
  List<Map> connectionGroups;
  List<Map> connectionCollections;
  List<Map> connectionPlants;

  //variables
  String currentUserFolder;
  String newDataInput;
  List<List<Map>> libraryBundle;
  String connectionUserFolder;

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
  Stream<QuerySnapshot> streamPlants({@required String userID}) {
    return _db
        .collection(usersPath)
        .document(userID)
        .collection(kUserPlants)
        .snapshots();
  }

  //provide a stream of one specific plant document
  Stream<DocumentSnapshot> streamPlant(
      {@required String plantID, @required String userID}) {
    return _db
        .collection(usersPath)
        .document(userID)
        .collection(kUserPlants)
        .document(plantID)
        .snapshots();
  }

  //provide a stream of all groups
  Stream<QuerySnapshot> streamGroups({@required String userID}) {
    return _db
        .collection(usersPath)
        .document(userID)
        .collection(kUserGroups)
        .snapshots();
  }

  //provide a stream of all collections
  Stream<QuerySnapshot> streamCollections({@required String userID}) {
    return _db
        .collection(usersPath)
        .document(userID)
        .collection(kUserCollections)
        .snapshots();
  }

  //provide a stream of requests
  Stream<QuerySnapshot> streamRequests() {
    return _db
        .collection(usersPath)
        .document(currentUserFolder)
        .collection(kUserRequests)
        .snapshots();
  }

  //provide a stream of requests
  Stream<QuerySnapshot> streamConnections() {
    return _db
        .collection(usersPath)
        .document(currentUserFolder)
        .collection(kUserConnections)
        .snapshots();
  }

  //provide a stream of user document
  Stream<DocumentSnapshot> streamUserDocument({@required String userID}) {
    return _db.collection(usersPath).document(userID).snapshots();
  }

  //provide a stream of requests
  Stream<QuerySnapshot> streamMessages({@required String document}) {
    if (document != null) {
      return _db
          .collection(conversationsPath)
          .document(document)
          .collection(messagesPath)
          .orderBy(kMessageTime)
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

  //send a message
  Future<DocumentReference> sendMessage(
      {@required String messageText,
      @required String messageSender,
      @required String document}) {
    if (messageSender != null && messageText != null) {
      return _db
          .collection(conversationsPath)
          .document(document)
          .collection(messagesPath)
          .add({
        kMessageSender: messageSender,
        kMessageText: messageText,
        kMessageTime: DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      return null;
    }
  }

  //delete messages
  //TODO check that this works
  Future<DocumentReference> deleteMessageHistory({@required String document}) {
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
  Future<String> getUserFromEmail({@required String userEmail}) async {
    String match;
    if (userEmail != null) {
      //search through users to find matching email
      QuerySnapshot result = await _db
          .collection(usersPath)
          .where(kUserEmail, isEqualTo: userEmail)
          .getDocuments();
      if (result.documents != null && result.documents.length > 0) {
        //there should only be one match, get and return ID
        match = result.documents[0].data[kUserID];
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
      Map userMap = (await getDB().get()).data;
      //search through users to find matching email
      try {
        await _db
            .collection(usersPath)
            .document(connectionID)
            .collection(kUserRequests)
            .document(currentUserFolder)
            .setData({
          kUserID: currentUserFolder,
          kUserName: userMap[kUserName],
          kUserAvatar: userMap[kUserAvatar],
        });
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
        .collection(kUserRequests)
        .document(connectionID)
        .delete();
  }

  //Add reference to connection in user connection folder
  Future addConnectionDocument(
      {@required String pathID, @required String documentID}) {
    return _db
        .collection(usersPath)
        .document(pathID)
        .collection(kUserConnections)
        .document(documentID)
        .setData({
      kUserID: documentID,
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
        .collection(kUserConnections)
        .document(connectionID)
        .delete();
    //remove from connection records
    _db
        .collection(usersPath)
        .document(connectionID)
        .collection(kUserConnections)
        .document(currentUserFolder)
        .delete();
  }

  //*****************USER DOCUMENT SPECIFIC*****************//

  //create a user document and save to db upon registration
  Future<void> addUserDocument({@required Map data, @required String userID}) {
    String userDoc = userID;
    //look into database instance, then collection, for ID, create if doesn't exist
    return _db.collection(usersPath).document(userDoc).setData(data);
  }

  //create a user document on registration and update in the future
  Future<void> updateUserDocument(
      {@required Map data, @required String userID}) {
    //look into database instance, then collection, for ID, create if doesn't exist
    try {
      //TODO problem here on logout, it tries to run and there are permission issues
      return _db.collection(usersPath).document(userID).updateData(data);
    } catch (e) {
      return (e);
    }
  }

  //*****************HELPERS*****************

  //get an individual map given an ID from a list of maps
  Map getDocumentFromList(
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

  //generate map to insert data to db (value is saved to input variable)
  Map<String, dynamic> updatePairInput({@required String key}) {
    return {key: newDataInput};
  }

  //generate map to insert data to db (when value isn't from user input)
  Map<String, dynamic> updatePairFull({@required String key, @required value}) {
    return {key: value};
  }

  //GET VALUE FROM MAP
  String getValue({@required Map data, @required String key}) {
    String value;
    if (data != null) {
      value = data[key];
    } else {
      value = null;
    }
    return value;
  }

  //GET IMAGE COUNT
  String getImageCount({@required List<Map> plants}) {
    int imageCount;
    if (plants != null) {
      for (Map plant in plants) {
        List images = plant[kPlantImageList];
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
    String collection = kUserPlants;
    String userDoc = currentUserFolder;
    _db
        .collection(usersPath)
        .document(userDoc)
        .collection(collection)
        .document(documentID)
        .get()
        .then((DocumentSnapshot data) {
      if (data.data[kPlantThumbnail] == null) {
        thumbnailFound = false;
      } else {
        thumbnailFound = true;
      }
    });
    return thumbnailFound;
  }
  //*****************USER COLLECTION SPECIFIC*****************

  //generate list of maps for Group
  List<Map> getMapsFromList(
      {@required List<dynamic> groupCollectionIDs,
      @required List<Map> collections}) {
    List<Map> groupCollections = [];
    if (groupCollectionIDs != null && collections != null) {
      for (String ID in groupCollectionIDs) {
        for (Map collection in collections) {
          if (collection.containsValue(ID)) {
            groupCollections.add(collection);
          }
        }
      }
    }
    return groupCollections;
  }

  //*****************USER COLLECTION SPECIFIC*****************

  //query specific document in specific collection
  DocumentReference getCollectionDocumentRef(
      {@required String documentID, @required String collection}) {
    String userDoc = currentUserFolder;

    final DocumentReference docRef = _db
        .collection(usersPath)
        .document(userDoc)
        .collection(collection)
        .document(documentID);
    return docRef;
  }

  //update a piece of data in a user collection (userPlants, userCollections, or userSets)
  Future<void> updateDocumentInCollection(
      {@required Map data,
      @required String collection,
      @required String documentName}) {
    String userDoc = currentUserFolder;
    //create, write, and/or merge
    return _db
        .collection(usersPath)
        .document(userDoc)
        .collection(collection)
        .document(documentName)
        .updateData(data);
  }

  //add or overwrite document in a user collection (userPlants, userCollections, or userSets)
  Future<void> insertDocumentToCollection(
      {@required Map data,
      @required String collection,
      @required String documentName}) {
    String userDoc = currentUserFolder;
    //create, write, and/or merge
    return _db
        .collection(usersPath)
        .document(userDoc)
        .collection(collection)
        .document(documentName)
        .setData(data, merge: false);
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
      String userDoc = currentUserFolder;
      //create, write, and/or merge
      if (action == true) {
        return await _db
            .collection(usersPath)
            .document(userDoc)
            .collection(folder)
            .document(documentName)
            .updateData({arrayKey: FieldValue.arrayUnion(entries)});
      } else if (action == false) {
        return await _db
            .collection(usersPath)
            .document(userDoc)
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
            collection: item[kCollectionID] != null
                ? '$kUserCollections'
                : '$kUserPlants',
            documentName: item[kCollectionID] != null
                ? item[kCollectionID]
                : item[kPlantID]);
      }
    }
  }

  //DOWNLOAD userPlants AND userCollections AND PACKAGE DATA TO LIST
  Future<List> downloadLibraryBundle() async {
    List<Map> plants = [];
    QuerySnapshot plantList = await getCollection(collection: kUserPlants);
    for (DocumentSnapshot plant in plantList.documents) {
      plants.add(plant.data);
    }
    List<Map> collections = [];
    QuerySnapshot collectionList =
        await getCollection(collection: kUserCollections);
    for (DocumentSnapshot collection in collectionList.documents) {
      collections.add(collection.data);
    }
    libraryBundle = [plants, collections];
    print('downloadLibraryBundle: Complete');
    return libraryBundle;
  }

  //*****************GENERAL*****************

  Future<void> removeDocument(String id) {
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
