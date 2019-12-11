import 'package:flutter/material.dart';

//*****************USER*****************

class UserKeys {
  //KEYS
  static const String id = 'userID';
  static const String name = 'userName';
  static const String email = 'userEmail';
  static const String avatar = 'userAvatar';
  static const String background = 'userBackground';
  static const String plants = 'userTotalPlants';
  static const String collections = 'userTotalCollections';
  static const String groups = 'userTotalGroups';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'ID',
    name: 'Name',
    email: 'Email',
    avatar: 'Avatar',
    background: 'Background',
    plants: 'Total Plants',
    collections: 'Total Collections',
    groups: 'Total Groups',
  };
}

//CLASS
class UserData {
  //VARIABLES
  final String id;
  final String email;
  final String name;
  final String avatar;
  final String background;
  final int plants;
  final int collections;
  final int groups;

  //CONSTRUCTOR
  UserData({
    @required this.id,
    @required this.email,
    this.name,
    this.avatar,
    this.background,
    this.plants,
    this.collections,
    this.groups,
  });

  //TO MAP
  Map<String, dynamic> toMap() {
    return {
      UserKeys.id: id,
      UserKeys.email: email,
      UserKeys.name: name,
      UserKeys.avatar: avatar,
      UserKeys.background: background,
      UserKeys.plants: plants,
      UserKeys.collections: collections,
      UserKeys.groups: groups,
    };
  }

  //FROM MAP
  static UserData fromMap({@required Map map}) {
    return UserData(
      id: map[UserKeys.id] ?? '',
      email: map[UserKeys.email] ?? '',
      name: map[UserKeys.name] ?? '',
      avatar: map[UserKeys.avatar] ?? '',
      background: map[UserKeys.background] ?? '',
      plants: map[UserKeys.plants] ?? 0,
      collections: map[UserKeys.collections] ?? 0,
      groups: map[UserKeys.groups] ?? 0,
    );
  }
}
