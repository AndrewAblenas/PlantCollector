import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/base_type.dart';

//*****************CONNECTION*****************

class FriendKeys {
  //KEYS
  static const String id = 'userID';
  static const String name = 'userName';
  static const String avatar = 'userAvatar';
  static const String share = 'shareLibrary';
  static const String chatAllowed = 'chatAllowed';
  static const String chatStarted = 'chatStarted';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'Friend ID',
    name: 'Name',
    avatar: 'Avatar',
    share: 'Library Shared',
    chatAllowed: 'Chat Allowed',
    chatStarted: 'Actively Chatting',
  };
}

//CLASS
class FriendData {
  //VARIABLES
  final String id;
  final String name;
  final String avatar;
  final bool share;
  final bool chatAllowed;
  final bool chatStarted;

  //CONSTRUCTOR
  FriendData({
    @required this.id,
    this.name,
    this.avatar,
    this.share,
    this.chatAllowed,
    this.chatStarted,
  });

  //TO MAP
  Map<String, dynamic> toMap() {
    return {
      FriendKeys.id: id,
      FriendKeys.name: name,
      FriendKeys.avatar: avatar,
      FriendKeys.share: share,
      FriendKeys.chatAllowed: chatAllowed,
      FriendKeys.chatStarted: chatStarted,
    };
  }

  //FROM MAP
  static FriendData fromMap({@required Map map}) {
    if (map != null) {
      return FriendData(
        id: DV.isString(value: map[FriendKeys.id]),
        name: DV.isString(value: map[FriendKeys.name]),
        avatar: DV.isString(value: map[FriendKeys.avatar]),
        share: DV.isBool(value: map[FriendKeys.share]),
        chatAllowed:
            DV.isBool(value: map[FriendKeys.chatAllowed], fallback: true),
        chatStarted: DV.isBool(value: map[FriendKeys.chatStarted]),
      );
    } else {
      return FriendData(id: '');
    }
  }
}
