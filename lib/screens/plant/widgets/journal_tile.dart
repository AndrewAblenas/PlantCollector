import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';

class JournalTile extends StatelessWidget {
  final JournalData journal;
  final bool showDate;
  final bool showEdit;
  final bool connectionLibrary;
  final String documentID;
  final String collection;
  final List journalList;
  final String journalKey;
  JournalTile(
      {@required this.journal,
      @required this.showDate,
      @required this.showEdit,
      @required this.connectionLibrary,
      @required this.documentID,
      @required this.collection,
      @required this.journalList,
      @required this.journalKey});
  @override
  Widget build(BuildContext context) {
    //set width as a variable so no need to reuse
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onLongPress: () {
              if (connectionLibrary == false) {
                //show a dialog to confirm delete
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return DialogConfirm(
                      title: 'Remove Entry',
                      text: 'Are you sure you would like to delete this entry?',
                      onPressed: () {
                        //remove the journal
                        CloudDB.journalEntryRemove(
                          documentID: documentID,
                          collection: collection,
                          journalKey: journalKey,
                          journals: journalList,
                          entry: journal.toMap(),
                        );

                        //pop the context
                        Navigator.pop(context);
                      },
                      hideCancel: false,
                    );
                  },
                );
              }
            },
            child: ContainerWrapper(
              marginVertical: 1.0,
              color: AppTextColor.white,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: width * 0.8,
                          child: Text(
                            journal.title.toUpperCase(),
                            softWrap: true,
                            style: TextStyle(
                              fontSize: AppTextSize.medium *
                                  MediaQuery.of(context).size.width,
                              color: AppTextColor.black,
                              fontWeight: AppTextWeight.medium,
                            ),
                          ),
                        ),
                        SizedBox(),
                        (showEdit == true && connectionLibrary == false)
                            ? GestureDetector(
                                onTap: () {
                                  //open an input screen
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        //first screen to add the title
                                        //set default in case user doesn't change and just hits accept
                                        Provider.of<AppData>(context)
                                            .newDataInput = journal.title;
                                        return DialogScreenInput(
                                          title: 'Title',
                                          acceptText: 'Add',
                                          hintText: journal.title,
                                          acceptOnPress: () {
                                            Map data = journal.toMap();
                                            data[JournalKeys.title] =
                                                Provider.of<AppData>(context)
                                                    .newDataInput;
                                            //clear text for next entry
                                            Provider.of<AppData>(context)
                                                .newDataInput = '';
                                            //now show another screen to allow input for entry
                                            //close the popup
                                            Navigator.pop(context);
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  //second screen to add the body entry
                                                  //set default in case user just hits accepts no change
                                                  Provider.of<AppData>(context)
                                                          .newDataInput =
                                                      journal.entry;
                                                  return DialogScreenInput(
                                                    title: 'Entry Body',
                                                    acceptText: 'Add',
                                                    hintText: journal.entry,
                                                    smallText: true,
                                                    acceptOnPress: () {
                                                      //on press set equal to data input
                                                      data[JournalKeys.entry] =
                                                          Provider.of<AppData>(
                                                                  context)
                                                              .newDataInput;
                                                      //upload data to plant journal
                                                      CloudDB
                                                          .journalEntryUpdate(
                                                        documentID: documentID,
                                                        collection: collection,
                                                        journalKey: journalKey,
                                                        journals: journalList,
                                                        entry: data,
                                                      );
                                                      //upload the data
//                                          Provider.of<CloudDB>(context)
//                                              .updateArrayInDocumentInCollection(
//                                                  arrayKey: PlantKeys.journal,
//                                                  entries: [data],
//                                                  folder: DBFolder.plants,
//                                                  documentName: plant.id,
//                                                  action: true);
                                                      //close the popup
                                                      Navigator.pop(context);
                                                    },
                                                    onChange: (input) {
                                                      Provider.of<AppData>(
                                                              context)
                                                          .newDataInput = input;
                                                    },
                                                    cancelText: 'Cancel',
                                                  );
                                                });
                                          },
                                          onChange: (input) {
                                            Provider.of<AppData>(context)
                                                .newDataInput = input;
                                          },
                                          cancelText: 'Cancel',
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: AppTextSize.medium *
                                      MediaQuery.of(context).size.width,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    SizedBox(
                      height:
                          AppTextSize.tiny * MediaQuery.of(context).size.width,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1.0,
                      color: kGreenDark,
                    ),
                    SizedBox(
                      height:
                          AppTextSize.small * MediaQuery.of(context).size.width,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
//                      CachedNetworkImage(imageUrl: null),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Text(
                            journal.entry,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: AppTextSize.small *
                                  MediaQuery.of(context).size.width,
                              fontWeight: AppTextWeight.medium,
                              color: AppTextColor.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        showDate == true
                            ? Text(
                                CloudStore.dateFormat(
                                  msSinceEpoch: int.parse(journal.date),
                                ),
                                style: TextStyle(
                                  fontSize: AppTextSize.tiny *
                                      MediaQuery.of(context).size.width,
                                  color: AppTextColor.black,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
