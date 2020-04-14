import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/base_type.dart';

//*****************MESSAGE*****************

class CommunicationKeys {
  //KEYS
  static const String subject = 'subject';
  static const String text = 'text';
  static const String read = 'read';
  static const String type = 'type';
  static const String date = 'date';
  static const String visible = 'visible';
  static const String reference = 'reference';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    subject: 'Message Subject',
    text: 'Message Text',
    read: 'Has the Recipient Read the Message',
    type: 'Importance of Message',
    date: 'Date Message Sent',
    visible: 'Is the Message Visible',
    reference: 'DB Reference'
  };
}

//COMMUNICATION TYPES
class CommunicationTypes {
  //KEYS
  static const String standard = 'standard';
  static const String alert = 'alert';
  static const String warning = 'warning';
}

//CLASS
class CommunicationData {
  //VARIABLES
  final String subject;
  final String text;
  final bool read;
  final String type;
  final String date;
  final bool visible;
  //added in app
  final DocumentReference reference;

  //CONSTRUCTOR
  CommunicationData({
    @required this.subject,
    @required this.text,
    @required this.read,
    @required this.type,
    @required this.date,
    @required this.visible,
    //added in app
    @required this.reference,
  });

  //TO MAP
  Map<String, dynamic> toMap() {
    return {
      CommunicationKeys.subject: subject,
      CommunicationKeys.text: text,
      CommunicationKeys.read: read,
      CommunicationKeys.type: type,
      CommunicationKeys.date: date,
      CommunicationKeys.visible: visible,
      //added in app
      CommunicationKeys.reference: reference,
    };
  }

  //FROM MAP
  static CommunicationData fromMap({@required Map map}) {
    if (map != null) {
      return CommunicationData(
          subject: DV.isString(value: map[CommunicationKeys.subject]),
          text: DV.isString(value: map[CommunicationKeys.text]),
          read: DV.isBool(value: map[CommunicationKeys.read]),
          type: DV.isString(
              value: map[CommunicationKeys.type],
              fallback: CommunicationTypes.standard),
          date: DV.isString(
              value: map[CommunicationKeys.date], fallback: '2020-01-01'),
          visible: DV.isBool(value: map[CommunicationKeys.visible]),
          //locally added in stream CloudDB
          reference: map[CommunicationKeys.reference] ?? null);
    } else {
      return CommunicationData(
          subject: '',
          text: '',
          read: false,
          type: '',
          date: '',
          visible: false,
          reference: null);
    }
  }
}
