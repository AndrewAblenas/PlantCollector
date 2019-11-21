import 'package:flutter/material.dart';
import 'package:plant_collector/models/constants.dart';
import 'dart:core';

//USER CLASS
class User {
  //VARIABLES
  final String userID;
  final String userFirstName;
  final String userLastName;
  final String userEmail;
  User({
    @required this.userID,
    this.userFirstName,
    this.userLastName,
    @required this.userEmail,
  });
  //CONVERT USER TO MAP
  Map<String, dynamic> toMap() {
    return {
      '$kUserID': userID ?? '',
      '$kUserFirstName': userFirstName ?? '',
      '$kUserLastName': userLastName ?? '',
      '$kUserEmail': userEmail ?? '',
    };
  }
}

//USER FROM MAP
User userFromMap({@required userMap}) {
  return User(
    userID: userMap[kUserID],
    userFirstName: userMap[kUserFirstName],
    userLastName: userMap[kUserLastName],
    userEmail: userMap[kUserEmail],
  );
}

//PLANT CLASS
class Plant {
  //VARIABLES
  final String plantID;
  final String plantName;
  final String plantVariety;
  final String plantGenus;
  final String plantSpecies;
  final String plantQuantity;
  final String plantNotes;
  final String plantThumbnail;
  final List plantImageList;
  //CONSTRUCTOR
  Plant({
    @required this.plantID,
    @required this.plantName,
    this.plantVariety,
    this.plantGenus,
    this.plantSpecies,
    this.plantQuantity,
    this.plantNotes,
    this.plantThumbnail,
    this.plantImageList,
  });
  //METHODS
  //CONVERT PLANT TO MAP - MUST MATCH DB COLUMNS!
  Map<String, dynamic> toMap() {
    return {
      '$kPlantID': plantID,
      '$kPlantName': plantName,
      '$kPlantVariety': plantVariety,
      '$kPlantGenus': plantGenus,
      '$kPlantSpecies': plantSpecies,
      '$kPlantQuantity': plantQuantity,
      '$kPlantNotes': plantNotes,
      '$kPlantThumbnail': plantThumbnail,
      '$kPlantImageList': plantImageList,
    };
  }
}

//PLANT FROM MAP
Plant plantFromMap({@required plantMap}) {
  return Plant(
    plantID: plantMap[kPlantID],
    plantName: plantMap[kPlantName],
    plantVariety: plantMap[kPlantVariety],
    plantGenus: plantMap[kPlantGenus],
    plantSpecies: plantMap[kPlantSpecies],
    plantQuantity: plantMap[kPlantQuantity],
    plantNotes: plantMap[kPlantNotes],
    plantThumbnail: plantMap[kPlantThumbnail],
    plantImageList: plantMap[kPlantImageList],
  );
}

//PLANT MAP CONSTRUCTOR FROM SNAPSHOT
Map plantMapFromSnapshot({@required Map plantMap}) {
  return {
    kPlantID: plantMap[kPlantID],
    kPlantName: plantMap[kPlantName],
    kPlantVariety: plantMap[kPlantVariety],
    kPlantGenus: plantMap[kPlantGenus],
    kPlantSpecies: plantMap[kPlantSpecies],
    kPlantQuantity: plantMap[kPlantQuantity],
    kPlantNotes: plantMap[kPlantNotes],
    kPlantThumbnail: plantMap[kPlantThumbnail],
    kPlantImageList: plantMap[kPlantImageList],
  };
}

//COLLECTION CLASS
class Collection {
  //VARIABLES
  final String collectionID;
  final String collectionName;
  final List collectionPlantList;
  final String collectionCreatorID;
  //CONSTRUCTOR
  Collection({
    @required this.collectionID,
    @required this.collectionName,
    @required this.collectionPlantList,
    @required this.collectionCreatorID,
  });
  //METHODS
  //CONVERT COLLECTION TO MAP - MUST MATCH DB COLUMNS!
  Map<String, dynamic> toMap() {
    return {
      '$kCollectionID': collectionID,
      '$kCollectionName': collectionName,
      '$kCollectionPlantList': collectionPlantList ?? [],
      '$kCollectionCreatorID': collectionCreatorID,
    };
  }
}

//COLLECTION FROM MAP
Collection collectionFromMap({@required collectionMap}) {
  return Collection(
    collectionID: collectionMap[kCollectionID],
    collectionName: collectionMap[kCollectionName],
    collectionPlantList: collectionMap[kCollectionPlantList],
    collectionCreatorID: collectionMap[kCollectionCreatorID],
  );
}

//COLLECTION MAP CONSTRUCTOR FROM SNAPSHOT
Map collectionMapFromSnapshot({@required Map collectionMap}) {
  return {
    kCollectionID: collectionMap[kCollectionID],
    kCollectionName: collectionMap[kCollectionName],
    kCollectionPlantList: collectionMap[kCollectionPlantList],
    kCollectionCreatorID: collectionMap[kCollectionCreatorID],
  };
}

//GROUP CLASS
class Group {
  //Variables
  final String groupID;
  final String groupName;
  final List<String> groupCollectionList;
  final int groupOrder;
  final List<int> groupColor;

  //Constructor
  Group(
      {@required this.groupID,
      @required this.groupName,
      this.groupCollectionList,
      this.groupOrder,
      this.groupColor});

  //Methods
  //Convert group to map
  Map<String, dynamic> toMap() {
    return {
      '$kGroupID': groupID,
      '$kGroupName': groupName,
      '$kGroupCollectionList': groupCollectionList ?? [],
      '$kGroupOrder': groupOrder,
      '$kGroupColor': groupColor,
    };
  }
}

//GROUP FROM MAP
Group groupFromMap({@required groupMap}) {
  return Group(
    groupID: groupMap[kGroupID],
    groupName: groupMap[kGroupName],
    groupCollectionList: groupMap[kGroupCollectionList],
    groupOrder: groupMap[kGroupOrder],
    groupColor: groupMap[kGroupColor],
  );
}

//GROUP MAP CONSTRUCTOR FROM SNAPSHOT
Map groupMapFromSnapshot({@required Map groupMap}) {
  return {
    kGroupID: groupMap[kGroupID],
    kGroupName: groupMap[kGroupName],
    kGroupCollectionList: groupMap[kGroupCollectionList],
    kGroupOrder: groupMap[kGroupOrder],
    kGroupColor: groupMap[kGroupColor],
  };
}
