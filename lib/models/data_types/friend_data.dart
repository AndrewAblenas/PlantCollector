import 'package:flutter/material.dart';

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
    return FriendData(
      id: map[FriendKeys.id] ?? '',
      name: map[FriendKeys.name] ?? '',
      avatar: map[FriendKeys.avatar] ?? '',
      share: map[FriendKeys.share] ?? false,
      chatAllowed: map[FriendKeys.chatAllowed] ?? true,
      chatStarted: map[FriendKeys.chatStarted] ?? false,
    );
  }
}
