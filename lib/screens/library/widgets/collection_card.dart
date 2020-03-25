import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/library/widgets/add_plant.dart';
import 'package:plant_collector/widgets/dialogs/color_picker/dialog_color_picker.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/screens/library/widgets/plant_tile.dart';
import 'package:plant_collector/widgets/info_tip.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:expandable/expandable.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:plant_collector/formats/colors.dart';

class CollectionCard extends StatelessWidget {
  final bool connectionLibrary;
  final CollectionData collection;
  final String groupID;
  final Color colorTheme;
  final bool defaultView;

  CollectionCard({
    @required this.connectionLibrary,
    @required this.collection,
    @required this.groupID,
    @required this.colorTheme,
    @required this.defaultView,
  });

  @override
  Widget build(BuildContext context) {
    //use the appropriate plant source
    List<PlantData> fullList = (connectionLibrary == false)
        ? Provider.of<AppData>(context).currentUserPlants
        : Provider.of<AppData>(context).connectionPlants;
    //get plants for the collection from the full list
    List<PlantData> collectionPlants = CloudDB.getPlantsFromList(
        collectionPlantIDs: collection.plants, plants: fullList);
    //note collection plant total is calculated from this list instead of collection.plants
    //to prevent range errors if an entry is in collection.plants but the plant is deleted
    int collectionPlantTotal = collectionPlants.length;
    Color colorTheme = convertColor(storedColor: collection.color);
    return TileWhite(
      child: Consumer<UserData>(builder: (context, user, _) {
        if (user == null) {
          return SizedBox();
        } else {
          return ExpandableNotifier(
            //user settings to determine if collection is collapsed by default
            initialExpanded: user.expandCollection,
            child: Expandable(
              expanded: Column(
                children: <Widget>[
                  CollectionHeader(
                    defaultView: defaultView,
                    connectionLibrary: connectionLibrary,
                    collection: collection,
                    colorTheme: colorTheme,
                    expandedIcon: Icons.keyboard_arrow_up,
                  ),
                  //provide a delete button if the collection is empty
                  (collectionPlantTotal == 0 && connectionLibrary == false)
                      ? Column(
                          children: <Widget>[
                            Provider.of<AppData>(context).showTips == true
                                ? InfoTip(
                                    onPress: () {},
                                    text:
                                        '${GlobalStrings.collections} hold your ${GlobalStrings.plants}.  '
                                        'They can only be deleted when empty, via the button below.  \n\n'
                                        'Hold down on the ${GlobalStrings.collection} name to rename it.  \n\n'
                                        'Tap the arrow button to the right of the name to collapse/expand, or hold down to set the colour.  \n\n'
                                        'You can add a ${GlobalStrings.plant} with the green "+" button below.  '
                                        'Then tap the ${GlobalStrings.plant} to visit it\'s profile.  \n\n'
                                        'After you build another ${GlobalStrings.collection}, you can hold down on a ${GlobalStrings.plant} to move it to another location.')
                                : SizedBox(),
                            Container(
                              decoration: kButtonBoxDecoration,
                              width: double.infinity,
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
                                        title:
                                            'Remove ${GlobalStrings.collection}',
                                        text:
                                            'Are you sure you want to delete this ${GlobalStrings.collection}?',
                                        buttonText: 'Remove',
                                        onPressed: () {
                                          //delete the collection
                                          Provider.of<CloudDB>(context)
                                              .deleteDocumentL2(
                                                  collectionL1: DBFolder.users,
                                                  documentL1:
                                                      Provider.of<AppData>(
                                                              context)
                                                          .currentUserInfo
                                                          .id,
                                                  collectionL2:
                                                      DBFolder.collections,
                                                  documentL2: collection.id);
                                          //pop context
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Builder(
                    builder: (context) {
                      //if friend library with no plants, this prevents empty white space
                      if (connectionLibrary == true &&
                          collectionPlants.length == 0) {
                        return SizedBox();
                      } else if (connectionLibrary == false &&
                          defaultView == true &&
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
                          //no add button for auto generated
                          itemCount: (connectionLibrary == false &&
                                  defaultView == false)
                              ? collectionPlantTotal + 1
                              : collectionPlantTotal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            Widget tile;
                            //build a tile for each plant in the list, beginning index 0
                            if (index <= collectionPlantTotal - 1) {
                              tile = Padding(
                                padding: EdgeInsets.all(1.0 *
                                    MediaQuery.of(context).size.width *
                                    kScaleFactor),
                                child: PlantTile(
                                  connectionLibrary: connectionLibrary,
                                  possibleParents: connectionLibrary == false
                                      ? Provider.of<AppData>(context)
                                          .currentUserCollections
                                      : Provider.of<AppData>(context)
                                          .connectionCollections,
                                  plant: collectionPlants[index],
                                  collectionID: collection.id,
                                  communityView: false,
                                ),
                              );
                              //for the last item put an add button
                            } else {
                              tile = Padding(
                                padding: EdgeInsets.all(1.0 *
                                    MediaQuery.of(context).size.width *
                                    kScaleFactor),
                                child: AddPlant(collectionID: collection.id),
                              );
                            }
                            return tile;
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
              collapsed: CollectionHeader(
                  defaultView: defaultView,
                  connectionLibrary: connectionLibrary,
                  collection: collection,
                  colorTheme: colorTheme,
                  expandedIcon: Icons.keyboard_arrow_down),
            ),
          );
        }
      }),
    );
  }
}

class CollectionHeader extends StatelessWidget {
  final bool defaultView;
  final bool connectionLibrary;
  final CollectionData collection;
  final Color colorTheme;
  final IconData expandedIcon;

  CollectionHeader(
      {@required this.defaultView,
      @required this.connectionLibrary,
      @required this.collection,
      @required this.colorTheme,
      @required this.expandedIcon});

  @override
  Widget build(BuildContext context) {
    //set plant number
    String collectionPlantTotal = collection.plants.length.toString();

    return Padding(
      padding: EdgeInsets.only(
        bottom: 14.0,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              top: 14.0,
              right: 10.0,
              bottom: 6.0,
            ),
            child: GestureDetector(
              onLongPress: () {
                //remove functionality for friend collection or auto generated
                if (connectionLibrary == false && defaultView == false)
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogScreenInput(
                            title: 'Rename ${GlobalStrings.collection}',
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
                  SizedBox(
                    width: 30.0,
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
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
                  ),
                  GestureDetector(
                    //ALLOW A WAY TO SET COLOR
                    onLongPress: () {
                      if ((connectionLibrary == false &&
                          !DBDefaultDocument.collectionExclude
                              .contains(collection.id)))
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogColorPicker(
                              title: 'Pick a Colour',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              collectionID: collection.id,
                            );
                          },
                        );
                    },
                    child: ExpandableButton(
                      child: CircleAvatar(
                        radius: 16.0 *
                            MediaQuery.of(context).size.width *
                            kScaleFactor,
                        backgroundColor: colorTheme,
                        child: Icon(
                          expandedIcon,
                          size: 30.0 *
                              MediaQuery.of(context).size.width *
                              kScaleFactor,
                          color: AppTextColor.white,
                        ),
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
            color: colorTheme,
          ),
          SizedBox(height: 5.0),
          Text(
            collectionPlantTotal == '1'
                ? '$collectionPlantTotal ${GlobalStrings.plant} on ${GlobalStrings.collection}'
                : '$collectionPlantTotal ${GlobalStrings.plants} on ${GlobalStrings.collection}',
            style: TextStyle(
                color: AppTextColor.light,
                fontSize:
                    AppTextSize.small * MediaQuery.of(context).size.width),
          ),
        ],
      ),
    );
  }
}
