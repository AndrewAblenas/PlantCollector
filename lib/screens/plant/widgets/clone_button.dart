import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:plant_collector/models/data_types/group_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/journal/journal.dart';
import 'package:plant_collector/widgets/container_card.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';

class CloneButton extends StatelessWidget {
  final PlantData plant;
  CloneButton({@required this.plant});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //show confirm dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogConfirm(
                title: 'Clone Plant',
                text:
                    'Are you sure you want to clone this Plant to your Collection?',
                buttonText: 'Clone',
                onPressed: () {
                  //PLANT
                  //generate a new ID
                  String plantID = AppData.generateID(prefix: 'plant_');
                  //clean the plant data
                  Map data =
                      CloudDB.cleanPlant(plantData: plant.toMap(), id: plantID);
                  //add new plant to userPlants
                  Provider.of<CloudDB>(context).insertDocumentToCollection(
                      data: data,
                      collection: DBFolder.plants,
                      documentName: data[PlantKeys.id]);
                  //COLLECTION
                  //first check if clone collection exists
                  bool match = false;
                  for (CollectionData collection
                      in Provider.of<AppData>(context).currentUserCollections) {
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
                    Provider.of<CloudDB>(context).insertDocumentToCollection(
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
                  for (GroupData group
                      in Provider.of<AppData>(context).currentUserGroups) {
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
                        .createDefaultGroup(groupName: DBDefaultDocument.import)
                        .toMap();
                    //upload new collection data
                    Provider.of<CloudDB>(context).insertDocumentToCollection(
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

                  //close
                  Navigator.pop(context);
                });
          },
        );
      },
      child: ContainerCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.control_point_duplicate,
              size: AppTextSize.large * MediaQuery.of(context).size.width,
              color: AppTextColor.white,
            ),
            SizedBox(
              width: 20.0 * MediaQuery.of(context).size.width * kScaleFactor,
            ),
            Text(
              'Clone Plant to My Library',
              style: TextStyle(
                color: AppTextColor.white,
                fontSize: AppTextSize.large * MediaQuery.of(context).size.width,
                fontWeight: AppTextWeight.medium,
                shadows: kShadowText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
