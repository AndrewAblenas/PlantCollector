import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/base_type.dart';

//*****************IMAGE*****************

class ImageKeys {
  //KEYS
  static const String date = 'date';
  static const String full = 'full';
  static const String thumb = 'thumb';

  //LIST
  static const List<String> list = [date, full, thumb];

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    date: 'Date Taken',
    full: 'Full Sized Image',
    thumb: 'Thumbnail Sized Image',
  };
}

//CLASS
class ImageData {
  //VARIABLES
  final int date;
  final String full;
  final String thumb;

  //CONSTRUCTOR
  ImageData({
    @required this.date,
    @required this.full,
    @required this.thumb,
  });

  //TO MAP
  Map toMap() {
    Map<String, dynamic> map = {
      ImageKeys.date: date,
      ImageKeys.full: full,
      ImageKeys.thumb: thumb,
    };
    return map;
  }

  //FROM MAP
  static ImageData fromMap({@required Map map}) {
    if (map != null) {
      return ImageData(
        date: DV.isInt(value: map[ImageKeys.date]),
        full: DV.isString(value: map[ImageKeys.full]),
        thumb: DV.isString(value: map[ImageKeys.thumb]),
      );
    } else {
      return ImageData(
        date: 0,
        full: '',
        thumb: '',
      );
    }
  }
}
