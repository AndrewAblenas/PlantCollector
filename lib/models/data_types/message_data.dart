import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/base_type.dart';

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
    if (map != null) {
      return MessageData(
        sender: DV.isString(value: map[MessageKeys.sender]),
        time: DV.isInt(value: map[MessageKeys.time]),
        text: DV.isString(value: map[MessageKeys.text]),
        read: DV.isBool(value: map[MessageKeys.read]),
        //if there is no media attachment, default message type to text
        type: DV.isString(
            value: map[MessageKeys.type], fallback: MessageKeys.typeText),
        media: DV.isString(value: map[MessageKeys.media]),
      );
    } else {
      return MessageData(
          sender: '', time: 0, text: '', read: false, type: '', media: '');
    }
  }
}
