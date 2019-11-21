import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:flutter/material.dart';

class CloudDB extends ChangeNotifier {
  //initialize Firestore instance
  static Firestore _db = Firestore.instance;
  //path variable
  static String path = 'users';

  //stream savers
  List<Map> groups;
  List<Map> collections;
  List<Map> plants;

  //variables
  String userID;
  String newDataInput;
  List<List<Map>> libraryBundle;

  //*****************INITIALIZE*****************

  //this is to provide the user ID to this class
  void setUserID({@required String uid}) {
    userID = uid;
  }

  //*****************REFERENCES*****************

  //expose the db
  DocumentReference getDB() {
    return _db.collection(path).document(userID);
  }

  //*****************STREAMS*****************

  //provide a stream of all plants
  Stream<QuerySnapshot> streamPlants() {
    return _db
        .collection(path)
        .document(userID)
        .collection(kUserPlants)
        .snapshots();
  }

  //provide a stream of one specific plant document
  Stream<DocumentSnapshot> streamPlant({@required plantID}) {
    return _db
        .collection(path)
        .document(userID)
        .collection(kUserPlants)
        .document(plantID)
        .snapshots();
  }

  //provide a stream of all groups
  Stream<QuerySnapshot> streamGroups() {
    return _db
        .collection(path)
        .document(userID)
        .collection(kUserGroups)
        .snapshots();
  }

  //provide a stream of all collections
  Stream<QuerySnapshot> streamCollections() {
    return _db
        .collection(path)
        .document(userID)
        .collection(kUserCollections)
        .snapshots();
  }

  //*****************ADD USER INTO DB*****************

  //create a user document and save to db upon registration
  Future<void> addDocument({@required Map data, @required String userID}) {
    String userDoc = userID;
    //look into database instance, then collection, for ID, create if doesn't exist
    return _db.collection(path).document(userDoc).setData(data);
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
    String userDoc = userID;
    _db
        .collection(path)
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
  List<Map> getGroupCollections(
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
    String userDoc = userID;

    final DocumentReference docRef = _db
        .collection(path)
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
    String userDoc = userID;
    //create, write, and/or merge
    return _db
        .collection(path)
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
    String userDoc = userID;
    //create, write, and/or merge
    return _db
        .collection(path)
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
      String userDoc = userID;
      //create, write, and/or merge
      if (action == true) {
        return await _db
            .collection(path)
            .document(userDoc)
            .collection(folder)
            .document(documentName)
            .updateData({arrayKey: FieldValue.arrayUnion(entries)});
      } else if (action == false) {
        return await _db
            .collection(path)
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
    String userDoc = userID;
    return _db
        .collection(path)
        .document(userDoc)
        .collection(collection)
        .document(documentID)
        .delete();
  }

  //query all documents in specific collection
  Future<QuerySnapshot> getCollection({@required String collection}) async {
    String userDoc = userID;
    return _db
        .collection(path)
        .document(userDoc)
        .collection('$collection')
        .getDocuments();
  }

  //delete all documents in specific collection
  Future<void> deleteCollection({@required String collection}) {
    String userDoc = userID;
    return _db
        .collection(path)
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
    return _db.collection(path).document(id).delete();
  }

  //UPDATE AN EXISTING DOCUMENT
  Future<void> updateDocument({@required Map data}) {
    return _db.collection(path).document(userID).updateData(data);
  }

  //SECTION END
}
