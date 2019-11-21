import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/screens/plant/plant.dart';
import 'package:plant_collector/widgets/dialogs/select/dialog_select.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/app_data.dart';

class CollectionPlantTile extends StatelessWidget {
//  final Map plantMap;
  final String collectionID;
  final Map plantMap;
  final List<dynamic> possibleParents;
  CollectionPlantTile({
//    @required this.plantMap,
    @required this.collectionID,
    @required this.plantMap,
    @required this.possibleParents,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        print(possibleParents);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogSelect(
              title: 'Move Plant',
              text: 'Where would you like to move this plant?',
              plantID: plantMap[kPlantID],
              menuItems: Provider.of<UIBuilders>(context)
                  .createDialogCollectionButtons(
                selectedItemID: plantMap[kPlantID],
                currentParentID: collectionID,
                possibleParents: possibleParents,
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          image: plantMap[kPlantThumbnail] != null
              ? DecorationImage(
                  image: CachedNetworkImageProvider(plantMap[kPlantThumbnail]),
                  fit: BoxFit.fill,
                )
              : DecorationImage(
                  image: AssetImage(
                    'assets/images/default.png',
                  ),
                  fit: BoxFit.fill,
                ),
          boxShadow: kShadowBox,
          shape: BoxShape.rectangle,
        ),
        child: FlatButton(
          onPressed: () {
            //TODO might not need
            Provider.of<AppData>(context).forwardingPlantID =
                plantMap[kPlantID];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantScreen(
                  plantID: plantMap[kPlantID],
                  forwardingCollectionID: collectionID,
                ),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              plantMap[kPlantName] != null
                  ? Padding(
                      padding: EdgeInsets.all(
                          1.0 * MediaQuery.of(context).size.width * kTextScale),
                      child: Container(
                        color: const Color(0x44000000),
                        margin: EdgeInsets.all(2.0 *
                            MediaQuery.of(context).size.width *
                            kTextScale),
                        padding: EdgeInsets.all(3.0 *
                            MediaQuery.of(context).size.width *
                            kTextScale),
                        constraints: BoxConstraints(
                          maxHeight: 50.0 *
                              MediaQuery.of(context).size.width *
                              kTextScale,
                        ),
                        child: Text(
                          plantMap[kPlantName],
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: AppTextSize.tiny *
                                MediaQuery.of(context).size.width,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
