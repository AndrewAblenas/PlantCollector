import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/base_type.dart';

//*****************PLANT*****************

class JournalKeys {
  //KEYS
  static const String id = 'id';
  static const String date = 'date';
  static const String title = 'title';
  static const String entry = 'entry';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'Journal ID',
    date: 'Date of Entry',
    title: 'Title of Entry',
    entry: 'Body of Entry',
  };
}

class JournalData {
  //VARIABLES
  final String id;
  final String date;
  final String title;
  final String entry;

  //CONSTRUCTOR
  JournalData({
    @required this.id,
    @required this.date,
    @required this.title,
    @required this.entry,
  });

  //TO MAP
  Map<String, dynamic> toMap() {
    return {
      JournalKeys.id: id,
      JournalKeys.date: date,
      JournalKeys.title: title,
      JournalKeys.entry: entry,
    };
  }

  //FROM MAP
  static JournalData fromMap({@required map}) {
    if (map != null) {
      return JournalData(
        id: DV.isString(value: map[JournalKeys.id]),
        date: DV.isString(value: map[JournalKeys.date]),
        title: DV.isString(value: map[JournalKeys.title]),
        entry: DV.isString(value: map[JournalKeys.entry]),
      );
    } else {
      return JournalData(id: '', date: '', title: '', entry: '');
    }
  }
}
