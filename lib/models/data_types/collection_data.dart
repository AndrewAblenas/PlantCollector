import 'package:flutter/material.dart';

//*****************COLLECTION*****************

class CollectionKeys {
  //KEYS
  static const String id = 'collectionID';
  static const String name = 'collectionName';
  static const String plants = 'collectionPlantList';
  static const String creator = 'collectionCreatorID';
  static const String color = 'collectionColor';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'Collection ID',
    name: 'Name',
    plants: 'Plant List',
    creator: 'Creator',
    color: 'Color',
  };
}

class CollectionData {
  //VARIABLES
  final String id;
  final String name;
  final List plants;
  final String creator;
  final List<dynamic> color;

  //CONSTRUCTOR
  CollectionData({
    @required this.id,
    @required this.name,
    @required this.plants,
    @required this.creator,
    @required this.color,
  });

  //TO MAP
  Map<String, dynamic> toMap() {
    return {
      CollectionKeys.id: id,
      CollectionKeys.name: name,
      CollectionKeys.plants: plants,
      CollectionKeys.creator: creator,
      CollectionKeys.color: color,
    };
  }

  //FROM MAP
  static CollectionData fromMap({@required Map map}) {
    return CollectionData(
      id: map[CollectionKeys.id] ?? '',
      name: map[CollectionKeys.name] ?? '',
      plants: map[CollectionKeys.plants] ?? [],
      creator: map[CollectionKeys.creator] ?? '',
      color: map[CollectionKeys.color] ?? [],
    );
  }
}
