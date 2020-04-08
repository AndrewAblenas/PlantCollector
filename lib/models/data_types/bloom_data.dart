import 'package:flutter/material.dart';

//*****************BLOOM*****************

class BloomKeys {
  //KEYS
  static const String bud = 'bud';
  static const String first = 'first';
  static const String last = 'last';
  static const String seed = 'seed';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    bud: 'Initial Buds',
    first: 'First Bloom',
    last: 'Last Bloom',
    seed: 'Seeds Mature',
  };

  //INDEX
//  static const Map<String, int> indices = {
//    bud: 0,
//    first: 1,
//    last: 2,
//    seed: 3,
//  };
}

//CLASS
class BloomData {
  //VARIABLES
  final int bud;
  final int first;
  final int last;
  final int seed;

  //CONSTRUCTOR
  BloomData({
    @required this.bud,
    @required this.first,
    @required this.last,
    @required this.seed,
  });

  //TO MAP
  Map toMap() {
    Map<String, dynamic> map = {
      BloomKeys.bud: bud,
      BloomKeys.first: first,
      BloomKeys.last: last,
      BloomKeys.seed: seed,
    };
    return map;
  }

  //FROM MAP
  static BloomData fromMap({@required Map map}) {
    if (map != null) {
      return BloomData(
        bud: map[BloomKeys.bud] ?? 0,
        first: map[BloomKeys.first] ?? 0,
        last: map[BloomKeys.last] ?? 0,
        seed: map[BloomKeys.seed] ?? 0,
      );
    } else {
      return BloomData(
        bud: 0,
        first: 0,
        last: 0,
        seed: 0,
      );
    }
  }
}
