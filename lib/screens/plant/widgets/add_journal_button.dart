import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/widgets/container_card.dart';
import 'package:provider/provider.dart';

class AddJournalButton extends StatelessWidget {
  final String plantID;
  AddJournalButton({
    @required this.plantID,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                                    Provider.of<AppData>(context).newDataInput;
                                //upload data to plant journal
                                Provider.of<CloudDB>(context)
                                    .journalEntryCreate(
                                        entry: data, plantID: plantID);
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
      },
      child: ContainerCard(
        color: AppTextColor.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5.0 * MediaQuery.of(context).size.width * kScaleFactor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.create,
                size: AppTextSize.large * MediaQuery.of(context).size.width,
                color: AppTextColor.black,
              ),
              SizedBox(
                width: 20.0 * MediaQuery.of(context).size.width * kScaleFactor,
              ),
              Text(
                'New Journal Entry',
                style: TextStyle(
                  color: AppTextColor.black,
                  fontSize:
                      AppTextSize.huge * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.medium,
//                shadows: kShadowText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
