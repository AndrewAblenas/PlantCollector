import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_select.dart';
import 'package:plant_collector/screens/library/widgets/add_plant.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/screens/library/widgets/plant_tile.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:expandable/expandable.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:plant_collector/formats/colors.dart';

class CollectionCard extends StatelessWidget {
  final bool connectionLibrary;
  final CollectionData collection;
  final int collectionPlantTotal;
  final String groupID;
  final Color colorTheme;

  CollectionCard(
      {@required this.connectionLibrary,
      @required this.collection,
      @required this.collectionPlantTotal,
      @required this.groupID,
      @required this.colorTheme});

  @override
  Widget build(BuildContext context) {
    //use the appropriate plant source
    List<PlantData> fullList = (connectionLibrary == false)
        ? Provider.of<AppData>(context).currentUserPlants
        : Provider.of<AppData>(context).connectionPlants;
    //get plants for the collection from the full list
    List<PlantData> collectionPlants = CloudDB.getPlantsFromList(
        collectionPlantIDs: collection.plants, plants: fullList);
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
                  if (connectionLibrary == false)
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogScreenInput(
                              title: 'Rename Collection',
                              acceptText: 'Update',
                              acceptOnPress: () {
                                //create data pair map
                                Map data = CloudDB.updatePairFull(
                                    key: CollectionKeys.name,
                                    value: Provider.of<AppData>(context)
                                        .newDataInput);
                                //upload update to db
                                Provider.of<CloudDB>(context)
                                    .updateDocumentInCollection(
                                        data: data,
                                        collection: DBFolder.collections,
                                        documentName: collection.id);
                                //pop context
                                Navigator.pop(context);
                              },
                              onChange: (input) {
                                Provider.of<AppData>(context).newDataInput =
                                    input;
                              },
                              cancelText: 'Cancel',
                              hintText: collection.name);
                        });
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
                        collection.name.toUpperCase(),
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppTextSize.large *
                              MediaQuery.of(context).size.width,
                          fontWeight: AppTextWeight.medium,
                        ),
                      ),
                    ),
                    connectionLibrary == false
                        ? Container(
                            width: 50.0 *
                                MediaQuery.of(context).size.width *
                                kScaleFactor,
                            height: 30.0 *
                                MediaQuery.of(context).size.width *
                                kScaleFactor,
                            child: FlatButton(
                              onPressed: () {
                                if (connectionLibrary == false)
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DialogScreenSelect(
                                        title:
                                            'Move this collection to a different Group',
                                        items:
                                            UIBuilders.createDialogGroupButtons(
                                          selectedItemID: collection.id,
                                          currentParentID: groupID,
                                          possibleParents:
                                              Provider.of<AppData>(context)
                                                  .currentUserGroups,
                                        ),
                                      );
                                    },
                                  );
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                size: 25.0 *
                                    MediaQuery.of(context).size.width *
                                    kScaleFactor,
                                color: AppTextColor.light,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 30.0,
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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: (collectionPlantTotal == 0 &&
                                    connectionLibrary == false)
                                ? Container(
                                    decoration: kButtonBoxDecoration,
                                    child: FlatButton(
                                      padding: EdgeInsets.all(10.0),
                                      child: CircleAvatar(
                                        foregroundColor: kGreenDark,
                                        backgroundColor: Colors.white,
                                        radius: AppTextSize.medium *
                                            MediaQuery.of(context).size.width,
                                        child: Icon(
                                          Icons.delete_forever,
                                          size: AppTextSize.huge *
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DialogConfirm(
                                              title: 'Remove Collection',
                                              text:
                                                  'Are you sure you want to delete this collection?',
                                              buttonText: 'Remove',
                                              onPressed: () {
                                                Provider.of<CloudDB>(context)
                                                    .deleteDocumentFromCollection(
                                                        documentID:
                                                            collection.id,
                                                        collection: DBFolder
                                                            .collections);
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ],
                      mainAxisSize: MainAxisSize.max,
                    ),
                    //TODO is this even needed? Can I just pull the saved plants?
                    Builder(
                      builder: (context) {
                        if (fullList.length >= 1) {
                          if (connectionLibrary == true &&
                              collectionPlants.length == 0) {
                            return SizedBox();
                          } else {
                            return GridView.builder(
                              shrinkWrap: true,
                              //allows scrolling
                              primary: false,
                              padding: EdgeInsets.only(bottom: 10.0),
                              scrollDirection: Axis.vertical,
                              //add additional button only for collection owner
                              itemCount: connectionLibrary == false
                                  ? collectionPlantTotal + 1
                                  : collectionPlantTotal,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                Widget tile;
                                if (index <= collectionPlantTotal - 1) {
                                  tile = Padding(
                                    padding: EdgeInsets.all(2.0 *
                                        MediaQuery.of(context).size.width *
                                        kScaleFactor),
                                    child: PlantTile(
                                        connectionLibrary: connectionLibrary,
                                        possibleParents:
                                            connectionLibrary == false
                                                ? Provider.of<AppData>(context)
                                                    .currentUserCollections
                                                : Provider.of<AppData>(context)
                                                    .connectionCollections,
                                        plant: collectionPlants[index],
                                        collectionID: collection.id),
                                  );
                                } else {
                                  tile = Padding(
                                    padding: EdgeInsets.all(2.0 *
                                        MediaQuery.of(context).size.width *
                                        kScaleFactor),
                                    child:
                                        AddPlant(collectionID: collection.id),
                                  );
                                }
                                return tile;
                              },
                            );
                          }
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
                                kScaleFactor,
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
                                kScaleFactor,
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
