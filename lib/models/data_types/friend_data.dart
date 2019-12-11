import 'package:flutter/material.dart';

//*****************CONNECTION*****************

class FriendKeys {
  //KEYS
  static const String id = 'userID';
  static const String share = 'share';
  static const String chat = 'chat';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'Friend ID',
    share: 'Library Shared',
    chat: 'Chat Allowed',
  };
}

//CLASS
class FriendData {
  //VARIABLES
  final String id;
  final bool share;
  final bool chat;

  //CONSTRUCTOR
  FriendData({
    @required this.id,
    this.share,
    this.chat,
  });

  //TO MAP
  Map<String, dynamic> toMap() {
    return {
      FriendKeys.id: id,
      FriendKeys.share: share,
      FriendKeys.chat: chat,
    };
  }

  //FROM MAP
  static FriendData fromMap({@required Map map}) {
    return FriendData(
      id: map[FriendKeys.id] ?? '',
      share: map[FriendKeys.share] ?? false,
      chat: map[FriendKeys.chat] ?? false,
    );
  }
}
