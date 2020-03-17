import 'package:flutter/material.dart';

//*****************USER*****************

UserData testUser = UserData(
  id: 'ID STRING',
  email: 'EMAIL',
  name: 'Alfredo try some super long name',
  region: 'Vancouver, British Columbia, Canada',
  about:
      'I specialize in growing orchids, but have a broad assortment of plants inside and out.',
);

//ACCOUNT TYPES (to enable/disable various features)
class UserTypes {
  static const String standard = 'standard';
  static const String plus = 'plus';
  static const String admin = 'admin';
  static const String creator = 'creator';
}

class UserKeys {
  //KEYS
  static const String id = 'userID';
  static const String name = 'userName';
  static const String email = 'userEmail';
  static const String type = 'userType';
  static const String join = 'userJoinDate';
  static const String about = 'userAbout';
  static const String region = 'userRegion';
  static const String avatar = 'userAvatar';
  static const String background = 'userBackground';
  static const String plants = 'userTotalPlants';
  static const String collections = 'userTotalCollections';
  static const String groups = 'userTotalGroups';
  static const String likedPlants = 'userLikedPlants';
  static const String blocked = 'userBlocked';
  static const String expandGroup = 'userCollapseGroup';
  static const String expandCollection = 'userCollapseCollection';
  static const String tags = 'userTags';
  static const String friends = 'userFriends';
  //local only
  static const String chatStarted = 'chatStarted';

  //DESCRIPTORS
  static const Map<String, String> descriptors = {
    id: 'ID',
    name: 'Name',
    email: 'Email',
    type: 'Account Type',
    join: 'Join Date',
    about: 'About',
    region: 'Region',
    avatar: 'Avatar',
    background: 'Background',
    plants: 'Total Plants',
    collections: 'Total Collections',
    groups: 'Total Groups',
    likedPlants: 'Favorite Plants List',
    blocked: 'Blocked Users List',
    expandGroup: 'Expand Groups by Default',
    expandCollection: 'Expand Collections by Default',
    tags: 'Search Tags',
    friends: 'Friends List',
    //local only
    chatStarted: 'Chat Started'
  };
}

//CLASS
class UserData {
  //VARIABLES
  final String id;
  final String name;
  final String email;
  final String type;
  final int join;
  final String about;
  final String region;
  final String avatar;
  final String background;
  final int plants;
  final int collections;
  final int groups;
  final List likedPlants;
  final List blocked;
  final bool expandGroup;
  final bool expandCollection;
  final List tags;
  final List friends;
  //local only
  final bool chatStarted;

  //CONSTRUCTOR
  UserData({
    @required this.id,
    @required this.email,
    this.name,
    this.type,
    this.join,
    this.about,
    this.region,
    this.avatar,
    this.background,
    this.plants,
    this.collections,
    this.groups,
    this.likedPlants,
    this.blocked,
    this.expandGroup,
    this.expandCollection,
    this.tags,
    this.friends,
    //local only
    this.chatStarted,
  });

  //TO MAP
  Map<String, dynamic> toMap() {
    return {
      UserKeys.id: id,
      UserKeys.email: email,
      UserKeys.name: name,
      UserKeys.type: type,
      UserKeys.join: join,
      UserKeys.about: about,
      UserKeys.region: region,
      UserKeys.avatar: avatar,
      UserKeys.background: background,
      UserKeys.plants: plants,
      UserKeys.collections: collections,
      UserKeys.groups: groups,
      UserKeys.likedPlants: likedPlants,
      UserKeys.blocked: blocked,
      UserKeys.expandGroup: expandGroup,
      UserKeys.expandCollection: expandCollection,
      UserKeys.tags: tags,
      UserKeys.friends: friends,
      //local only
      UserKeys.chatStarted: chatStarted,
    };
  }

  //FROM MAP
  static UserData fromMap({@required Map map}) {
    return UserData(
      id: map[UserKeys.id] ?? '',
      email: map[UserKeys.email] ?? '',
      name: map[UserKeys.name] ?? '',
      type: map[UserKeys.type] ?? UserTypes.standard,
      //set default to January 1, 2020
      join: map[UserKeys.join] ?? 1577836800,
      about: map[UserKeys.about] ?? '',
      region: map[UserKeys.region] ?? 'Earth',
      avatar: map[UserKeys.avatar] ?? '',
      background: map[UserKeys.background] ?? '',
      plants: map[UserKeys.plants] ?? 0,
      collections: map[UserKeys.collections] ?? 0,
      groups: map[UserKeys.groups] ?? 0,
      likedPlants: map[UserKeys.likedPlants] ?? [],
      blocked: map[UserKeys.blocked] ?? [],
      expandGroup: map[UserKeys.expandGroup] ?? true,
      expandCollection: map[UserKeys.expandCollection] ?? true,
      tags: map[UserKeys.tags] ?? [],
      friends: map[UserKeys.friends] ?? [],
      //local only
      chatStarted: map[UserKeys.chatStarted] ?? false,
    );
  }
}
