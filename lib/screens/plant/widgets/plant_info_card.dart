import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/widgets/container_card.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/formats/colors.dart';

//*****WIDGET PURPOSE*****//
//to present a plant document key/value pair
//information can be removed and set to null via long press
//information can be updated by tapping the description and inputting in the popup

class PlantInfoCard extends StatelessWidget {
  final bool connectionLibrary;
  final String plantID;
  final String cardKey;
  final String displayLabel;
  final dynamic displayText;
  final bool italicize;
  PlantInfoCard({
    @required this.connectionLibrary,
    @required this.plantID,
    @required this.cardKey,
    @required this.displayLabel,
    @required this.displayText,
    @required this.italicize,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (connectionLibrary == false) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogConfirm(
                hideCancel: false,
                title: 'Remove Information',
                text:
                    'Are you sure you would like to remove this information and hide the tile?',
                onPressed: () {
                  Provider.of<AppData>(context).newDataInput = null;
                  Provider.of<CloudDB>(context).updateDocumentL1(
                      collection: DBFolder.plants,
                      document: plantID,
                      data: {
                        cardKey: Provider.of<AppData>(context).newDataInput
                      });
                  Navigator.pop(context);
                },
              );
            },
          );
        }
      },
      child: ContainerCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                displayText.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle:
                      (italicize == true) ? FontStyle.italic : FontStyle.normal,
                  fontSize:
                      AppTextSize.huge * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.medium,
                  color: AppTextColor.white,
                  shadows: kShadowText,
                ),
              ),
            ),
            Container(
              height: 24.0 * MediaQuery.of(context).size.width * kScaleFactor,
              child: FlatButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //only show the edit icon for current user library
                    (connectionLibrary == false)
                        ? Icon(
                            Icons.edit,
                            size: AppTextSize.tiny *
                                MediaQuery.of(context).size.width,
                            color: kGreenMedium,
                          )
                        : SizedBox(),
                    SizedBox(
                      width: 5.0 *
                          MediaQuery.of(context).size.width *
                          kScaleFactor,
                    ),
                    Text(
                      '$displayLabel',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: AppTextSize.small *
                            MediaQuery.of(context).size.width,
                        fontWeight: AppTextWeight.heavy,
                        color: kGreenMedium,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  if (connectionLibrary == false) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogScreenInput(
                              title: 'Update Information',
                              acceptText: 'Update',
                              acceptOnPress: () {
                                //format search categories to lower case
                                String value =
                                    Provider.of<AppData>(context).newDataInput;

                                //empty check
                                if (value != null && value != '') {
                                  //storage formatting check
                                  List<String> toFormat = [
                                    PlantKeys.variety,
                                    PlantKeys.hybrid,
                                    PlantKeys.species,
                                    PlantKeys.genus,
                                  ];
                                  if (toFormat.contains(cardKey)) {
                                    value = value.toLowerCase();
                                  }
                                  //update
                                  Provider.of<CloudDB>(context)
                                      .updateDocumentL1(
                                    collection: DBFolder.plants,
                                    document: plantID,
                                    data: {
                                      cardKey: value,
                                      PlantKeys.update: CloudDB.timeNowMS()
                                    },
                                  );
                                }
                                //clear data
                                Provider.of<AppData>(context).newDataInput =
                                    null;
                                //pop context
                                Navigator.pop(context);
                              },
                              onChange: (input) {
                                Provider.of<AppData>(context).newDataInput =
                                    input;
                              },
                              cancelText: 'Cancel',
                              //in the case of variety, don't pass the single quotes and spaces
                              hintText: (cardKey != PlantKeys.variety)
                                  ? displayText.toString()
                                  : displayText.toString().substring(
                                      1, displayText.toString().length - 1));
                        });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
