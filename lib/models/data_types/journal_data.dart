import 'package:flutter/material.dart';

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
        id: map[JournalKeys.id] ?? '',
        date: map[JournalKeys.date] ?? '',
        title: map[JournalKeys.title] ?? '',
        entry: map[JournalKeys.entry] ?? '',
      );
    } else {
      return JournalData(id: '', date: '', title: '', entry: '');
    }
  }
}
