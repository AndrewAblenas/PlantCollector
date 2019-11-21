import 'package:flutter/material.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/widgets/dialogs/dialog_input.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/formats/colors.dart';

//*****WIDGET PURPOSE*****//
//to present a plant document key/value pair
//information can be removed and set to null via long press
//information can be updated by tapping the description and inputting in the popup

class PlantInfoCard extends StatelessWidget {
  final String plantID;
  final String cardKey;
  final String displayLabel;
  final String displayText;
  PlantInfoCard(
      {@required this.plantID,
      @required this.cardKey,
      @required this.displayLabel,
      @required this.displayText});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogConfirm(
              title: 'Remove Information',
              text:
                  'Are you sure you would like to remove this information and hide the tile?',
              onPressed: () {
                Provider.of<CloudDB>(context).newDataInput = null;
                Provider.of<CloudDB>(context).updateDocumentInCollection(
                    data: Provider.of<CloudDB>(context)
                        .updatePairInput(key: cardKey),
                    collection: kUserPlants,
                    documentName: plantID);
                Navigator.pop(context);
              },
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 5.0,
          right: 5.0,
          top: 3.0,
          bottom: 5.0,
        ),
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          boxShadow: kShadowBox,
          color: kGreenDark,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                '$displayText',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:
                      AppTextSize.huge * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.medium,
                  color: AppTextColor.white,
                  shadows: kShadowText,
                ),
              ),
            ),
            Container(
              height: 24.0 * MediaQuery.of(context).size.width * kTextScale,
              child: FlatButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.edit,
                        size: AppTextSize.tiny *
                            MediaQuery.of(context).size.width,
                        color: kGreenMedium,
                      ),
                      SizedBox(
                        width: 5.0 *
                            MediaQuery.of(context).size.width *
                            kTextScale,
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
                    //to ensure userID and userEmail can't be edited
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return DialogInput(
                          title: displayLabel,
                          text:
                              '$displayText\n\n Please provide and update below.',
                          hintText: displayText,
                          onPressedSubmit: () {
                            //update the value
                            Provider.of<CloudDB>(context)
                                .updateDocumentInCollection(
                                    data: Provider.of<CloudDB>(context)
                                        .updatePairInput(key: cardKey),
                                    collection: kUserPlants,
                                    documentName: plantID);

                            Navigator.pop(context);
                          },
                          onChangeInput: (input) {
                            Provider.of<CloudDB>(context).newDataInput = input;
                          },
                          onPressedCancel: () {
//                            Provider.of<CloudDB>(context).newDataInput = null;
//                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
