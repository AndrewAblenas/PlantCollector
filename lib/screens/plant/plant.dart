import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/formats/colors.dart';

class PlantScreen extends StatelessWidget {
  final String forwardingCollectionID;
  final String plantID;
  PlantScreen({@required this.plantID, @required this.forwardingCollectionID});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<DocumentSnapshot>.value(
      value: Provider.of<CloudDB>(context).streamPlant(plantID: plantID),
      child: Scaffold(
        backgroundColor: kGreenLight,
        appBar: AppBar(
          backgroundColor: kGreenDark,
          centerTitle: true,
          elevation: 20.0,
          title: Text(
            '',
            style: kAppBarTitle,
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Consumer<DocumentSnapshot>(
                  builder: (context, DocumentSnapshot plantData, _) {
                if (plantData != null) {
                  Map plantMap = plantData.data;
                  return CarouselSlider(
                    items: Provider.of<UIBuilders>(context)
                        .generateImageTileWidgets(
                      plantID: plantID,
                      listURL: plantMap[kPlantImageList],
                    ),
                    initialPage: 0,
                    height: MediaQuery.of(context).size.width * 0.96,
                    viewportFraction: 0.94,
                    enableInfiniteScroll: false,
                  );
                } else {
                  return SizedBox();
                }
              }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: Consumer<DocumentSnapshot>(
                builder: (context, DocumentSnapshot plantSnap, _) {
                  if (plantSnap != null) {
                    Map plantMap = plantSnap.data;
                    return Provider.of<UIBuilders>(context).displayInfoCards(
                      plantID: plantID,
                      plant: plantMap,
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              child: FlatButton(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.delete_forever,
                  size: AppTextSize.huge * MediaQuery.of(context).size.width,
                  color: kGreenMedium,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogConfirm(
                          title: 'Confirm Plant Removal',
                          text:
                              'Are you sure you would like to delete this plant, it\'s photos, and all related information?  '
                              '\n\nThis cannot be undone!',
                          buttonText: 'Delete Forever',
                          onPressed: () {
                            //pop dialog
                            Navigator.pop(context);
                            //remove plant reference from collection
                            Provider.of<CloudDB>(context)
                                .updateArrayInDocumentInCollection(
                                    arrayKey: kCollectionPlantList,
                                    entries: [plantID],
                                    folder: kUserCollections,
                                    documentName: forwardingCollectionID,
                                    action: false);
                            //delete plant
                            Provider.of<CloudDB>(context)
                                .deleteDocumentFromCollection(
                                    documentID: plantID,
                                    collection: kUserPlants);
                            //pop old plant profile
                            Navigator.pop(context);
                            //NOTE: deletion of images is handled by a DB function
                          });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 5),
//                  Text(
//                    plantID,
//                    textAlign: TextAlign.center,
//                    style: TextStyle(color: kGreenMedium),
//                  ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
