import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/communication_data.dart';
import 'package:plant_collector/models/data_types/friend_data.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/models/data_types/message_data.dart';
import 'package:plant_collector/models/data_types/plant/image_data.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';

class CloudDB extends ChangeNotifier {
  //initialize Firestore instance
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  //path variable
  static String usersPath = 'users';
  static String conversationsPath = 'conversations';
  static String messagesPath = 'messages';

  //variables
  String currentUserFolder;
  List<List<Map>> libraryBundle;
//  String connectionUserFolder;

  //*****************INITIALIZE*****************//

  //this is to provide the user ID to this class
  void setUserFolder({@required String userID}) {
    currentUserFolder = userID;
  }

  //this is to provide the user ID to this class
//  void setConnectionFolder({@required String connectionID}) {
//    connectionUserFolder = connectionID;
//  }

  //*****************REFERENCES*****************

  //expose the db
  DocumentReference getDB() {
    return _db.collection(usersPath).doc(currentUserFolder);
  }

  //*****************STREAMS*****************

  //get a snapshot of the top user files
//  static Stream<DocumentSnapshot> streamMostPlants() {
//    try {
//      return _db
//          .collection(DBFolder.app)
//          .doc(DBFolder.userStatsTop)
//          .snapshots();
//    } catch (e) {
//      return Stream.error(e);
//    }
//  }

  static Stream<List<PlantData>> streamReportedPlants() {
    try {
      //stream
      Stream<QuerySnapshot> stream = _db
          .collection(DBFolder.plants)
          .where(PlantKeys.isFlagged, isEqualTo: true)
          .snapshots();
      //return specific data type
      return stream.map((snap) =>
          snap.docs.map((doc) => PlantData.fromMap(map: doc.data())).toList());
    } catch (e) {
      return Stream.error(e);
    }
  }

  //get a snapshot of the user announcements
  static Future<List<CommunicationData>> streamAnnouncements() {
    try {
      return _db.collection(DBFolder.announcements).get().then((snap) => snap
          .docs
          .map((doc) => CommunicationData.fromMap(map: doc.data()))
          .toList());
    } catch (e) {
      return Future.error(e);
    }
  }

  //get a snapshot of the top user files
  static Stream<List<CommunicationData>> streamAdminToUser(userID) {
    try {
      return _db
          .collection(DBFolder.communications)
          .doc(DBDocument.adminToUser)
          .collection(userID)
          .snapshots()
          .map((snap) => snap.docs.map((doc) {
                //add the document reference for later
                Map map = doc.data();
                map[CommunicationKeys.reference] = doc.reference;
                return CommunicationData.fromMap(map: map);
              }).toList());
    } catch (e) {
      return Stream.error(e);
    }
  }

  //get a snapshot of the top user files
  static Future<List<UserData>> userSearchExact({@required String input}) {
    input = input.toLowerCase();
    try {
      return _db
          .collection(usersPath)
          .where(UserKeys.uniquePublicID, isEqualTo: input)
          .limit(5)
          .get()
          .then((snap) => snap.docs
              .map((doc) => UserData.fromMap(map: doc.data()))
              .toList());
    } catch (e) {
      return Future.error(e);
    }
  }

  //provide a stream of one specific plant document
  static Stream<DocumentSnapshot> streamPlant({@required String plantID}) {
    try {
      return _db.collection(DBFolder.plants).doc(plantID).snapshots();
    } catch (e) {
      return Stream.error(e);
    }
  }

  //provide a stream of all user plants
  static Stream<List<PlantData>> streamPlantsData({@required userID}) {
    try {
      //stream
      Stream<QuerySnapshot> stream = _db
          .collection(DBFolder.plants)
          .where(PlantKeys.owner, isEqualTo: userID)
          .snapshots();
      //return specific data type
      return stream.map((snap) =>
          snap.docs.map((doc) => PlantData.fromMap(map: doc.data())).toList());
    } catch (e) {
      return Stream.error(e);
    }
  }

  //*****************COMMUNITY STREAMS*****************

  //provide a stream to the top collectors document
  static Stream<List<UserData>> streamCommunityTopUsersByPlants(
      {field = UserKeys.plants}) {
    try {
      //Provide a stream of the top users in descending order
      Stream<QuerySnapshot> stream;
      //stream
      stream = _db
          .collection(DBFolder.users)
          .orderBy(field, descending: true)
          .limit(99)
          .snapshots();
      //return specific data type
      return stream.map((snap) =>
          snap.docs.map((doc) => UserData.fromMap(map: doc.data())).toList());
    } catch (e) {
      return Stream.error(e);
    }
  }

  static Stream<List<PlantData>> streamCommunityPlantsTopDescending(
      {@required String field}) {
    try {
      //Provide a stream of the top plants sorted by field in descending order
      Stream<QuerySnapshot> stream;
      //stream
      stream = _db
          .collection(DBFolder.plants)
          .where(PlantKeys.isVisible, isEqualTo: true)
          .orderBy(field, descending: true)
          .limit(99)
          .snapshots();
      //return specific data type
      return stream.map((snap) =>
          snap.docs.map((doc) => PlantData.fromMap(map: doc.data())).toList());
    } catch (e) {
      return Stream.error(e);
    }
  }

  //if the plant is new don't push to recently updated on changes
  static int delayUpdateWrites(
      {@required int timeCreated, @required String document}) {
    //get time now
    int now = DateTime.now().millisecondsSinceEpoch;
    //set cutoff date
    int cutoffDate = now - (86400000 * 2);
    //initialize
    int lastUpdate;
    //check to make sure the creation time was before the cutoff date
    //this makes sure plant updates won't be recorder for the above set period after creation
    if (timeCreated < cutoffDate) {
      lastUpdate = now;
      //This will be called at most updates so use this time to set last plant update
      Map<String, dynamic> upload = {UserKeys.lastPlantUpdate: now};
      updateDocumentL1(
          collection: DBDocument.users, document: document, data: upload);
    }
    return lastUpdate;
  }

  //provide a stream of all groups
//  Stream<QuerySnapshot> streamGroups({@required userID}) {
//    return _db
//        .collection(usersPath)
//        .doc(userID)
//        .collection(DBFolder.groups)
//        .snapshots();
//  }

  //provide a stream of all groups
//  static Stream<List<GroupData>> streamGroupsData({@required userID}) {
//    try {
//      //stream
//      Stream<QuerySnapshot> stream = _db
//          .collection(usersPath)
//          .doc(userID)
//          .collection(DBFolder.groups)
//          .snapshots();
//      //return specific data type
//      return stream.map((snap) =>
//          snap.docs.map((doc) => GroupData.fromMap(map: doc.data))
//              .toList());
//    } catch (e) {
//      return Stream.error(e);
//    }
//  }

  //provide a stream of all collections
//  Stream<QuerySnapshot> streamCollections({@required userID}) {
//    return _db
//        .collection(usersPath)
//        .doc(userID)
//        .collection(DBFolder.collections)
//        .snapshots();
//  }

  //stream user query
  static Stream<List<PlantData>> streamUserPlantQuery(
      {@required Map<String, dynamic> queryMap}) {
    try {
      //map keys to list to iterate through
      List<String> keys = queryMap.keys.toList();
      //initialize query
      Query query = _db
          .collection(DBFolder.plants)
          .where(PlantKeys.isVisible, isEqualTo: true);
      //add to query for each search term
      for (String key in keys) {
        query = query.where(key, isEqualTo: queryMap[key]);
      }
      //Now get the stream the stream
      Stream<QuerySnapshot> stream = query
          //this seems to return nothing if no likes field
//            .orderBy(PlantKeys.likes, descending: true)
          .limit(48)
          .snapshots();
      //convert and return
      return stream.map((snap) =>
          snap.docs.map((doc) => PlantData.fromMap(map: doc.data())).toList());
    } catch (e) {
      return Stream.error(e);
    }
  }

  //provide a stream of all collections
  static Stream<List<CollectionData>> streamCollectionsData(
      {@required userID}) {
    try {
      //stream
      Stream<QuerySnapshot> stream = _db
          .collection(usersPath)
          .doc(userID)
          .collection(DBFolder.collections)
          .snapshots();
      //return specific data type
      return stream.map((snap) => snap.docs
          .map((doc) => CollectionData.fromMap(map: doc.data()))
          .toList());
    } catch (e) {
      return Stream.error(e);
    }
  }

  //provide a stream of all collections
  static Future<List<CollectionData>> futureCollectionsData(
      {@required userID}) async {
    try {
      //stream
      QuerySnapshot snap = await _db
          .collection(usersPath)
          .doc(userID)
          .collection(DBFolder.collections)
          .get();

      //return specific data type
      return snap.docs
          .map((item) => CollectionData.fromMap(map: item.data()))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
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
      return Future.error(e);
    }
  }

  //check for new messages
  Stream<bool> checkForUnreadMessages() {
    try {
      return _db
          .collection(DBFolder.conversations)
          .where(MessageParentKeys.unreadBy, isEqualTo: currentUserFolder)
          .limit(1)
          .snapshots()
          .map((querySnap) {
        if (querySnap != null &&
            querySnap.docs != null &&
            querySnap.docs.length > 0) {
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      return Stream.error(e);
    }
  }

  //provide a stream of messages for a specific conversation
  Stream<QuerySnapshot> streamConvoMessages(
      {@required String connectionID, int limit = 20}) {
    try {
      String document = conversationDocumentName(connectionId: connectionID);
      return _db
          .collection(DBFolder.conversations)
          .doc(document)
          .collection(DBFolder.messages)
          .orderBy(MessageKeys.time, descending: true)
          .limit(limit)
          .snapshots();
    } catch (e) {
      return Stream.error(e);
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
          .doc(currentUserFolder)
          .update({arrayKey: FieldValue.arrayUnion(entries)});
    } else if (action == false) {
      return await _db
          .collection(usersPath)
          .doc(currentUserFolder)
          .update({arrayKey: FieldValue.arrayRemove(entries)});
    }
  }

  //provide a stream of user document
  static Stream<UserData> streamUserData({@required userID}) {
    try {
      Stream<DocumentSnapshot> stream =
          _db.collection(usersPath).doc(userID).snapshots();
      //return specific data type
      return stream.map((doc) => UserData.fromMap(map: doc.data()));
    } catch (e) {
      return Stream.error(e);
    }
  }

  //provide a stream current user
  Stream<UserData> streamCurrentUser() {
    try {
      Stream<DocumentSnapshot> stream =
          _db.collection(usersPath).doc(currentUserFolder).snapshots();
      //return specific data type
      return stream.map((doc) => UserData.fromMap(map: doc.data()));
    } catch (e) {
      return Stream.error(e);
    }
  }

  //provide a stream of user document
  static Future<UserData> futureUserData({@required userID}) async {
    try {
      DocumentSnapshot future =
          await _db.collection(usersPath).doc(userID).get();
      //return specific data type
      return UserData.fromMap(map: future.data());
    } catch (e) {
      return Future.error(e);
    }
  }

  //send a message
  static Future<DocumentReference> sendMessage(
      {@required MessageData message, @required String document}) {
    //DB reference for message
    DocumentReference docRef = _db.collection(conversationsPath).doc(document);
    //make sure message sender and text exist
    if (message.sender != null && message.text != null) {
      try {
        //upload message to DB
        docRef.collection(messagesPath).add(
              message.toMap(),
            );
        //add unread ID to document for use in check for messages query
        return docRef.set({
          MessageParentKeys.unreadBy: message.recipient,
        }, SetOptions(merge: true));
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  //update message read status
  static Future<void> readMessage({@required String reference}) {
    return _db.doc(reference).update({
      MessageKeys.read: true,
    });
  }

  //delete messages
  static Future<DocumentReference> deleteMessageHistory(
      {@required String document}) {
    if (document != null) {
      return _db
          .collection(conversationsPath)
          .doc(document)
          .collection(messagesPath)
          .doc()
          .delete();
    } else {
      return null;
    }
  }

  //*****************CONNECTION METHODS*****************//

  //search for user via email
  static Future<UserData> getUserFromEmail({@required String userEmail}) async {
    UserData match;
    print(userEmail);
    if (userEmail != null) {
      //search through users to find matching email
      await _db
          .collection(usersPath)
          .where(UserKeys.email, isEqualTo: userEmail)
          .get()
          .then((result) {
        print(result);
        if (result.docs != null && result.docs.length > 0) {
          //there should only be one match, get and return ID
          print('B');
          match = UserData.fromMap(map: result.docs[0].data());
        }
      });
    }
    return match;
  }

  //send connection request
  Future<bool> sendConnectionRequest(
      {@required String connectionID, @required List connectionTokens}) async {
    bool success;
    if (connectionID != null) {
      try {
        //add request to friend document
        await updateDocumentL1Array(
            collection: DBFolder.users,
            document: connectionID,
            key: UserKeys.requestsReceived,
            entries: [currentUserFolder],
            action: true);

        //add requested to current user document
        await updateDocumentL1Array(
            collection: DBFolder.users,
            document: currentUserFolder,
            key: UserKeys.requestsSent,
            entries: [connectionID],
            action: true);

        //this will also be used to push notifications of request
        //add both user IDs to the chat document
        String document = conversationDocumentName(
          connectionId: connectionID,
        );
        Map<String, dynamic> data = {
          MessageParentKeys.participants: [currentUserFolder, connectionID],
          MessageParentKeys.initialRequestPushTokens: connectionTokens
        };
        setDocumentL1(
            collection: DBDocument.conversations,
            document: document,
            data: data);
        success = true;
      } catch (e) {
        success = false;
      }
    }
    return success;
  }

  //Accept connection request
  Future<bool> acceptConnectionRequest({@required String connectionID}) async {
    bool success;
    if (connectionID != null) {
      try {
        //remove send and received request
        await removeConnectionRequest(connectionID: connectionID);
        //add to current user friend list
        await updateDocumentL1Array(
            collection: DBFolder.users,
            document: currentUserFolder,
            key: UserKeys.friends,
            entries: [connectionID],
            action: true);
        //add to connection friend list
        await updateDocumentL1Array(
            collection: DBFolder.users,
            document: connectionID,
            key: UserKeys.friends,
            entries: [currentUserFolder],
            action: true);
        //if completed
        success = true;
      } catch (e) {
        success = false;
      }
    }
    return success;
  }

  //Remove connection request
  Future removeConnectionRequest({@required String connectionID}) async {
    //remove current user received request list
    await updateDocumentL1Array(
        collection: DBFolder.users,
        document: currentUserFolder,
        key: UserKeys.requestsReceived,
        entries: [connectionID],
        action: false);

    //remove from friend sent requests
    await updateDocumentL1Array(
        collection: DBFolder.users,
        document: connectionID,
        key: UserKeys.requestsSent,
        entries: [currentUserFolder],
        action: false);
  }

  //Add reference to connection in user connection folder
//  Future addConnectionDocument(
//      {@required String pathID, @required String documentID}) {
//    return _db
//        .collection(usersPath)
//        .doc(pathID)
//        .collection(DBFolder.friends)
//        .doc(documentID)
//        .set({
//      UserKeys.id: documentID,
//    });
//  }

  //Update reference to connection in user connection folder
  static Future updateConnectionDocument(
      {@required String pathID,
      @required String documentID,
      @required String key,
      @required value}) {
    Map<String, dynamic> data = {key: value};
    return _db
        .collection(usersPath)
        .doc(pathID)
        .collection(DBFolder.friends)
        .doc(documentID)
        .set(data, SetOptions(merge: true));
  }

  //get connection profile data
  static Future<Map> getConnectionProfile(
      {@required String connectionID}) async {
    try {
      return (await _db.collection(usersPath).doc(connectionID).get()).data();
    } catch (e) {
      print(e);
      return {};
    }
  }

  //get a futures list of the connection data
  static Future<List<UserData>> getProfiles(
      {@required List connectionsList}) async {
    //initialize an empty list
    List<UserData> list = [];

    //get the data for each connection
    for (String connection in connectionsList) {
      //wrap with try block
      try {
        //get the future
        DocumentSnapshot doc =
            await _db.collection(DBFolder.users).doc(connection).get();

        if (doc != null && doc.data() != null) {
          UserData user = UserData.fromMap(map: doc.data());
          list.add(user);
        }
      } catch (e) {
        print(e);
      }
    }
    //sort by recent updates
    list.sort((a, b) {
      int maxA = (a.lastPlantAdd >= a.lastPlantUpdate)
          ? a.lastPlantAdd
          : a.lastPlantUpdate;
      int maxB = (b.lastPlantAdd >= b.lastPlantUpdate)
          ? b.lastPlantAdd
          : b.lastPlantUpdate;
      return maxA.compareTo(maxB);
    });
    return list.reversed.toList();
  }

  //remove connection
  void removeConnection({@required String connectionID}) {
    //remove from current user and chat
    updateDocumentL1Array(
        collection: DBFolder.users,
        document: currentUserFolder,
        key: UserKeys.friends,
        entries: [connectionID],
        action: false);
    updateDocumentL1Array(
        collection: DBFolder.users,
        document: currentUserFolder,
        key: UserKeys.chats,
        entries: [connectionID],
        action: false);

    //remove from friend and chat
    updateDocumentL1Array(
        collection: DBFolder.users,
        document: connectionID,
        key: UserKeys.friends,
        entries: [currentUserFolder],
        action: false);
    updateDocumentL1Array(
        collection: DBFolder.users,
        document: connectionID,
        key: UserKeys.chats,
        entries: [currentUserFolder],
        action: false);

    //maybe delete the document as well?
    deleteDocumentL1(
        collection: DBDocument.conversations,
        document: conversationDocumentName(connectionId: connectionID));
  }

  //*****************USER DOCUMENT SPECIFIC*****************//

  //create a user document and save to db upon registration
  static Future<void> addUserDocument(
      {@required Map data, @required String userID}) {
    //look into database instance, then collection, for ID, create if doesn't exist
    return _db.collection(usersPath).doc(userID).set(data);
  }

  //create a user document on registration and update in the future
  Future<void> updateUserDocument({@required Map data}) {
    //look into database instance, then collection, for ID, create if doesn't exist
    try {
      return _db.collection(usersPath).doc(currentUserFolder).update(data);
    } catch (e) {
      return (e);
    }
  }

  //*****************HELPERS*****************

  //check if thumbnail is null (to load default image for plant tiles)
  static bool hasThumbnail({@required String documentID}) {
    bool thumbnailFound;
    _db
        .collection(DBFolder.plants)
        .doc(documentID)
        .get()
        .then((DocumentSnapshot data) {
      if (data.data()[PlantKeys.thumbnail] == null) {
        thumbnailFound = false;
      } else {
        thumbnailFound = true;
      }
    });
    return thumbnailFound;
  }
  //*****************USER COLLECTION SPECIFIC*****************

  //generate list of maps for Group
//  static List<CollectionData> getMapsFromList(
//      {@required List<dynamic> groupCollectionIDs,
//      @required List<CollectionData> collections}) {
//    List<CollectionData> groupCollections = [];
//    if (groupCollectionIDs != null && collections != null) {
//      for (String ID in groupCollectionIDs) {
//        for (CollectionData collection in collections) {
//          if (collection.id == ID) {
//            groupCollections.add(collection);
//          }
//        }
//      }
//    }
//    return groupCollections;
//  }

  //*****************USER COLLECTION SPECIFIC*****************

  //query specific document in specific collection
  DocumentReference getCollectionDocumentRef(
      {@required String documentID, @required String collection}) {
    final DocumentReference docRef = _db
        .collection(usersPath)
        .doc(currentUserFolder)
        .collection(collection)
        .doc(documentID);
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
        .doc(currentUserFolder)
        .collection(collection)
        .doc(documentName)
        .update(data);
  }

  //update a piece of data in a other friend collection (userPlants, userCollections, or userSets)
//  Future<void> updateDocumentInCollectionOther(
//      {@required Map data,
//      @required String collection,
//      @required String documentName}) {
//    //create, write, and/or merge
//    return _db
//        .collection(usersPath)
//        .doc(connectionUserFolder)
//        .collection(collection)
//        .doc(documentName)
//        .update(data);
//  }

  //add or overwrite document in a user collection (userPlants, userCollections, or userSets)
  Future<void> insertDocumentToCollection(
      {@required Map data,
      @required String collection,
      @required String documentName,
      bool merge}) {
    //create, write, and/or merge
    return _db
        .collection(usersPath)
        .doc(currentUserFolder)
        .collection(collection)
        .doc(documentName)
        .set(data, SetOptions(merge: merge != null ? merge : false));
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
            .doc(currentUserFolder)
            .collection(folder)
            .doc(documentName)
            .update({arrayKey: FieldValue.arrayUnion(entries)});
      } else if (action == false) {
        return await _db
            .collection(usersPath)
            .doc(currentUserFolder)
            .collection(folder)
            .doc(documentName)
            .update({arrayKey: FieldValue.arrayRemove(entries)});
      }
    } else {}
  }

  //add or remove item in specific array in specific document in specific collection of other user
//  Future<void> updateArrayInDocumentInOtherCollection(
//      {@required String arrayKey,
//      @required List entries,
//      @required String folder,
//      @required String documentName,
//      //true to add false to remove
//      @required bool action}) async {
//    if (entries != null) {
//      //create, write, and/or merge
//      if (action == true) {
//        return await _db
//            .collection(usersPath)
//            .doc(connectionUserFolder)
//            .collection(folder)
//            .doc(documentName)
//            .update({arrayKey: FieldValue.arrayUnion(entries)});
//      } else if (action == false) {
//        return await _db
//            .collection(usersPath)
//            .doc(connectionUserFolder)
//            .collection(folder)
//            .doc(documentName)
//            .update({arrayKey: FieldValue.arrayRemove(entries)});
//      }
//    } else {}
//  }

  //delete specific document in specific collection
  Future<void> deleteDocumentFromCollection(
      {@required String documentID, @required String collection}) {
    String userDoc = currentUserFolder;
    return _db
        .collection(usersPath)
        .doc(userDoc)
        .collection(collection)
        .doc(documentID)
        .delete();
  }

  //query all documents in specific collection
  Future<QuerySnapshot> getCollection({@required String collection}) async {
    String userDoc = currentUserFolder;
    return _db
        .collection(usersPath)
        .doc(userDoc)
        .collection('$collection')
        .get();
  }

  //delete all documents in specific collection
  Future<void> deleteCollection({@required String collection}) {
    String userDoc = currentUserFolder;
    return _db
        .collection(usersPath)
        .doc(userDoc)
        .collection(collection)
        .doc()
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
    for (DocumentSnapshot plant in plantList.docs) {
      plants.add(plant.data());
    }
    List<Map> collections = [];
    QuerySnapshot collectionList =
        await getCollection(collection: DBFolder.collections);
    for (DocumentSnapshot collection in collectionList.docs) {
      collections.add(collection.data());
    }
    libraryBundle = [plants, collections];
    print('downloadLibraryBundle: Complete');
    return libraryBundle;
  }

  Future<void> generateImageMapAndUpload(
      {@required Reference ref,
      @required String url,
      @required String plantID}) async {
    //get date
    String frontRemoved = url.split('_image_')[1];
    String epochSeconds = frontRemoved.split('.jpg')[0];
    int date = int.parse(epochSeconds);
    //get the thumbnail image name from the full sized image url
    String imageName = CloudStore.getThumbName(imageUrl: url);
    //get the thumb ref
    Reference thumbRef =
        ref.child('${DBDocument.users}/$currentUserFolder/${DBDocument.plants}'
            '/$plantID/${DBDocument.images}/$imageName.jpg');
    //try loop
    int failures = 0;
    while (failures < 10) {
      //wait for thumbnail generation then try to get the url
      await Future.delayed(
          Duration(milliseconds: (failures == 0) ? 500 : 1000));
      String thumbURL = await CloudStore.getImageUrl(reference: thumbRef);
      //check result
      if (thumbURL == 'fail') {
        //add to the failure tally
        failures++;
      } else {
        //package the data
        Map<String, dynamic> packet =
            ImageData(date: date, full: url, thumb: thumbURL).toMap();
        //upload
        updateDocumentL1Array(
            collection: DBFolder.plants,
            document: plantID,
            key: PlantKeys.imageSets,
            entries: [packet],
            action: true);
        break;
      }
    }
  }

  //*****************GENERAL*****************

  static Future<void> removeDocument(String id) {
    return _db.collection(usersPath).doc(id).delete();
  }

  //*****************//LEVEL 1 AND LEVEL 2 METHODS//*****************//

  //TEMP METHOD TO REPACKAGE IMAGE DATA
  static Future<void> repackImageData({@required Reference ref}) async {
    //set the cutoff date
    int cutoffDate = 1587022962662;
    QuerySnapshot plantQuery = await _db
        .collection(DBFolder.plants)
        .where(PlantKeys.created, isGreaterThanOrEqualTo: cutoffDate)
        .get();
//    QuerySnapshot plantQuery = await _db
//        .collection(DBFolder.plants)
//        .where(PlantKeys.id, isEqualTo: 'plant_1586480823874')
//        .get();

    List<DocumentSnapshot> plantSnapsList = plantQuery.docs;

    for (DocumentSnapshot plantSnap in plantSnapsList) {
      if (plantSnap != null) {
        Map plant = plantSnap.data();
        List imageList = plant[PlantKeys.images];
        //last run August 16
        if (plant[PlantKeys.created] >= cutoffDate) {
          if (imageList != null && imageList.length != 0) {
            List imageMapList = [];
            for (String url in imageList) {
              //get date
              String frontRemoved = url.split('_image_')[1];
              String epochSeconds = frontRemoved.split('.jpg')[0];
              int date = int.parse(epochSeconds);
              //get the thumbnail image name from the full sized image url
              String imageName = CloudStore.getThumbName(imageUrl: url);
              //get the thumb ref
              Reference thumbRef = ref.child(
                  '${DBDocument.users}/${plant[PlantKeys.owner]}/${DBDocument.plants}/${plant[PlantKeys.id]}/${DBDocument.images}/$imageName.jpg');
              //get the thumb url
              String thumbURL =
                  await CloudStore.getImageUrl(reference: thumbRef);
              Map<String, dynamic> packet =
                  ImageData(date: date, full: url, thumb: thumbURL).toMap();
              imageMapList.add(packet);
            }
            Map<String, dynamic> finalPackage = {
              PlantKeys.imageSets: imageMapList
            };
            updateDocumentL1(
                collection: DBFolder.plants,
                document: plant[PlantKeys.id],
                data: finalPackage);
          }
          print('${plant[PlantKeys.id]} complete');
        } else {
          print('Not Run');
        }
      }
    }
  }

  //TEMP METHOD TO MOVE PLANTS
  Future<void> transferPlants() async {
    //get all the user information
    DocumentSnapshot snap =
        await _db.collection(DBFolder.app).doc(DBFolder.userStatsTop).get();
    //get the list
    List userList = snap.data()[DBFields.byPlants];
    for (Map user in userList) {
      String userID = user[UserKeys.id];

      QuerySnapshot plantSnap = await _db
          .collection(usersPath)
          .doc(userID)
          .collection('userPlants')
          .get();

      List<DocumentSnapshot> plantList = plantSnap.docs;

      for (DocumentSnapshot snap in plantList) {
        Map plant = snap.data();
        plant[PlantKeys.owner] = userID;
        setDocumentL1(
            collection: DBFolder.plants,
            document: plant[PlantKeys.id],
            data: plant);
      }
    }
  }

  //TEMP METHOD TO ADD DATE
  Future<void> addDateToPlants() async {
    //get all the user information
    QuerySnapshot snap = await _db.collection(DBFolder.plants).get();

    //get the list
    List<DocumentSnapshot> plantList = snap.docs;
    for (DocumentSnapshot plantSnap in plantList) {
      //get a map of the plant
      Map plant = plantSnap.data();
      String id = plant[PlantKeys.id];
      List splitList = id.split('_');
      int date = int.parse(splitList[1]);

      Map<String, dynamic> created = {PlantKeys.created: date};
      print(created);
      updateDocumentL1(
          collection: DBFolder.plants,
          document: plant[PlantKeys.id],
          data: created);
    }
  }

  //TEMP METHOD TO ADD DATE
  Future<void> setIsVisible() async {
    //get all the user information
    QuerySnapshot snap = await _db.collection(DBFolder.plants).get();

    //get the list
    List<DocumentSnapshot> plantList = snap.docs;
    for (DocumentSnapshot plantSnap in plantList) {
      //get a map of the plant
      Map plant = plantSnap.data();

      Map<String, dynamic> data = {
        PlantKeys.isVisible: (plant[PlantKeys.images] != null &&
            plant[PlantKeys.images].length > 0)
      };

      updateDocumentL1(
          collection: DBFolder.plants,
          document: plant[PlantKeys.id],
          data: data);
    }
  }

  //SET DOCUMENT LEVEL 1
  static Future<void> setDocumentL1(
      {@required String collection,
      @required String document,
      @required Map<String, dynamic> data,
      bool merge = false}) {
    return _db
        .collection(collection)
        .doc(document)
        .set(data, SetOptions(merge: merge));
  }

  //SET DOCUMENT LEVEL 2
  static Future<void> setDocumentL2(
      {@required String collectionL1,
      @required String documentL1,
      @required String collectionL2,
      @required String documentL2,
      @required Map data,
      @required bool merge}) {
    return _db
        .collection(collectionL1)
        .doc(documentL1)
        .collection(collectionL2)
        .doc(documentL2)
        .set(data, SetOptions(merge: merge));
  }

  //UPDATE DOCUMENT LEVEL 1
  static Future<void> updateDocument(
      {@required DocumentReference reference, @required Map data}) {
    Map<String, dynamic> map = data;
    return reference.update(map);
  }

  //UPDATE DOCUMENT LEVEL 1
  static Future<void> updateDocumentL1(
      {@required String collection,
      @required String document,
      @required Map data}) {
    return _db.collection(collection).doc(document).update(data.cast());
  }

  //REMOVE FIELD DOCUMENT LEVEL 1
  static Future<void> removeFieldDocumentL1(
      {@required String collection,
      @required String document,
      @required String field}) {
    Map<String, dynamic> data = {field: FieldValue.delete()};
    return _db.collection(collection).doc(document).update(data);
  }

  //GET DOCUMENT LEVEL 1
  static Future<DocumentSnapshot> getDocumentL1(
      {@required String collection, @required String document}) {
    return _db.collection(collection).doc(document).get();
  }

  //UPDATE ARRAY IN DOCUMENT LEVEL 1
  static Future<void> updateDocumentL1Array(
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
          .doc(document)
          .update({key: FieldValue.arrayUnion(entries)});
    } else if (action == false) {
      return _db
          .collection(collection)
          .doc(document)
          .update({key: FieldValue.arrayRemove(entries)});
    }
  }

  //UPDATE ARRAY IN DOCUMENT LEVEL 1
  static Future<void> updateDocumentL2Array(
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
          .doc(documentL1)
          .collection(collectionL2)
          .doc(documentL2)
          .update({key: FieldValue.arrayUnion(entries)});
    } else if (action == false) {
      print('arrayRemove');
      return await _db
          .collection(collectionL1)
          .doc(documentL1)
          .collection(collectionL2)
          .doc(documentL2)
          .update({key: FieldValue.arrayRemove(entries)});
    }
  }

  //DELETE DOCUMENT L1
  static Future<void> deleteDocumentL1(
      {@required String collection, @required String document}) {
    return _db.collection(collection).doc(document).delete();
  }

  //DELETE DOCUMENT L2
  static Future<void> deleteDocumentL2({
    @required String collectionL1,
    @required String documentL1,
    @required String collectionL2,
    @required String documentL2,
  }) {
    return _db
        .collection(collectionL1)
        .doc(documentL1)
        .collection(collectionL2)
        .doc(documentL2)
        .delete();
  }

  //*****************LEVEL 1 CUSTOMIZED METHODS*****************

  //QUARANTINE
  static Future<void> quarantinePlant({@required String plantID}) async {
    try {
      //get the document
      DocumentSnapshot document =
          await getDocumentL1(collection: DBFolder.plants, document: plantID);
      //copy it to quarantine
      setDocumentL1(
          collection: DBFolder.quarantinePlants,
          document: plantID,
          data: document.data());
      //delete the original
      deleteDocumentL1(collection: DBFolder.plants, document: plantID);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> createUserDocument(
      {@required String userID, @required String userEmail}) {
    //CREATE USER DOCUMENT
    //create new user then pack into a map
    Map data = UserData(
      id: userID,
      email: userEmail,
      join: AppData.timeNowMS(),
    ).toMap();
    //set the user document
    return setDocumentL1(
        collection: DBFolder.users, document: userID, data: data);
  }

  //UPDATE CLONE COUNT
  static Future<void> updatePlantCloneCount(
      {@required String plantID, @required int currentValue}) {
    return updateDocumentL1(
        collection: DBFolder.plants,
        document: plantID,
        data: {PlantKeys.clones: currentValue + 1});
  }

  //UPDATE CLONE COUNT
  static Future<void> reportUser(
      {@required String userID, @required String reportingUser}) {
    return updateDocumentL1Array(
        collection: DBFolder.app,
        document: DBDocument.reportedUser,
        key: userID,
        entries: [reportingUser],
        action: true);
  }

  //REPORT PLANT
  static Future<void> reportPlant({
    @required String offendingPlantID,
    @required String reportingUser,
  }) {
    //create data
    Map<String, dynamic> data = {PlantKeys.isFlagged: true};

    //first flag the plant
    updateDocumentL1(
      collection: DBFolder.plants,
      document: offendingPlantID,
      data: data,
    );

    //next add stats on the reporting user
    return updateDocumentL1Array(
        collection: DBFolder.app,
        document: DBDocument.reportersPlants,
        key: reportingUser,
        entries: [offendingPlantID],
        action: true);
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
    Map<String, dynamic> data = {PlantKeys.likes: (likes + add)};
    updateDocumentL1(
        data: data, collection: DBFolder.plants, document: plantID);
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

  //METHOD TO CREATE NEW DEFAULT GROUP
//  GroupData newDefaultGroup({@required String groupName}) {
//    final group = GroupData(
//      id: groupName,
//      name: groupName,
//      collections: [],
//      order: 0,
//      color: [],
//    );
//    return group;
//  }

  //update or remove entry in plant journal
  static Future<void> journalEntryUpdate(
      {@required String documentID,
      @required String collection,
      @required String journalKey,
      @required List journals,
      @required Map entry}) {
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

    Map<String, dynamic> data = {journalKey: updatedJournal};
    //upload the updated list
    return updateDocumentL1(
      collection: collection,
      document: documentID,
      data: data,
    );
  }

  //update or remove entry in plant journal
  static Future<void> journalEntryRemove(
      {@required String documentID,
      @required String collection,
      @required String journalKey,
      @required List journals,
      @required Map entry}) {
    //remove journal if the IDs match
    journals.removeWhere(
        (element) => (element[JournalKeys.id] == entry[JournalKeys.id]));

    //package changes
    Map<String, dynamic> data = {journalKey: journals};

    //upload the updated list
    return updateDocumentL1(
      collection: collection,
      document: documentID,
      data: data,
    );
  }

  //CREATE A DOCUMENT
//  Future<void> createDocument(
//      {@required Map data, @required String collection}) {
//    try {
//      return _db.collection(collection).doc().set(
//            data.cast<String, dynamic>(),
//          );
//    } catch (e) {
//      print(e);
//      return null;
//    }
//  }

  //*****************GENERAL*****************
  static Map<String, dynamic> userFeedback({
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
