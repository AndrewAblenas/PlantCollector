import 'package:flutter/material.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/models/classes.dart';
import 'package:plant_collector/widgets/dialogs/color_picker/dialog_color_picker.dart';
import 'package:plant_collector/widgets/dialogs/dialog_input.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:expandable/expandable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/formats/colors.dart';

class GroupCard extends StatelessWidget {
  final Map group;
  final List<dynamic> groups;
//  final List<Map> setCollectionsList;
  GroupCard({
    @required this.group,
    @required this.groups,
//    @required this.setCollectionsList
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 15,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: kGreenMedium,
        boxShadow: kShadowBox,
      ),
      child: ExpandableNotifier(
        initialExpanded: true,
        child: Expandable(
          collapsed: GroupHeader(
            group: group,
            button: ExpandableButton(
              child: CircleAvatar(
                radius: 20.0,
                backgroundColor: convertColor(storedColor: group[kGroupColor]),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30.0 * MediaQuery.of(context).size.width * kTextScale,
                  color: AppTextColor.white,
                ),
              ),
            ),
          ),
          expanded: Column(
            children: <Widget>[
              GroupHeader(
                group: group,
                button: ExpandableButton(
                  child: CircleAvatar(
                    radius:
                        20.0 * MediaQuery.of(context).size.width * kTextScale,
                    backgroundColor:
                        convertColor(storedColor: group[kGroupColor]),
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      size:
                          30.0 * MediaQuery.of(context).size.width * kTextScale,
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
                  Consumer<QuerySnapshot>(
                    builder: (context, QuerySnapshot collectionsSnap, _) {
                      if (collectionsSnap == null) return Column();
                      Provider.of<CloudDB>(context).collections =
                          collectionsSnap.documents
                              .map((doc) => collectionMapFromSnapshot(
                                  collectionMap: doc.data))
                              .toList();
                      List<Map> groupCollections =
                          Provider.of<CloudDB>(context).getGroupCollections(
                        groupCollectionIDs: group[kGroupCollectionList],
                        collections: Provider.of<CloudDB>(context).collections,
                      );
                      Color groupColor =
                          convertColor(storedColor: group[kGroupColor]);
                      return StreamProvider<QuerySnapshot>.value(
                        value: Provider.of<CloudDB>(context).streamPlants(),
                        child: Provider.of<UIBuilders>(context)
                            .displayCollections(
                                userCollections: groupCollections,
                                groupID: group[kGroupID],
                                groupColor: groupColor),
                      );
                    },
                  ),
                  TileWhite(
                    child: FlatButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogInput(
                                title: 'Add New Collection',
                                text:
                                    'Please provide a new of the new Collection to add to this Group.',
                                onPressedSubmit: () {
                                  Map data = Provider.of<AppData>(context)
                                      .collectionNewDB()
                                      .toMap();
                                  Provider.of<CloudDB>(context)
                                      .insertDocumentToCollection(
                                          data: data,
                                          collection: '$kUserCollections',
                                          documentName: data[kCollectionID]);
                                  Provider.of<CloudDB>(context)
                                      .updateArrayInDocumentInCollection(
                                          arrayKey: kGroupCollectionList,
                                          entries: [data[kCollectionID]],
                                          folder: kUserGroups,
                                          documentName: group[kGroupID],
                                          action: true);
                                  Navigator.pop(context);
                                },
                                onChangeInput: (input) {
                                  Provider.of<AppData>(context).newDataInput =
                                      input;
                                },
                                onPressedCancel: () {
                                  Provider.of<AppData>(context).newDataInput =
                                      null;
                                  Navigator.pop(context);
                                },
                              );
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
                                kTextScale,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Add New Collection',
                            style: TextStyle(
                                fontSize: AppTextSize.medium *
                                    MediaQuery.of(context).size.width,
                                fontWeight: AppTextWeight.medium,
                                color: AppTextColor.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupHeader extends StatelessWidget {
  final Map group;
  final ExpandableButton button;
  GroupHeader({
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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogInput(
                  title: 'Rename Set',
                  text: 'Please enter a new name.',
                  onPressedSubmit: () {
                    Map data = Provider.of<CloudDB>(context)
                        .updatePairInput(key: kGroupName);
                    Provider.of<CloudDB>(context).updateDocumentInCollection(
                        data: data,
                        collection: kUserGroups,
                        documentName: group[kGroupID]);
                    Navigator.pop(context);
                  },
                  onChangeInput: (input) {
                    Provider.of<CloudDB>(context).newDataInput = input;
                  },
                  onPressedCancel: () {
                    Provider.of<CloudDB>(context).newDataInput = null;
                    Navigator.pop(context);
                  },
                  hintText: group[kGroupName],
                );
              },
            );
          },
          child: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogColorPicker(
                          title: 'Pick a Colour',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          groupID: group[kGroupID],
                        );
                      });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width:
                          10.0 * MediaQuery.of(context).size.width * kTextScale,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        group[kGroupName].toUpperCase(),
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
                      width:
                          10.0 * MediaQuery.of(context).size.width * kTextScale,
                    ),
                    Container(
                        width: 30.0 *
                            MediaQuery.of(context).size.width *
                            kTextScale,
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
