import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:provider/provider.dart';

class AddJournalButton extends StatelessWidget {
  final String documentID;
  final String collection;
  final String documentKey;
  AddJournalButton(
      {@required this.documentID,
      @required this.collection,
      @required this.documentKey});

  @override
  Widget build(BuildContext context) {
    //easy reference
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: false);
    //easy scale
    double relativeWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: AppTextSize.large * 1.5 * relativeWidth,
      child: FlatButton(
          child: Icon(
            Icons.add_circle,
            color: AppTextColor.dark,
            size: AppTextSize.large * relativeWidth,
          ),
          onPressed: () {
            //open an input screen
            showDialog(
                context: context,
                builder: (context) {
                  //first screen to add the title
                  return DialogScreenInput(
                      title: 'Title',
                      acceptText: 'Add',
                      acceptOnPress: () {
                        Map data = provAppDataFalse
                            .journalNew(title: provAppDataFalse.newDataInput)
                            .toMap();
                        //clear text for next entry
                        provAppDataFalse.newDataInput = '';
                        //now show another screen to allow input for entry
                        //close the popup
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) {
                              //second screen to add the body entry
                              return DialogScreenInput(
                                  title: 'Entry Body',
                                  acceptText: 'Add',
                                  smallText: true,
                                  acceptOnPress: () {
                                    //on press set equal to data input
                                    data[JournalKeys.entry] =
                                        provAppDataFalse.newDataInput;
                                    //upload data to plant journal
                                    CloudDB.updateDocumentL1Array(
                                        collection: collection,
                                        document: documentID,
                                        key: documentKey,
                                        entries: [data],
                                        action: true);
                                    Navigator.pop(context);
                                  },
                                  onChange: (input) {
                                    provAppDataFalse.newDataInput = input;
                                  },
                                  cancelText: 'Cancel',
                                  hintText: null);
                            });
                      },
                      onChange: (input) {
                        provAppDataFalse.newDataInput = input;
                      },
                      cancelText: 'Cancel',
                      hintText: null);
                });
          }),
    );
  }
}
