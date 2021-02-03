import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/communication_data.dart';
import 'package:plant_collector/models/data_types/plant/bloom_data.dart';
import 'package:plant_collector/models/data_types/plant/growth_data.dart';
import 'package:plant_collector/models/data_types/plant/image_data.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/plant/widgets/add_journal_button.dart';
import 'package:plant_collector/screens/plant/widgets/add_photo.dart';
import 'package:plant_collector/screens/plant/widgets/plant_flowering.dart';
import 'package:plant_collector/screens/plant/widgets/viewer_utility_buttons.dart';
import 'package:plant_collector/screens/search/widgets/search_tile_user.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/admin_button.dart';
import 'package:plant_collector/screens/plant/widgets/action_button.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/get_image.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:share/share.dart';

class PlantScreen extends StatelessWidget {
  final bool connectionLibrary;
  final bool communityView;
  final String forwardingCollectionID;
  final String plantID;
  PlantScreen(
      {@required this.connectionLibrary,
      @required this.communityView,
      @required this.plantID,
      @required this.forwardingCollectionID});
  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    //how many photos before to change to grid from carousel view
    int changeToGridView = 9;

    //only display certain elements for admin
    bool showAdmin =
        (Provider.of<AppData>(context, listen: false).currentUserInfo.type ==
                UserTypes.creator ||
            Provider.of<AppData>(context, listen: false).currentUserInfo.type ==
                UserTypes.admin);

    //only show add image if user created plant
    bool showAddImage = (connectionLibrary == false);

    //show plant owner tile
    bool showOwnerUserInfo = (communityView == true);

    //only show delete for plant owner
    bool showDeleteInsteadOfReport = (connectionLibrary == false);

    //*****SET WIDGET VISIBILITY END*****//

    return StreamProvider<DocumentSnapshot>.value(
      value: CloudDB.streamPlant(plantID: plantID),
      child: StreamProvider<UserData>.value(
        value: Provider.of<CloudDB>(context).streamCurrentUser(),
        child: ScreenTemplate(
          backgroundColor: kGreenMedium,
          screenTitle: 'Plant Profile',
          body: ListView(
            children: <Widget>[
              Consumer<DocumentSnapshot>(
                builder: (context, DocumentSnapshot plantSnap, _) {
                  if (plantSnap != null) {
                    //convert snap into something useful
                    PlantData plant = PlantData.fromMap(map: plantSnap.data());
                    //images
                    List<ImageData> listImageData = (plant.imageSets != null)
                        ? plant.imageSets.reversed.toList()
                        : null;
                    //check number of images to decide whether to build carousel or grid
                    bool carouselView = (plant.imageSets != null &&
                            plant.imageSets.length >= changeToGridView)
                        ? false
                        : true;
                    List<Widget> imageWidgets =
                        UIBuilders.generateImageTileWidgets(
                      plantOwner: plant.owner,
                      connectionLibrary: connectionLibrary,
                      plantID: plantID,
                      thumbnail: plant != null ? plant.thumbnail : '',
                      //the below check is necessary for deleting a plant via the button on plant screen
                      //reversed the image list so most recent photos are first
                      imageSets: listImageData,
                      largeWidget: carouselView,
                    );
                    //if there are too many photos, it's annoying to scroll.
                    //create a grid view to display instead
                    if (carouselView == false) {
                      return Container(
                        color: kGreenMedium,
                        child: Column(
                          children: <Widget>[
                            GridView.count(
                              padding: EdgeInsets.all(1),
                              crossAxisCount: 3,
                              primary: false,
                              shrinkWrap: true,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1,
                              children: imageWidgets,
                            ),
                          ],
                        ),
                      );
                    } else {
                      //add an image add button to the list for user library
                      if (showAddImage == true) {
                        //place image add at the beginning for carousel
                        imageWidgets.insert(
                          0,
                          AddPhoto(
                            plantCreationDate: plant.created,
                            plantID: plantID,
                            largeWidget: carouselView,
                          ),
                        );
                      }
                      //initial slide index
                      //if current user library and at least two items (Add Image Buttons and an image)
                      //Then start at index 1, the first image
                      int initialSlideIndex = (imageWidgets.length >= 2 &&
                              connectionLibrary == false)
                          ? 1
                          : 0;
                      return Container(
                        // color: kGreenDark,
                        decoration: BoxDecoration(
                            gradient: kGradientGreenVerticalMedDark),
                        child: CarouselSlider(
                          items: imageWidgets,
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            //index 0 is add image, default to index 0 if no images, otherwise start at 1
                            //this will mean take image will be one scroll away
                            initialPage: initialSlideIndex,
                            height: MediaQuery.of(context).size.width * 0.94,
                            viewportFraction: 0.97,
                            enableInfiniteScroll: false,
                          ),
                        ),
                      );
                    }
                  } else {
                    return SizedBox();
                  }
                },
              ),
              Consumer<DocumentSnapshot>(
                builder: (context, DocumentSnapshot plantSnap, _) {
                  //check for data as well so that if delete plant no error calling owner later for admin
                  if (plantSnap != null && plantSnap.data() != null) {
                    PlantData plant = PlantData.fromMap(map: plantSnap.data());

                    //show plant status for other users only
                    bool showPlantStatus = (connectionLibrary == true &&
                        (plant.sell == true || plant.want == true));

                    //unpack bloom to display each widget
                    List<Map> bloomSequence = [];
                    plant.sequenceBloom
                        .forEach((item) => bloomSequence.add(item.toMap()));

                    //unpack growth to display widget
                    List<Map> growthSequence = [];
                    plant.sequenceGrowth
                        .forEach((item) => growthSequence.add(item.toMap()));
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          color: kGreenMedium,
                          padding: EdgeInsets.symmetric(vertical: 1.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  ViewerUtilityButtons(
                                    plant: plant,
                                    showPlantStatus: showPlantStatus,
                                  ),
                                ],
                              ),
                              //make sure this is the same number as carousel
                              (showAddImage == true &&
                                      plant.imageSets.length >=
                                          changeToGridView)
                                  ? GridViewAddImages(plant: plant)
                                  : SizedBox(),
                              //BLOOM SEQUENCE
                              (plant.sequenceBloom.length > 0)
                                  ? PlantSequence(
                                      plantID: plant.id,
                                      sequenceData: bloomSequence,
                                      dataType: BloomData,
                                      connectionLibrary: connectionLibrary,
                                    )
                                  : SizedBox(),
                              //GROWTH SEQUENCE
                              (plant.sequenceGrowth.length > 0)
                                  ? PlantSequence(
                                      plantID: plant.id,
                                      sequenceData: growthSequence,
                                      dataType: GrowthData,
                                      connectionLibrary: connectionLibrary,
                                    )
                                  : SizedBox(),
                              UIBuilders.displayInfoCards(
                                connectionLibrary: connectionLibrary,
                                plant: plant,
                                context: context,
                              ),
                              (showOwnerUserInfo == true)
                                  ? FutureProvider<UserData>.value(
                                      value: CloudDB.futureUserData(
                                        userID: plant.owner,
                                      ),
                                      child: Consumer<UserData>(
                                        builder: (context, plantOwner, _) {
                                          if (plantOwner == null) {
                                            return SizedBox();
                                          } else {
                                            return StreamProvider<
                                                    UserData>.value(
                                                value: CloudDB.streamUserData(
                                                  userID: Provider.of<AppData>(
                                                          context)
                                                      .currentUserInfo
                                                      .id,
                                                ),
                                                child: SearchUserTile(
                                                    user: plantOwner));
                                          }
                                        },
                                      ),
                                    )
                                  : SizedBox(),
                              //ADMIN AND CREATOR ONLY FUNCTION!
                              (showAdmin == true)
                                  ? PlantAdminFunctions(
                                      plant: plant, plantID: plantID)
                                  : SizedBox(),
                            ],
                          ),
                        ),
//                          (connectionLibrary == true)
//                              ? SizedBox()
//                              :
                        //display nothing for connection if no journal entries
                        (connectionLibrary == true && plant.journal.length == 0)
                            ? SizedBox()
                            : Container(
                                child: Column(
                                  children: <Widget>[
                                    //add the header for all
                                    SectionHeader(
                                      title: 'JOURNAL',
                                      trailing:
                                          //now include the add button only for user library
                                          (connectionLibrary == false)
                                              ? AddJournalButton(
                                                  documentID: plant.id,
                                                  collection: DBFolder.plants,
                                                  documentKey:
                                                      PlantKeys.journal)
                                              : SizedBox(),
                                    ),
                                    SizedBox(
                                      height: 1.0,
                                    ),
                                    UIBuilders.displayJournalTiles(
                                        connectionLibrary: connectionLibrary,
                                        journals: plant.journal,
                                        documentID: plant.id)
                                  ],
                                ),
                              ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
                // ),
              ),
              SizedBox(
                height: 10,
              ),
              Consumer<DocumentSnapshot>(
                builder: (context, DocumentSnapshot plantSnap, _) {
                  if (plantSnap != null) {
                    PlantData plant = PlantData.fromMap(map: plantSnap.data());

                    //now check to make sure the ID exists
                    //this is for case where plant was deleted while you are viewing
                    if (plant.id != '') {
                      //if it is your personal library return delete/share
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //if you own the library then show delete
                          (showDeleteInsteadOfReport == true)
                              ? ActionButton(
                                  icon: Icons.delete_forever,
                                  action: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogConfirm(
                                          title: 'Remove Plant',
                                          text:
                                              'Are you sure you would like to remove this plant?  All photos and information will be permanently deleted.  '
                                              'This cannot be undone!',
                                          buttonText: 'DELETE',
                                          hideCancel: false,
                                          onPressed: () {
                                            //pop dialog
                                            Navigator.pop(context);
                                            if (plant.owner ==
                                                Provider.of<AppData>(context,
                                                        listen: false)
                                                    .currentUserInfo
                                                    .id) {
                                              //delete plant
                                              CloudDB.deleteDocumentL1(
                                                  document: plantID,
                                                  collection: DBFolder.plants);
                                              //remove plant reference from collection
                                              Provider.of<CloudDB>(context,
                                                      listen: false)
                                                  .updateArrayInDocumentInCollection(
                                                      arrayKey:
                                                          CollectionKeys.plants,
                                                      entries: [plantID],
                                                      folder:
                                                          DBFolder.collections,
                                                      documentName:
                                                          forwardingCollectionID,
                                                      action: false);
                                              //pop old plant profile
                                              Navigator.pop(context);
                                              //NOTE: deletion of images is handled by a DB function
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                )
                              //otherwise provide an option to report
                              : ActionButton(
                                  icon: Icons.report_problem,
                                  action: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogConfirm(
                                            title: 'Report Plant',
                                            hideCancel: false,
                                            text:
                                                'Does this content not meet the Community Guidelines?  \n\n'
                                                'Please report only non-plant, offensive, or spam related profiles.  '
                                                'Note, misuse of this button may lead to your account being disabled.  ',
                                            buttonText: 'Report',
                                            onPressed: () async {
                                              //report user
                                              CloudDB.reportPlant(
                                                  offendingPlantID: plant.id,
                                                  reportingUser:
                                                      Provider.of<AppData>(
                                                              context)
                                                          .currentUserInfo
                                                          .id);
                                              //pop dialog
                                              Navigator.pop(context);
                                            });
                                      },
                                    );
                                  },
                                ),
                          //share plant to in app chat recipient
                          SizedBox(
                            width: 0.12 * MediaQuery.of(context).size.width,
                          ),
                          ActionButton(
                            icon: Icons.share,
                            action: () {
                              Share.share(
                                UIBuilders.sharePlant(
                                    plantMap: plantSnap.data()),
                                subject: 'Check out this plant!',
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          'This Plant is Missing or Deleted.',
//                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppTextSize.medium *
                                MediaQuery.of(context).size.width,
                            color: kGreenDark,
                          ),
                        ),
                      );
                    }
                  } else {
                    return SizedBox();
                  }
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class GridViewAddImages extends StatelessWidget {
  const GridViewAddImages({
    @required this.plant,
  });

  final PlantData plant;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TileWhite(
            child: GetImage(
                iconColor: kGreenDark,
                imageFromCamera: false,
                plantCreationDate: plant.created,
                largeWidget: false,
                widgetScale: 0.3,
                plantID: plant.id),
          ),
        ),
        Expanded(
          child: TileWhite(
            child: GetImage(
                iconColor: kGreenDark,
                imageFromCamera: true,
                plantCreationDate: plant.created,
                largeWidget: false,
                widgetScale: 0.3,
                plantID: plant.id),
          ),
        ),
      ],
    );
  }
}

class PlantAdminFunctions extends StatelessWidget {
  const PlantAdminFunctions({
    @required this.plant,
    @required this.plantID,
  });

  final PlantData plant;
  final String plantID;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: AdminButton(
            label: 'Delete Plant and Report User\n'
                'plantID: $plantID',
            onPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogConfirm(
                      title: 'Delete Plant',
                      text:
                          'Does this plant not meet the Community Guidelines?  '
                          '\n\nIf you choose to delete, this cannot be undone!',
                      buttonText: 'Delete',
                      hideCancel: false,
                      onPressed: () async {
                        //report user
                        CloudDB.reportUser(
                            userID: plant.owner,
                            reportingUser:
                                Provider.of<AppData>(context, listen: false)
                                    .currentUserInfo
                                    .id);
                        //get the collection
                        List<CollectionData> collections =
                            await CloudDB.futureCollectionsData(
                                userID: plant.owner);
                        //check for plant id
                        for (CollectionData collection in collections) {
                          if (collection.plants.contains(plant.id)) {
                            //remove plant reference from collection
                            await CloudDB.updateDocumentL2Array(
                              collectionL1: DBFolder.users,
                              documentL1: plant.owner,
                              collectionL2: DBFolder.collections,
                              documentL2: collection.id,
                              key: CollectionKeys.plants,
                              entries: [plantID],
                              action: false,
                            );
                          }
                        }
                        //delete plant
                        await CloudDB.deleteDocumentL1(
                            document: plantID, collection: DBFolder.plants);
                        //notify the user
                        Map<String, dynamic> data = CommunicationData(
                                subject: 'Plant Deletion',
                                text:
                                    'The following plant was found not to meet the Community Guidelines and has been removed:  \n\n'
                                    '${plant.name} ${plant.variety} ${plant.hybrid} ${plant.species} ${plant.genus}\n\n'
                                    'For more detail on our Guidelines, go to "Conduct" in the "Settings" tab.  ',
                                read: false,
                                type: CommunicationTypes.alert,
                                date: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                visible: true,
                                reference: null)
                            .toMap();
                        //upload the notification
                        CloudDB.setDocumentL2(
                            collectionL1: DBFolder.communications,
                            documentL1: DBDocument.adminToUser,
                            collectionL2: plant.owner,
                            documentL2: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            data: data,
                            merge: false);
                        //pop dialog
                        Navigator.pop(context);
                        //pop old plant profile
                        Navigator.pop(context);
                        //NOTE: deletion of images is handled by a DB function
                      });
                },
              );
            },
          ),
        ),
        plant.isFlagged
            ? Expanded(
                child: AdminButton(
                  label: 'Unflag this Plant',
                  color: Colors.blue,
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogConfirm(
                            title: 'Remove Plant Flag',
                            text:
                                'Does this plant meet the Community Guidelines?  '
                                'If so, would you like to remove the flag?  ',
                            buttonText: 'Yes',
                            hideCancel: false,
                            onPressed: () async {
                              //package data
                              Map<String, dynamic> data = {
                                PlantKeys.isFlagged: false
                              };

                              //upload changes
                              await CloudDB.updateDocumentL1(
                                collection: DBFolder.plants,
                                document: plant.id,
                                data: data,
                              );

                              //pop dialog
                              Navigator.pop(context);
                              //pop old plant profile
                              Navigator.pop(context);
                            });
                      },
                    );
                  },
                ),
              )
            : SizedBox()
      ],
    );
  }
}
