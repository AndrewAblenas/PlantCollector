import 'package:flutter/material.dart';
import 'package:plant_collector/models/constants.dart';
import 'dart:core';

//USER CLASS
class User {
  //VARIABLES
  final String userID;
  final String userName;
  final String userEmail;
  final String userAvatar;
  final String userBackground;
  final String userTotalPlants;
  final String userTotalCollections;
  final String userTotalGroups;
//  final List<String> userRequestsList;
//  final List<String> userConnectionsList;
  //Constructor
  User({
    @required this.userID,
    this.userName,
    @required this.userEmail,
    this.userAvatar,
    this.userBackground,
    this.userTotalPlants,
    this.userTotalCollections,
    this.userTotalGroups,
//      this.userRequestsList,
//      this.userConnectionsList
  });
  //CONVERT USER TO MAP
  Map<String, dynamic> toMap() {
    return {
      kUserID: userID,
      kUserName: userName,
      kUserEmail: userEmail,
      kUserAvatar: userAvatar,
      kUserBackground: userBackground,
      kUserTotalPlants: userTotalPlants,
      kUserTotalCollections: userTotalCollections,
      kUserTotalGroups: userTotalGroups,
//      kUserRequestsList: userRequestsList,
//      kUserConnectionsList: userConnectionsList,
    };
  }
}

//USER FROM MAP
User userFromMap({@required userMap}) {
  return User(
    userID: userMap[kUserID],
    userName: userMap[kUserName],
    userEmail: userMap[kUserEmail],
    userAvatar: userMap[kUserAvatar],
    userBackground: userMap[kUserAvatar],
    userTotalPlants: userMap[kUserTotalPlants],
    userTotalCollections: userMap[kUserTotalCollections],
    userTotalGroups: userMap[kUserTotalGroups],
//    userRequestsList: userMap[kUserRequestsList],
//    userConnectionsList: userMap[kUserConnectionsList],
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

//CONNECTIONS CLASS
class Connection {
  //Variables
  final String connectionID;
  final bool connectionShare;
  final bool connectionChat;

  //Constructor
  Connection({
    @required this.connectionID,
    this.connectionShare,
    this.connectionChat,
  });

  //Convert connection to map
  Map<String, dynamic> toMap() {
    return {
      '$kConnectionID': connectionID,
      '$kConnectionShare': connectionShare,
      '$kConnectionChat': connectionChat,
    };
  }
}

//Connection from map
Connection connectionFromMap({@required Map connectionMap}) {
  return Connection(
    connectionID: connectionMap[kConnectionID],
    connectionShare: connectionMap[kConnectionShare],
    connectionChat: connectionMap[kConnectionChat],
  );
}

//GROUP MAP CONSTRUCTOR FROM SNAPSHOT
Map connectionMapFromSnapshot({@required Map connectionMap}) {
  return {
    kConnectionID: connectionMap[kConnectionID],
    kConnectionShare: connectionMap[kConnectionShare],
    kConnectionChat: connectionMap[kConnectionChat],
  };
}
