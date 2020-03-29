import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';

//*****************MESSAGE*****************

class CommunicationKeys {
  //KEYS
  static const String subject = 'subject';
  static const String text = 'text';
  static const String read = 'read';
  static const String type = 'type';
  static const String icon = 'icon';
  static const String date = 'date';
  static const String visible = 'visible';
  static const String reference = 'reference';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    subject: 'Message Subject',
    text: 'Message Text',
    read: 'Has the Recipient Read the Message',
    type: 'Importance of Message',
    icon: 'Message Icon',
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
  final Icon icon;
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
    @required this.icon,
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
    Icon icon;
    String type = map[CommunicationKeys.type];
    if (type == CommunicationTypes.standard) {
      icon = Icon(
        Icons.message,
        color: kGreenDark,
      );
    } else if (type == CommunicationTypes.alert) {
      icon = Icon(
        Icons.error,
        color: Colors.orange,
      );
    } else if (type == CommunicationTypes.warning) {
      icon = Icon(
        Icons.warning,
        color: Colors.red,
      );
    } else {
      icon = Icon(
        Icons.message,
        color: kGreenDark,
      );
    }
    return CommunicationData(
        subject: map[CommunicationKeys.subject] ?? '',
        text: map[CommunicationKeys.text] ?? '',
        read: map[CommunicationKeys.read] ?? false,
        type: map[CommunicationKeys.type] ?? CommunicationTypes.standard,
        icon: icon,
        date: map[CommunicationKeys.date] ?? '2020-01-01',
        visible: map[CommunicationKeys.visible] ?? false,
        //locally added in stream CloudDB
        reference: map[CommunicationKeys.reference] ?? null);
  }
}
