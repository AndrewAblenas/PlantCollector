import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/base_type.dart';

//*****************GROUP*****************

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
    if (map != null) {
      return GroupData(
        id: DV.isString(value: map[GroupKeys.id]),
        name: DV.isString(value: map[GroupKeys.name]),
        collections: DV.isList(value: map[GroupKeys.collections]),
        order: DV.isInt(value: map[GroupKeys.order]),
        color: DV.isList(value: map[GroupKeys.color]),
      );
    } else {
      return GroupData(id: '', name: '');
    }
  }
}
