import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/widgets/container_card.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';

class ViewerUtilityButtons extends StatelessWidget {
  final PlantData plant;
  ViewerUtilityButtons({@required this.plant});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.98 * MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                //show confirm dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogConfirm(
                        title: 'Clone Plant',
                        text:
                            'Are you sure you want to copy this Plant information to your personal Library?',
                        buttonText: 'Clone',
                        hideCancel: false,
                        onPressed: () {
                          //PLANT
                          //generate a new ID
                          String plantID = AppData.generateID(prefix: 'plant_');
                          //clean the plant data
                          Map data = Provider.of<CloudDB>(context).cleanPlant(
                              plantData: plant.toMap(), id: plantID);
                          //add new plant to userPlants
                          Provider.of<CloudDB>(context).setDocumentL1(
                              data: data,
                              collection: DBFolder.plants,
                              document: data[PlantKeys.id]);
                          //COLLECTION
                          //first check if clone collection exists
                          bool match = false;
                          for (CollectionData collection
                              in Provider.of<AppData>(context)
                                  .currentUserCollections) {
                            if (collection.id == DBDefaultDocument.clone) {
                              match = true;
                            } else {
                              //do nothing
                            }
                          }
                          //if no match is found create the default collection
                          if (match == false) {
                            //create a map from the data
                            Map collection = Provider.of<AppData>(context)
                                .newDefaultCollection(
                                    collectionName: DBDefaultDocument.clone)
                                .toMap();
                            //upload new collection data
                            Provider.of<CloudDB>(context)
                                .insertDocumentToCollection(
                                    data: collection,
                                    collection: DBFolder.collections,
                                    documentName: DBDefaultDocument.clone,
                                    merge: true);
                          }

                          //update
                          Provider.of<CloudDB>(context)
                              .updateArrayInDocumentInCollection(
                                  arrayKey: CollectionKeys.plants,
                                  entries: [plantID],
                                  folder: DBFolder.collections,
                                  documentName: DBDefaultDocument.clone,
                                  action: true);

                          //GROUP
                          //first check if clone collection exists
                          match = false;
                          for (GroupData group in Provider.of<AppData>(context)
                              .currentUserGroups) {
                            if (group.id == DBDefaultDocument.import) {
                              match = true;
                            } else {
                              //do nothing
                            }
                          }
                          //if no match is found create the default collection
                          if (match == false) {
                            //create a map from the data
                            Map group = Provider.of<AppData>(context)
                                .createDefaultGroup(
                                    groupName: DBDefaultDocument.import)
                                .toMap();
                            //upload new collection data
                            Provider.of<CloudDB>(context)
                                .insertDocumentToCollection(
                                    data: group,
                                    collection: DBFolder.groups,
                                    documentName: DBDefaultDocument.import,
                                    merge: true);
                          }
                          //update
                          Provider.of<CloudDB>(context)
                              .updateArrayInDocumentInCollection(
                                  arrayKey: GroupKeys.collections,
                                  entries: [DBDefaultDocument.clone],
                                  folder: DBFolder.groups,
                                  documentName: DBDefaultDocument.import,
                                  action: true);

                          //now that the cloning is complete, add to original plant clone count

                          //update the original plant clone count
                          Provider.of<CloudDB>(context).updatePlantCloneCount(
                              plantID: plant.id, currentValue: plant.clones);

                          //close
                          Navigator.pop(context);
                        });
                  },
                );
              },
              child: ContainerCard(
                color: AppTextColor.white,
                child: Padding(
                  padding: EdgeInsets.all(
                    5.0 * MediaQuery.of(context).size.width * kScaleFactor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.control_point_duplicate,
                        size: AppTextSize.large *
                            MediaQuery.of(context).size.width,
                        color: AppTextColor.black,
                      ),
                      SizedBox(
                        width: 20.0 *
                            MediaQuery.of(context).size.width *
                            kScaleFactor,
                      ),
                      Text(
                        'Clone Plant',
                        style: TextStyle(
                          color: AppTextColor.black,
                          fontSize: AppTextSize.large *
                              MediaQuery.of(context).size.width,
                          fontWeight: AppTextWeight.medium,
//                shadows: kShadowText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          StreamProvider<UserData>.value(
            value: CloudDB.streamUserData(
                userID: Provider.of<AppData>(context).currentUserInfo.id),
            child: Consumer<UserData>(builder: (context, user, _) {
              if (user != null) {
                return GestureDetector(
                  onTap: () {
                    Provider.of<CloudDB>(context).updatePlantLike(
                        plantID: plant.id,
                        likes: plant.likes,
                        likeList: user.likedPlants);
                  },
                  child: ContainerCard(
                    color: AppTextColor.white,
                    child: Padding(
                      padding: EdgeInsets.all(
                        5.0 * MediaQuery.of(context).size.width * kScaleFactor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 10.0 *
                                MediaQuery.of(context).size.width *
                                kScaleFactor,
                          ),
                          Text(
                            '${plant.likes}',
                            style: TextStyle(
                              color: AppTextColor.black,
                              fontSize: AppTextSize.large *
                                  MediaQuery.of(context).size.width,
                              fontWeight: AppTextWeight.medium,
//                shadows: kShadowText,
                            ),
                          ),
                          SizedBox(
                            width: 10.0 *
                                MediaQuery.of(context).size.width *
                                kScaleFactor,
                          ),
                          Icon(
                            Icons.thumb_up,
                            size: AppTextSize.large *
                                MediaQuery.of(context).size.width,
                            color: kGreenDark,
                          ),
                          SizedBox(
                            width: 10.0 *
                                MediaQuery.of(context).size.width *
                                kScaleFactor,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
          ),
        ],
      ),
    );
  }
}
