import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/base_type.dart';

//*****************BLOOM*****************

class BloomKeys {
  //KEYS
  static const String bud = 'bud';
  static const String first = 'first';
  static const String pollinate = 'pollinate';
  static const String last = 'last';
  static const String seed = 'seed';

  //LIST
  static const List<String> list = [bud, first, pollinate, last, seed];

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    bud: 'Initial Buds',
    first: 'First Bloom',
    pollinate: 'Pollination',
    last: 'Bloom Complete',
    seed: 'Seed/Fruit Mature',
  };
}

//CLASS
class BloomData {
  //VARIABLES
  final int bud;
  final int first;
  final int pollinate;
  final int last;
  final int seed;

  //CONSTRUCTOR
  BloomData({
    @required this.bud,
    @required this.first,
    @required this.pollinate,
    @required this.last,
    @required this.seed,
  });

  //TO MAP
  Map toMap() {
    Map<String, dynamic> map = {
      BloomKeys.bud: bud,
      BloomKeys.first: first,
      BloomKeys.pollinate: pollinate,
      BloomKeys.last: last,
      BloomKeys.seed: seed,
    };
    return map;
  }

  //FROM MAP
  static BloomData fromMap({@required Map map}) {
    if (map != null) {
      return BloomData(
        bud: DV.isInt(value: map[BloomKeys.bud]),
        first: DV.isInt(value: map[BloomKeys.first]),
        pollinate: DV.isInt(value: map[BloomKeys.pollinate]),
        last: DV.isInt(value: map[BloomKeys.last]),
        seed: DV.isInt(value: map[BloomKeys.seed]),
      );
    } else {
      return BloomData(
        bud: 0,
        first: 0,
        pollinate: 0,
        last: 0,
        seed: 0,
      );
    }
  }
}
