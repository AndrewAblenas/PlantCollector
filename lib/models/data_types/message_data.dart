import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/base_type.dart';

//*****************MESSAGE*****************

class MessageParentKeys {
  //KEYS
  static const String participants = 'participants';
  static const String unreadBy = 'unreadBy';
  static const String initialRequestPushTokens = 'initialRequestPushTokens';
}

class MessageKeys {
  //KEYS
  static const String sender = 'messageSender';
  static const String senderName = 'senderName';
  static const String targetDevices = 'targetDevices';
  static const String recipient = 'recipient';
  static const String time = 'messageTime';
  static const String text = 'messageText';
  static const String read = 'messageRead';
  static const String type = 'messageType';
  static const String media = 'messageMedia';

  //DESCRIPTORS
  static const Map<String, String> kUserKeyDescriptorsMap = {
    sender: 'Sender ID',
    senderName: 'Sender Name',
    targetDevices: 'Target Device List',
    recipient: 'Recipient Name',
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
  final String senderName;
  final List targetDevices;
  final String recipient;
  final int time;
  final String text;
  final bool read;
  final String type;
  final String media;

  //CONSTRUCTOR
  MessageData({
    @required this.sender,
    @required this.senderName,
    @required this.targetDevices,
    @required this.recipient,
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
      MessageKeys.senderName: senderName,
      MessageKeys.targetDevices: targetDevices,
      MessageKeys.recipient: recipient,
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
        senderName: DV.isString(value: map[MessageKeys.senderName]),
        targetDevices: DV.isList(value: map[MessageKeys.targetDevices]),
        recipient: DV.isString(value: map[MessageKeys.recipient]),
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
          sender: '',
          time: 0,
          text: '',
          senderName: '',
          targetDevices: [],
          recipient: '',
          read: false,
          type: '',
          media: '');
    }
  }
}
