import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';

//*****WIDGET PURPOSE*****//
//to present a plant document key/value pair
//information can be removed and set to null via long press
//information can be updated by tapping the description and inputting in the popup

class PlantInfoCard extends StatelessWidget {
  final bool connectionLibrary;
  final String plantID;
  final int dateCreated;
  final String cardKey;
  final String displayLabel;
  final dynamic displayText;
  final bool italicize;
  final bool showContainer;
  PlantInfoCard(
      {@required this.connectionLibrary,
      @required this.plantID,
      @required this.dateCreated,
      @required this.cardKey,
      @required this.displayLabel,
      @required this.displayText,
      @required this.italicize,
      this.showContainer = true});
  @override
  Widget build(BuildContext context) {
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: false);
    //*****SET WIDGET VISIBILITY START*****//

    //enable dialogs only if library belongs to the current user
    bool enableDialogs = (connectionLibrary == false);

    //enable dialogs only if library belongs to the current user
    bool showEditIcon = (connectionLibrary == false);

    //show date picker instead of input screen
    bool showDatePickerInstead = (cardKey == PlantKeys.dateAcquired);

    //plant info card contents
    Widget contents = PlantInfoCardContent(
        displayText: displayText,
        italicize: italicize,
        showEditIcon: showEditIcon,
        displayLabel: displayLabel,
        enableDialogs: enableDialogs,
        showDatePickerInstead: showDatePickerInstead,
        plantID: plantID,
        cardKey: cardKey,
        dateCreated: dateCreated);

    //*****SET WIDGET VISIBILITY END*****//

    return GestureDetector(
      onLongPress: () {
        if (enableDialogs == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogConfirm(
                hideCancel: false,
                title: 'Remove Information',
                text: 'Are you sure you would like to remove this information?',
                onPressed: () {
                  provAppDataFalse.newDataInput = null;
                  CloudDB.updateDocumentL1(
                      collection: DBFolder.plants,
                      document: plantID,
                      data: {cardKey: provAppDataFalse.newDataInput});
                  Navigator.pop(context);
                },
              );
            },
          );
        }
      },
      child: (showContainer == true)
          ? TileWhite(
              child: contents,
            )
          : contents,
    );
  }
}

class PlantInfoCardContent extends StatelessWidget {
  const PlantInfoCardContent({
    @required this.displayText,
    @required this.italicize,
    @required this.showEditIcon,
    @required this.displayLabel,
    @required this.enableDialogs,
    @required this.showDatePickerInstead,
    @required this.plantID,
    @required this.cardKey,
    @required this.dateCreated,
  });

  final dynamic displayText;
  final bool italicize;
  final bool showEditIcon;
  final String displayLabel;
  final bool enableDialogs;
  final bool showDatePickerInstead;
  final String plantID;
  final String cardKey;
  final int dateCreated;

  @override
  Widget build(BuildContext context) {
    //easy reference
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: false);
    //easy scale
    double relativeWidth = MediaQuery.of(context).size.width;
    return Column(
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
              fontSize: AppTextSize.huge * relativeWidth,
              fontWeight: AppTextWeight.medium,
              color: AppTextColor.black,
//                  shadows: kShadowText,
            ),
          ),
        ),
        Container(
          height: 24.0 * relativeWidth * kScaleFactor,
          child: FlatButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //only show the edit icon for current user library
                (showEditIcon == true)
                    ? Icon(
                        Icons.edit,
                        size: AppTextSize.tiny * relativeWidth,
                        color: AppTextColor.light,
                      )
                    : SizedBox(),
                SizedBox(
                  width: 5.0 * relativeWidth * kScaleFactor,
                ),
                Text(
                  '$displayLabel',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: AppTextSize.small * relativeWidth,
                    fontWeight: AppTextWeight.heavy,
                    color: AppTextColor.light,
                  ),
                ),
              ],
            ),
            onPressed: () async {
              if (enableDialogs == true) {
                //check for date picker int fields first
                if (PlantKeys.listDatePickerKeys.contains(cardKey)) {
                  DateTime date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    //this should be close to the beginning of year 1
                    firstDate:
                        DateTime.fromMillisecondsSinceEpoch(-2177452799000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    int value = date.millisecondsSinceEpoch;
                    //update
                    CloudDB.updateDocumentL1(
                      collection: DBFolder.plants,
                      document: plantID,
                      data: {
                        cardKey: value,
                        PlantKeys.update: CloudDB.delayUpdateWrites(
                            timeCreated: dateCreated,
                            document: provAppDataFalse.currentUserInfo.id)
                      },
                    );
                  }
                  //otherwise check if text input
                } else if (PlantKeys.listStringKeys.contains(cardKey)) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogScreenInput(
                            title: 'Update Information',
                            acceptText: 'Update',
                            acceptOnPress: () {
                              //format search categories to lower case
                              String value = provAppDataFalse.newDataInput;

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
                                CloudDB.updateDocumentL1(
                                  collection: DBFolder.plants,
                                  document: plantID,
                                  data: {
                                    cardKey: value,
                                    PlantKeys.update: CloudDB.delayUpdateWrites(
                                        timeCreated: dateCreated,
                                        document:
                                            provAppDataFalse.currentUserInfo.id)
                                  },
                                );
                              }
                              //clear data
                              provAppDataFalse.newDataInput = null;
                              //pop context
                              Navigator.pop(context);
                            },
                            onChange: (input) {
                              provAppDataFalse.newDataInput = input;
                            },
                            cancelText: 'Cancel',
                            //in the case of variety, don't pass the single quotes and spaces
                            hintText: (cardKey != PlantKeys.variety)
                                ? displayText.toString()
                                : displayText.toString().substring(
                                    1, displayText.toString().length - 1));
                      });
                  //future in case int select or similar is added
                } else {}
              }
            },
          ),
        )
      ],
    );
  }
}
