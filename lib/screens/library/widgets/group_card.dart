import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/dialogs/color_picker/dialog_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:expandable/expandable.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/formats/colors.dart';

class GroupCard extends StatelessWidget {
  final bool connectionLibrary;
  final GroupData group;
  final List<dynamic> groups;
//  final List<Map> setCollectionsList;
  GroupCard({
    @required this.connectionLibrary,
    @required this.group,
    @required this.groups,
//    @required this.setCollectionsList
  });

  @override
  Widget build(BuildContext context) {
//    Stream plantsStream;
//    if (connectionLibrary == false) {
//      plantsStream = Provider.of<CloudDB>(context).userPlantsStream;
//    } else {
//      plantsStream = CloudDB.streamPlantsData(
//          userID: Provider.of<CloudDB>(context).connectionUserFolder);
//    }
    return ContainerWrapper(
      color: convertColor(storedColor: group.color),
      child: Consumer<UserData>(builder: (context, user, _) {
        if (user != null) {
          return ExpandableNotifier(
            //user settings to determine if group is expanded by default
            initialExpanded: user.expandGroup,
            child: Expandable(
              collapsed: GroupHeader(
                connectionLibrary: connectionLibrary,
                group: group,
                button: ExpandableButton(
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: convertColor(storedColor: group.color),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 30.0 *
                          MediaQuery.of(context).size.width *
                          kScaleFactor,
                      color: AppTextColor.white,
                    ),
                  ),
                ),
              ),
              expanded: Column(
                children: <Widget>[
                  GroupHeader(
                    connectionLibrary: connectionLibrary,
                    group: group,
                    button: ExpandableButton(
                      child: CircleAvatar(
                        radius: 20.0 *
                            MediaQuery.of(context).size.width *
                            kScaleFactor,
                        backgroundColor: convertColor(storedColor: group.color),
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          size: 30.0 *
                              MediaQuery.of(context).size.width *
                              kScaleFactor,
                          color: AppTextColor.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: <Widget>[
                      Consumer<List<CollectionData>>(
                        builder:
                            (context, List<CollectionData> collections, _) {
                          if (collections == null) return Column();
                          if (connectionLibrary == false) {
                            Provider.of<AppData>(context)
                                .currentUserCollections = collections;
                            //update tally in user document
                            if (collections != null &&
                                Provider.of<AppData>(context).currentUserInfo !=
                                    null
                                //don't bother updating if the values are the same
                                &&
                                collections.length !=
                                    Provider.of<AppData>(context)
                                        .currentUserInfo
                                        .collections) {
                              Map countData = CloudDB.updatePairFull(
                                  key: UserKeys.collections,
                                  value: collections.length);
                              Provider.of<CloudDB>(context).updateUserDocument(
                                data: countData,
                              );
                            }
                          } else {
                            Provider.of<AppData>(context)
                                .connectionCollections = collections;
                          }
                          List<CollectionData> groupCollections =
                              CloudDB.getMapsFromList(
                            groupCollectionIDs: group.collections,
                            collections: connectionLibrary == false
                                ? Provider.of<AppData>(context)
                                    .currentUserCollections
                                : Provider.of<AppData>(context)
                                    .connectionCollections,
                          );
                          Color groupColor =
                              convertColor(storedColor: group.color);
                          return Consumer<List<PlantData>>(
                            builder: (context, List<PlantData> plants, _) {
                              if (plants != null) {
                                if (connectionLibrary == false) {
                                  //save plants for use elsewhere
                                  Provider.of<AppData>(context)
                                      .currentUserPlants = plants;
                                  //update tally in user document
                                  if (plants != null &&
                                      //there was an issue on sign out until I added
                                      //another Navigator.pop to close both layers
                                      Provider.of<AppData>(context)
                                              .currentUserInfo !=
                                          null
                                      //don't bother updating if the values are the same
                                      &&
                                      plants.length !=
                                          Provider.of<AppData>(context)
                                              .currentUserInfo
                                              .plants) {
                                    Map countData = CloudDB.updatePairFull(
                                        key: UserKeys.plants,
                                        value: plants.length);
                                    Provider.of<CloudDB>(context)
                                        .updateUserDocument(
                                      data: countData,
                                    );
                                  }
                                } else {
                                  //save plants for use elsewhere
                                  Provider.of<AppData>(context)
                                      .connectionPlants = plants;
                                }
                                return UIBuilders.displayCollections(
                                    connectionLibrary: connectionLibrary,
                                    userCollections: groupCollections,
                                    groupID: group.id,
                                    groupColor: groupColor);
                              } else {
                                return SizedBox();
                              }
                            },
                          );
                        },
                      ),
                      (connectionLibrary == false &&
                              group.id != DBDefaultDocument.import)
                          ? TileWhite(
                              child: FlatButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DialogScreenInput(
                                            title:
                                                'Create new ${GlobalStrings.collection}',
                                            acceptText: 'Create',
                                            acceptOnPress: () {
                                              //create a map from the data
                                              CollectionData collection =
                                                  Provider.of<AppData>(context)
                                                      .newCollection();
                                              //upload new collection data
                                              Provider.of<CloudDB>(context)
                                                  .insertDocumentToCollection(
                                                      data: collection.toMap(),
                                                      collection:
                                                          DBFolder.collections,
                                                      documentName:
                                                          collection.id);
                                              //add collection reference to group
                                              Provider.of<CloudDB>(context)
                                                  .updateArrayInDocumentInCollection(
                                                      arrayKey:
                                                          GroupKeys.collections,
                                                      entries: [collection.id],
                                                      folder: DBFolder.groups,
                                                      documentName: group.id,
                                                      action: true);
                                              //pop context
                                              Navigator.pop(context);
                                            },
                                            onChange: (input) {
                                              Provider.of<AppData>(context)
                                                  .newDataInput = input;
                                            },
                                            cancelText: 'Cancel',
                                            hintText: null);
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.add,
                                      color: AppTextColor.dark,
                                      size: 25.0 *
                                          MediaQuery.of(context).size.width *
                                          kScaleFactor,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      'Add New ${GlobalStrings.collection}',
                                      style: TextStyle(
                                          fontSize: AppTextSize.medium *
                                              MediaQuery.of(context).size.width,
                                          fontWeight: AppTextWeight.medium,
                                          color: AppTextColor.black),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox();
        }
      }),
    );
  }
}

class GroupHeader extends StatelessWidget {
  final bool connectionLibrary;
  final GroupData group;
  final ExpandableButton button;
  GroupHeader({
    @required this.connectionLibrary,
    @required this.group,
    @required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return TileWhite(
      bottomPadding: 5.0,
      child: Padding(
        padding: EdgeInsets.all(14.0),
        child: GestureDetector(
          onLongPress: () {
            //remove functionality if friend library or auto generated group
            if (connectionLibrary == false &&
                group.id != DBDefaultDocument.import)
              showDialog(
                  context: context,
                  builder: (context) {
                    return DialogScreenInput(
                        title: 'Rename ${GlobalStrings.group}',
                        acceptText: 'Accept',
                        acceptOnPress: () {
                          //create map to upload
                          Map data = CloudDB.updatePairFull(
                              key: GroupKeys.name,
                              value:
                                  Provider.of<AppData>(context).newDataInput);
                          //upload data to db
                          Provider.of<CloudDB>(context)
                              .updateDocumentInCollection(
                                  data: data,
                                  collection: DBFolder.groups,
                                  documentName: group.id);
                          //pop context
                          Navigator.pop(context);
                        },
                        onChange: (input) {
                          Provider.of<AppData>(context).newDataInput = input;
                        },
                        cancelText: 'Cancel',
                        hintText: group.name);
                  });
          },
          child: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  if ((connectionLibrary == false &&
                      group.id != DBDefaultDocument.import))
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogColorPicker(
                          title: 'Pick a Colour',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          groupID: group.id,
                        );
                      },
                    );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 10.0 *
                          MediaQuery.of(context).size.width *
                          kScaleFactor,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        group.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: AppTextSize.huge *
                              MediaQuery.of(context).size.width,
                          fontWeight: AppTextWeight.medium,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0 *
                          MediaQuery.of(context).size.width *
                          kScaleFactor,
                    ),
                    Container(
                        width: 30.0 *
                            MediaQuery.of(context).size.width *
                            kScaleFactor,
                        child: button),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
