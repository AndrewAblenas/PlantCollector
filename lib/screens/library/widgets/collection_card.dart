import 'package:flutter/material.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/classes.dart';
import 'package:plant_collector/screens/library/widgets/collection_add_plant.dart';
import 'package:plant_collector/screens/library/widgets/collection_delete.dart';
import 'package:plant_collector/widgets/dialogs/dialog_input.dart';
import 'package:plant_collector/screens/library/widgets/collection_plant_tile.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:expandable/expandable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_collector/widgets/dialogs/select/dialog_select.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:plant_collector/formats/colors.dart';

class CollectionCard extends StatelessWidget {
  final Map collection;
  final int collectionPlantTotal;
  final String groupID;
  final Color colorTheme;

  CollectionCard(
      {@required this.collection,
      @required this.collectionPlantTotal,
      @required this.groupID,
      @required this.colorTheme});

  @override
  Widget build(BuildContext context) {
    return TileWhite(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 16.0,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(14.0),
              child: GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogInput(
                        title: 'Rename Collection',
                        text: 'Please enter a new name.',
                        onPressedSubmit: () {
                          Map data = Provider.of<CloudDB>(context)
                              .updatePairInput(key: kCollectionName);
                          print(data);
                          Provider.of<CloudDB>(context)
                              .updateDocumentInCollection(
                                  data: data,
                                  collection: kUserCollections,
                                  documentName: collection[kCollectionID]);
                          Navigator.pop(context);
                        },
                        onChangeInput: (input) {
                          Provider.of<CloudDB>(context).newDataInput = input;
                        },
                        onPressedCancel: () {
                          Provider.of<CloudDB>(context).newDataInput = null;
                          Navigator.pop(context);
                        },
                        hintText: collection[kCollectionName],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        collection[kCollectionName].toUpperCase(),
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppTextSize.large *
                              MediaQuery.of(context).size.width,
                          fontWeight: AppTextWeight.medium,
                        ),
                      ),
                    ),
                    Container(
                      width:
                          30.0 * MediaQuery.of(context).size.width * kTextScale,
                      height:
                          30.0 * MediaQuery.of(context).size.width * kTextScale,
                      child: FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogSelect(
                                  title: 'Move to Another Group',
                                  text:
                                      'Please select the Group where you would like to move this plant.',
                                  plantID: collection[kCollectionID],
                                  menuItems: Provider.of<UIBuilders>(context)
                                      .createDialogGroupButtons(
                                    selectedItemID: collection[kCollectionID],
                                    currentParentID: groupID,
                                    possibleParents:
                                        Provider.of<CloudDB>(context).groups,
                                  ),
                                );
                              });
                        },
                        child: Icon(
                          Icons.arrow_forward,
                          size: 25.0 *
                              MediaQuery.of(context).size.width *
                              kTextScale,
                          color: AppTextColor.light,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 2.0,
              width: MediaQuery.of(context).size.width * 0.65,
              color: colorTheme == null ? kGreenDark : colorTheme,
            ),
            SizedBox(height: 20.0),
            ExpandableNotifier(
              initialExpanded: true,
              child: Expandable(
                expanded: Column(
                  children: <Widget>[
//                    GridView.count(
//                      crossAxisCount: 3,
//                      mainAxisSpacing: 5.0,
//                      crossAxisSpacing: 5.0,
//                      shrinkWrap: true,
//                      primary: false,
//                      padding: EdgeInsets.only(bottom: 10.0),
//                      children:
//                          Provider.of<UIBuilders>(context).createPlantTileList(
//                        collectionID: collection[kCollectionID],
//                        collectionPlants: collection[kCollectionPlantList],
//                      ),
//                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: collectionPlantTotal == 0
                                ? CollectionDelete(
                                    collectionID: collection[kCollectionID])
                                : const SizedBox(),
                          ),
                        ),
                      ],
                      mainAxisSize: MainAxisSize.max,
                    ),
                    Consumer<QuerySnapshot>(
                      builder: (context, QuerySnapshot plantsSnap, _) {
                        if (plantsSnap != null) {
                          //save plants for use elsewhere
                          Provider.of<CloudDB>(context).plants = plantsSnap
                              .documents
                              .map((doc) =>
                                  plantMapFromSnapshot(plantMap: doc.data))
                              .toList();
                          //generate list of collection plants
                          List<Map> collectionPlants =
                              Provider.of<CloudDB>(context).getGroupCollections(
                            groupCollectionIDs:
                                collection[kCollectionPlantList],
                            collections: plantsSnap.documents
                                .map((doc) =>
                                    plantMapFromSnapshot(plantMap: doc.data))
                                .toList(),
                          );
                          return GridView.builder(
                              shrinkWrap: true,
                              //allows scrolling
                              primary: false,
                              padding: EdgeInsets.only(bottom: 10.0),
                              scrollDirection: Axis.vertical,
                              //add additional button
                              itemCount: collectionPlantTotal + 1,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                if (index <= collectionPlantTotal - 1) {
                                  return Padding(
                                    padding: EdgeInsets.all(2.0 *
                                        MediaQuery.of(context).size.width *
                                        kTextScale),
                                    child: CollectionPlantTile(
                                        possibleParents:
                                            Provider.of<CloudDB>(context)
                                                .collections,
                                        plantMap: collectionPlants[index],
                                        collectionID:
                                            collection[kCollectionID]),
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.all(2.0 *
                                        MediaQuery.of(context).size.width *
                                        kTextScale),
                                    child: CollectionAddPlant(
                                        collectionID:
                                            collection[kCollectionID]),
                                  );
                                }
                              });
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    SizedBox(height: 10.0),
                    ExpandableButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.keyboard_arrow_up,
                            size: 40.0 *
                                MediaQuery.of(context).size.width *
                                kTextScale,
                            color: AppTextColor.light,
                          ),
                          Text(
                            collectionPlantTotal.toString() == '1'
                                ? '$collectionPlantTotal plant in collection'
                                : '$collectionPlantTotal plants in collection',
                            style: TextStyle(
                                color: AppTextColor.light,
                                fontSize: AppTextSize.small *
                                    MediaQuery.of(context).size.width),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                collapsed: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ExpandableButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 40.0 *
                                MediaQuery.of(context).size.width *
                                kTextScale,
                            color: AppTextColor.light,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//FutureBuilder(
//future: Provider.of<CloudDB>(context)
//.getDB()
//    .collection(kUserCollections)
//.getDocuments(),
//builder: (BuildContext context,
//    AsyncSnapshot<QuerySnapshot> snapshot) {})
