import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/widgets/button_add.dart';
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
    return ButtonAdd(
        buttonText: 'Add New Entry',
        icon: Icons.edit,
        onPress: () {
          //open an input screen
          showDialog(
              context: context,
              builder: (context) {
                //first screen to add the title
                return DialogScreenInput(
                    title: 'Title',
                    acceptText: 'Add',
                    acceptOnPress: () {
                      Map data = Provider.of<AppData>(context)
                          .journalNew(
                              title: Provider.of<AppData>(context).newDataInput)
                          .toMap();
                      //clear text for next entry
                      Provider.of<AppData>(context).newDataInput = '';
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
                                      Provider.of<AppData>(context)
                                          .newDataInput;
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
                                  Provider.of<AppData>(context).newDataInput =
                                      input;
                                },
                                cancelText: 'Cancel',
                                hintText: null);
                          });
                    },
                    onChange: (input) {
                      Provider.of<AppData>(context).newDataInput = input;
                    },
                    cancelText: 'Cancel',
                    hintText: null);
              });
        });
  }
}
