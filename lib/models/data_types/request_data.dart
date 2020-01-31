import 'package:flutter/material.dart';

//*****************REQUEST*****************

class RequestKeys {
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
class RequestData {
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
  RequestData({
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
      RequestKeys.id: id,
      RequestKeys.email: email,
      RequestKeys.name: name,
      RequestKeys.avatar: avatar,
      RequestKeys.background: background,
      RequestKeys.plants: plants,
      RequestKeys.collections: collections,
      RequestKeys.groups: groups,
    };
  }

  //FROM MAP
  static RequestData fromMap({@required Map map}) {
    return RequestData(
      id: map[RequestKeys.id] ?? '',
      email: map[RequestKeys.email] ?? '',
      name: map[RequestKeys.name] ?? '',
      avatar: map[RequestKeys.avatar] ?? '',
      background: map[RequestKeys.background] ?? '',
      plants: map[RequestKeys.plants] ?? 0,
      collections: map[RequestKeys.collections] ?? 0,
      groups: map[RequestKeys.groups] ?? 0,
    );
  }
}
