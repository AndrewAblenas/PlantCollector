import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/base_type.dart';

//*****************BLOOM*****************

class GrowthKeys {
  //KEYS
  static const String start = 'start';
  static const String mature = 'mature';
  static const String dormant = 'dormant';

  //LIST
  static const List<String> list = [start, mature, dormant];

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    start: 'New Growth',
    mature: 'Growth Mature',
    dormant: 'Dormancy Begins',
  };
}

//CLASS
class GrowthData {
  //VARIABLES
  final int start;
  final int mature;
  final int dormant;

  //CONSTRUCTOR
  GrowthData({
    @required this.start,
    @required this.mature,
    @required this.dormant,
  });

  //TO MAP
  Map toMap() {
    Map<String, dynamic> map = {
      GrowthKeys.start: start,
      GrowthKeys.mature: mature,
      GrowthKeys.dormant: dormant,
    };
    return map;
  }

  //FROM MAP
  static GrowthData fromMap({@required Map map}) {
    if (map != null) {
      return GrowthData(
        start: DV.isInt(value: map[GrowthKeys.start]),
        mature: DV.isInt(value: map[GrowthKeys.mature]),
        dormant: DV.isInt(value: map[GrowthKeys.dormant]),
      );
    } else {
      return GrowthData(
        start: 0,
        mature: 0,
        dormant: 0,
      );
    }
  }
}
