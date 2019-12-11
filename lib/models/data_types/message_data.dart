import 'package:flutter/material.dart';

//*****************MESSAGE*****************

class MessageKeys {
  //KEYS
  static const String sender = 'messageSender';
  static const String time = 'messageTime';
  static const String text = 'messageText';
  static const String read = 'messageRead';
  static const String type = 'messageType';
  static const String media = 'messageMedia';

  //DESCRIPTORS
  static const Map<String, String> kUserKeyDescriptorsMap = {
    sender: 'Sender ID',
    time: 'Timestamp',
    text: 'Message Text',
    read: 'Has the Recipient Read?',
    type: 'Type of Message Content',
    media: 'URL, Sticker, or Plant ID',
  };

  //TYPES
  static const String typeText = 'typeText';
  static const String typeUrl = 'typeUrl';
  static const String typePhoto = 'typePhoto';
  static const String typeSticker = 'typeSticker';
  static const String typePlant = 'typePlant';
}

//CLASS
class MessageData {
  //VARIABLES
  final String sender;
  final int time;
  final String text;
  final bool read;
  final String type;
  final String media;

  //CONSTRUCTOR
  MessageData({
    @required this.sender,
    @required this.time,
    @required this.text,
    @required this.read,
    @required this.type,
    @required this.media,
  });

  //TO MAP
  Map<String, dynamic> toMap() {
    return {
      MessageKeys.sender: sender,
      MessageKeys.time: time,
      MessageKeys.text: text,
      MessageKeys.read: read,
      MessageKeys.type: type,
      MessageKeys.media: media,
    };
  }

  //FROM MAP
  static MessageData fromMap({@required Map map}) {
    return MessageData(
      sender: map[MessageKeys.sender] ?? '',
      time: map[MessageKeys.time] ?? 0,
      text: map[MessageKeys.text] ?? '',
      read: map[MessageKeys.read] ?? false,
      //if there is no media attachment, default message type to text
      type: map[MessageKeys.type] ?? MessageKeys.typeText,
      media: map[MessageKeys.media] ?? '',
    );
  }
}
