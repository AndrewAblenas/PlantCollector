import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/library/widgets/add_plant.dart';
import 'package:plant_collector/widgets/dialogs/color_picker/dialog_picker.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/screens/library/widgets/plant_tile.dart';
import 'package:plant_collector/widgets/info_tip.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:expandable/expandable.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:share/share.dart';

class CollectionCard extends StatelessWidget {
  final bool connectionLibrary;
  final bool sortPlants;
  final CollectionData collection;
  final String groupID;
  final Color colorTheme;
  final bool defaultView;
  final bool showWishList;
  final bool showSellList;
  final bool showCompostList;

  CollectionCard({
    @required this.connectionLibrary,
    this.sortPlants = false,
    @required this.collection,
    @required this.groupID,
    @required this.colorTheme,
    @required this.defaultView,
    this.showWishList = false,
    this.showSellList = false,
    this.showCompostList = false,
  });

  @override
  Widget build(BuildContext context) {
    //easy reference
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: false);
    //easy scale
    double width = MediaQuery.of(context).size.width;
    //use the appropriate plant source
    List<PlantData> fullList = (connectionLibrary == false)
        ? provAppDataFalse.currentUserPlants
        : provAppDataFalse.connectionPlants;

    //get plants for the collection from the full list
    List<PlantData> collectionPlants = AppData.getPlantsFromList(
        collectionPlantIDs: collection.plants, plants: fullList);

    //issue where empty orphan list shows up
    bool emptyOrphan = (collection.id == DBDefaultDocument.orphaned &&
        collectionPlants != null &&
        collectionPlants.length <= 0);

    //now if this list is empty, don't display the collection for orphaned
    if (emptyOrphan == false) {
      //now sort these alphabetically if the user has chosen that option
      if (sortPlants == true) {
        collectionPlants.sort((a, b) => a.name.compareTo(b.name));
      }

      //get plants for the collection from the full list
      String numberedList = UIBuilders.shareList(
          shelfPlants: collectionPlants, shelfName: collection.name);

      //note collection plant total is calculated from this list instead of collection.plants
      //to prevent range errors if an entry is in collection.plants but the plant is deleted
      int collectionPlantTotal = collectionPlants.length;

      //item count for gridview
      int itemCountGridView;
      int itemCountIndexSwap;
      if (connectionLibrary == true) {
        print('Connection Library');
        //never show the add button in connection view
        itemCountGridView = collectionPlantTotal;
        itemCountIndexSwap = itemCountGridView - 1;
      } else if (DBDefaultDocument.collectionPreventMoveInto
          .contains(collection.id)) {
        //my library don't show add button for certain shelves
        itemCountGridView = collectionPlantTotal;
        itemCountIndexSwap = itemCountGridView - 1;
      } else {
        //otherwise show the add button
        itemCountGridView = collectionPlantTotal + 1;
        itemCountIndexSwap = collectionPlantTotal - 1;
      }

      //convert card color
      Color colorTheme = convertColor(storedColor: collection.color);

      //plant tile possible parents
      List<CollectionData> plantTilePossibleParents =
          (connectionLibrary == false)
              ? provAppDataFalse.currentUserCollections
              : provAppDataFalse.connectionCollections;
      //remove certain auto-generated and hidden to prevent move-into
      List<CollectionData> reducedParents = [];
      for (CollectionData collection in plantTilePossibleParents) {
        if (collection.id == DBDefaultDocument.wishList) {
          if (showWishList == true) reducedParents.add(collection);
        } else if (collection.id == DBDefaultDocument.sellList) {
          if (showSellList == true) reducedParents.add(collection);
        } else if (collection.id == DBDefaultDocument.compostList) {
          if (showCompostList == true) reducedParents.add(collection);
        } else if (!DBDefaultDocument.collectionPreventMoveInto
            .contains(collection.id)) {
          reducedParents.add(collection);
        }
      }

      //*****SET WIDGET VISIBILITY START*****//

      //enable dialogs only if library belongs to the current user
      //don't show for autogenerated cards
      bool showDeleteButton = (collectionPlantTotal == 0 &&
          connectionLibrary == false &&
          !DBDefaultDocument.collectionAutoGen.contains(collection.id));

      //prevent empty gridview build
      bool hideGridView =
          ((connectionLibrary == true && itemCountGridView == 0) ||
              (connectionLibrary == false &&
                  defaultView == true &&
                  itemCountGridView == 0));

      //*****SET WIDGET VISIBILITY END*****//

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
                      numberedList: numberedList,
                    ),
                    //provide a delete button if the collection is empty
                    (showDeleteButton == true)
                        ? Column(
                            children: <Widget>[
                              provAppDataFalse.showTips == true
                                  ? InfoTip(
                                      onPress: () {},
                                      text:
                                          '${GlobalStrings.collections} display your ${GlobalStrings.plants}.  '
                                          'They can only be deleted when empty, via the trash button below.  \n\n'
                                          'Hold down on the ${GlobalStrings.collection} name above to rename it.  \n\n'
                                          'Tap the arrow button to the right of the name to collapse or expand.  '
                                          'Hold down on the arrow button to set the colour.  \n\n'
                                          'You can add a ${GlobalStrings.plant} with the green "+" button below.  '
                                          'Hold down on a ${GlobalStrings.plant} tile to move it to another Shelf.  '
                                          'Then tap the ${GlobalStrings.plant} to visit it\'s profile and add more information.  \n\n')
                                  : SizedBox(),
                              Container(
                                decoration: kButtonBoxDecoration,
                                width: double.infinity,
                                margin: EdgeInsets.all(1.0),
                                child: FlatButton(
                                  padding: EdgeInsets.all(10.0),
                                  child: CircleAvatar(
                                    foregroundColor: kGreenDark,
                                    backgroundColor: Colors.white,
                                    radius: AppTextSize.medium * width,
                                    child: Icon(
                                      Icons.delete_forever,
                                      size: AppTextSize.huge * width,
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
                                            CloudDB.deleteDocumentL2(
                                                collectionL1: DBFolder.users,
                                                documentL1:
                                                    Provider.of<AppData>(
                                                            context,
                                                            listen: false)
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
                        if (hideGridView == true) {
                          return SizedBox();
                        } else {
                          return GridView.builder(
                            shrinkWrap: true,
                            //allows scrolling
                            primary: false,
                            padding: EdgeInsets.only(bottom: 5.0),
                            scrollDirection: Axis.vertical,
                            //add additional button only for collection owner
                            //no add button for auto generated
                            itemCount: itemCountGridView,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              Widget tile;
                              //build a tile for each plant in the list, beginning index 0
                              if (index <= itemCountIndexSwap) {
                                tile = Container(
                                  padding: EdgeInsets.all(0.5),
                                  child: PlantTile(
                                    connectionLibrary: connectionLibrary,
                                    possibleParents: reducedParents,
                                    plant: collectionPlants[index],
                                    collectionID: collection.id,
                                    communityView: false,
                                  ),
                                );
                                //for the last item put an add button
                              } else {
                                tile = Padding(
                                  padding: EdgeInsets.all(
                                      1.0 * width * kScaleFactor),
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
                  expandedIcon: Icons.keyboard_arrow_down,
                  numberedList: numberedList,
                ),
              ),
            );
          }
        }),
      );
    } else {
      return SizedBox();
    }
  }
}

class CollectionHeader extends StatelessWidget {
  final bool defaultView;
  final bool connectionLibrary;
  final CollectionData collection;
  final Color colorTheme;
  final IconData expandedIcon;
  final String numberedList;

  CollectionHeader(
      {@required this.defaultView,
      @required this.connectionLibrary,
      @required this.collection,
      @required this.colorTheme,
      @required this.expandedIcon,
      @required this.numberedList});

  @override
  Widget build(BuildContext context) {
    //easy reference
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: false);
    //easy scale
    double width = MediaQuery.of(context).size.width;
    //set plant number
    String collectionPlantTotal = collection.plants.length.toString();

    //*****SET WIDGET VISIBILITY START*****//

    //enable dialogs only for current user on their main Library page
    bool enableDialogs = (connectionLibrary == false && defaultView == false);

    //only allow current user to change color on their library
    //exclude autogenerated
    bool allowColorChange = (connectionLibrary == false &&
        !DBDefaultDocument.collectionAutoGen.contains(collection.id));

    //show automatic generated image
    bool autoGen =
        (DBDefaultDocument.collectionAutoGen.contains(collection.id));

    //*****SET WIDGET VISIBILITY END*****//

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
                if (enableDialogs == true && autoGen == false)
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogScreenInput(
                            title: 'Rename ${GlobalStrings.collection}',
                            acceptText: 'Update',
                            acceptOnPress: () {
                              //create data pair map
                              Map data = AppData.updatePairFull(
                                  key: CollectionKeys.name,
                                  value: provAppDataFalse.newDataInput);
                              //upload update to db
                              Provider.of<CloudDB>(context, listen: false)
                                  .updateDocumentInCollection(
                                      data: data,
                                      collection: DBFolder.collections,
                                      documentName: collection.id);
                              //pop context
                              Navigator.pop(context);
                            },
                            onChange: (input) {
                              provAppDataFalse.newDataInput = input;
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
                    child: (autoGen == false)
                        ? SizedBox()
                        : Center(
                            child: Icon(
                              Icons.star,
                              size: AppTextSize.large * width,
                              color: kGreenDark,
                            ),
                          ),
                  ),
                  Expanded(
                    child: Container(
                      width: width * 0.7,
                      child: Text(
                        collection.name.toUpperCase(),
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppTextSize.large * width,
                          fontWeight: AppTextWeight.medium,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    //ALLOW A WAY TO SET COLOR
                    onLongPress: () {
                      if (allowColorChange == true)
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogPicker(
                              title: 'Pick a Colour',
                              widgets: UIBuilders.colorButtonsList(
                                  colors: kGroupColors,
                                  onPress: () {
                                    Navigator.pop(context);
                                  },
                                  collectionID: collection.id),
                            );
                          },
                        );
                    },
                    child: ExpandableButton(
                      child: CircleAvatar(
                        radius: 16.0 * width * kScaleFactor,
                        backgroundColor: colorTheme,
                        child: Icon(
                          expandedIcon,
                          size: 30.0 * width * kScaleFactor,
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
            width: width * 0.65,
            color: colorTheme,
          ),
          SizedBox(height: 5.0),
          GestureDetector(
            onTap: () {
              Share.share(
                numberedList,
                subject: 'Check out my ${collection.name.toUpperCase()} Shelf!',
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.view_list,
                  size: AppTextSize.small * width,
                  color: AppTextColor.light,
                ),
                SizedBox(
                  width: 3.0,
                ),
                Text(
                  collectionPlantTotal == '1'
                      ? '$collectionPlantTotal ${GlobalStrings.plant} on ${GlobalStrings.collection}'
                      : '$collectionPlantTotal ${GlobalStrings.plants} on ${GlobalStrings.collection}',
                  style: TextStyle(
                      color: AppTextColor.light,
                      fontSize: AppTextSize.small * width),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
