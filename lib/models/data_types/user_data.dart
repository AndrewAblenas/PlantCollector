import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/base_type.dart';

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
  static const String photos = 'userTotalPhotos';
  static const String likedPlants = 'userLikedPlants';
  static const String blocked = 'userBlocked';
  static const String expandGroup = 'userCollapseGroup';
  static const String expandCollection = 'userCollapseCollection';
  static const String tags = 'userTags';
  static const String friends = 'userFriends';
  static const String requestsSent = 'userSentRequests';
  static const String requestsReceived = 'userReceivedRequests';
  static const String chats = 'userChats';
  static const String privateLibrary = 'privateLibrary';
  static const String sortAlphabetically = 'sortCollectionsAlphabetically';
  static const String uniquePublicID = 'uniquePublicID';
  static const String lastPlantAdd = 'lastPlantAdd';
  static const String lastPlantUpdate = 'lastPlantUpdate';
  static const String showWishList = 'showWishList';
  static const String showSellList = 'showSellList';
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
    photos: 'Total Photos',
    likedPlants: 'Favorite Plants List',
    blocked: 'Blocked Users List',
    expandGroup: 'Expand Groups by Default',
    expandCollection: 'Expand Collections by Default',
    tags: 'Search Tags',
    friends: 'Friends List',
    requestsSent: 'Sent Friend Requests',
    requestsReceived: 'Received Friend Requests',
    chats: 'Friend Chats',
    privateLibrary: 'Only Allow Friends to View Library',
    sortAlphabetically: 'Display Shelves Alphabetically',
    uniquePublicID: 'Unique Public User Handle',
    lastPlantAdd: 'Date of Last Plant Added',
    lastPlantUpdate: 'Date of Last Plant Update',
    showWishList: 'Show Wishlist',
    showSellList: 'Show Sell List',
    //local only
    chatStarted: 'Chat Started',
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
  final int photos;
  final List likedPlants;
  final List blocked;
  final bool expandGroup;
  final bool expandCollection;
  final List tags;
  final List friends;
  final List requestsSent;
  final List requestsReceived;
  final List chats;
  final bool privateLibrary;
  final bool sortAlphabetically;
  final String uniquePublicID;
  final int lastPlantAdd;
  final int lastPlantUpdate;
  final bool showWishList;
  final bool showSellList;

  //local only
//  final bool chatStarted;

  //CONSTRUCTOR
  UserData(
      {@required this.id,
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
      this.photos,
      this.likedPlants,
      this.blocked,
      this.expandGroup,
      this.expandCollection,
      this.tags,
      this.friends,
      this.requestsSent,
      this.requestsReceived,
      this.chats,
      this.privateLibrary,
      this.sortAlphabetically,
      this.uniquePublicID,
      this.lastPlantAdd,
      this.lastPlantUpdate,
      this.showWishList,
      this.showSellList
      //local only
//    this.chatStarted,
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
      UserKeys.photos: photos,
      UserKeys.likedPlants: likedPlants,
      UserKeys.blocked: blocked,
      UserKeys.expandGroup: expandGroup,
      UserKeys.expandCollection: expandCollection,
      UserKeys.tags: tags,
      UserKeys.friends: friends,
      UserKeys.requestsSent: requestsSent,
      UserKeys.requestsReceived: requestsReceived,
      UserKeys.chats: chats,
      UserKeys.privateLibrary: privateLibrary,
      UserKeys.sortAlphabetically: sortAlphabetically,
      UserKeys.uniquePublicID: uniquePublicID,
      UserKeys.lastPlantAdd: lastPlantAdd,
      UserKeys.lastPlantUpdate: lastPlantUpdate,
      UserKeys.showWishList: showWishList,
      UserKeys.showSellList: showSellList,
      //local only
//      UserKeys.chatStarted: chatStarted,
    };
  }

  //FROM MAP
  static UserData fromMap({@required Map map}) {
    return UserData(
      id: DV.isString(value: map[UserKeys.id]),
      email: DV.isString(value: map[UserKeys.email]),
      name: DV.isString(value: map[UserKeys.name]),
      type:
          DV.isString(value: map[UserKeys.type], fallback: UserTypes.standard),
      join: DV.isInt(value: map[UserKeys.join]),
      about: DV.isString(value: map[UserKeys.about]),
      region: DV.isString(value: map[UserKeys.region], fallback: 'Earth'),
      avatar: DV.isString(value: map[UserKeys.avatar]),
      background: DV.isString(value: map[UserKeys.background]),
      plants: DV.isInt(value: map[UserKeys.plants]),
      collections: DV.isInt(value: map[UserKeys.collections]),
      groups: DV.isInt(value: map[UserKeys.groups]),
      photos: DV.isInt(value: map[UserKeys.photos]),
      likedPlants: DV.isList(value: map[UserKeys.likedPlants]),
      blocked: DV.isList(value: map[UserKeys.blocked]),
      expandGroup: DV.isBool(value: map[UserKeys.expandGroup], fallback: true),
      expandCollection:
          DV.isBool(value: map[UserKeys.expandCollection], fallback: true),
      tags: DV.isList(value: map[UserKeys.tags]),
      friends: DV.isList(value: map[UserKeys.friends]),
      requestsSent: DV.isList(value: map[UserKeys.requestsSent]),
      requestsReceived: DV.isList(value: map[UserKeys.requestsReceived]),
      chats: DV.isList(value: map[UserKeys.chats]),
      privateLibrary: DV.isBool(value: map[UserKeys.privateLibrary]),
      sortAlphabetically: DV.isBool(value: map[UserKeys.sortAlphabetically]),
      uniquePublicID: DV.isString(value: map[UserKeys.uniquePublicID]),
      lastPlantAdd: DV.isInt(value: map[UserKeys.lastPlantAdd]),
      lastPlantUpdate: DV.isInt(value: map[UserKeys.lastPlantUpdate]),
      showWishList:
          DV.isBool(value: map[UserKeys.showWishList], fallback: true),
      showSellList: DV.isBool(value: map[UserKeys.showSellList]),
      //local only
//      chatStarted: map[UserKeys.chatStarted] ?? false,
    );
  }
}
