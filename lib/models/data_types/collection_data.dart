import 'package:flutter/material.dart';

//*****************COLLECTION*****************

class CollectionKeys {
  //KEYS
  static const String id = 'collectionID';
  static const String name = 'collectionName';
  static const String plants = 'collectionPlantList';
  static const String creator = 'collectionCreatorID';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'Collection ID',
    name: 'Name',
    plants: 'Plant List',
    creator: 'Creator'
  };
}

class CollectionData {
  //VARIABLES
  final String id;
  final String name;
  final List plants;
  final String creator;

  //CONSTRUCTOR
  CollectionData({
    @required this.id,
    @required this.name,
    @required this.plants,
    @required this.creator,
  });

  //TO MAP
  Map<String, dynamic> toMap() {
    return {
      CollectionKeys.id: id,
      CollectionKeys.name: name,
      CollectionKeys.plants: plants,
      CollectionKeys.creator: creator,
    };
  }

  //FROM MAP
  static CollectionData fromMap({@required Map map}) {
    return CollectionData(
      id: map[CollectionKeys.id] ?? '',
      name: map[CollectionKeys.name] ?? '',
      plants: map[CollectionKeys.plants] ?? [],
      creator: map[CollectionKeys.creator] ?? '',
    );
  }
}
