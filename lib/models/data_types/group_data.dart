import 'package:flutter/material.dart';

//*****************GROUP*****************
//TODO finish

class GroupKeys {
  //KEYS
  static const String id = 'groupID';
  static const String name = 'groupName';
  static const String collections = 'groupCollectionList';
  static const String order = 'groupOrder';
  static const String color = 'groupColor';
  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'Group ID',
    name: 'Name',
    collections: 'Collections',
    order: 'Order',
    color: 'Color',
  };
}

//GROUP CLASS
class GroupData {
  //VARIABLES
  final String id;
  final String name;
  final List<dynamic> collections;
  final int order;
  final List<dynamic> color;

  //CONSTRUCTOR
  GroupData(
      {@required this.id,
      @required this.name,
      this.collections,
      this.order,
      this.color});

  //TO MAP
  Map<String, dynamic> toMap() {
    return {
      GroupKeys.id: id,
      GroupKeys.name: name,
      GroupKeys.collections: collections,
      GroupKeys.order: order,
      GroupKeys.color: color,
    };
  }

  //FROM MAP
  static GroupData fromMap({@required Map map}) {
    return GroupData(
      id: map[GroupKeys.id] ?? '',
      name: map[GroupKeys.name] ?? '',
      collections: map[GroupKeys.collections] ?? [],
      order: map[GroupKeys.order] ?? 0,
      color: map[GroupKeys.color] ?? [],
    );
  }
}
