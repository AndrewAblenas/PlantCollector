import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/app_data.dart';

class JournalScreen extends StatelessWidget {
  final PlantData plant;
  JournalScreen({@required this.plant});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<DocumentSnapshot>.value(
      value: Provider.of<CloudDB>(context).streamJournal(
          userID:
//    connectionLibrary == false
//    ?
              Provider.of<CloudDB>(context).currentUserFolder,
//        : Provider.of<CloudDB>(context).connectionUserFolder,
          plantID: plant.id),
      child: ScreenTemplate(
        screenTitle: 'Journal',
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: <Widget>[
            Container(
              color: kGreenDark,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    '${plant.name}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: AppTextSize.huge *
                            MediaQuery.of(context).size.width,
                        fontWeight: AppTextWeight.medium,
                        shadows: kShadowText,
                        color: AppTextColor.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
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
                                      title: Provider.of<AppData>(context)
                                          .newDataInput)
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
                                          Provider.of<CloudDB>(context)
                                              .journalCreateEntry(
                                            arrayKey: data[JournalKeys.date],
                                            entry: data,
                                            documentName: plant.id,
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
                                          Provider.of<AppData>(context)
                                              .newDataInput = input;
                                        },
                                        cancelText: 'Cancel',
                                        hintText: null);
                                  });
                            },
                            onChange: (input) {
                              Provider.of<AppData>(context).newDataInput =
                                  input;
                            },
                            cancelText: 'Cancel',
                            hintText: null);
                      });
                },
                child: ContainerWrapper(
                  color: kGreenDark,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'NEW ENTRY',
                          style: TextStyle(
                              color: AppTextColor.white,
                              fontSize: AppTextSize.huge *
                                  MediaQuery.of(context).size.width,
                              fontWeight: AppTextWeight.medium,
                              shadows: kShadowText),
                        ),
//                      SizedBox(
//                        width: 20.0 *
//                            MediaQuery.of(context).size.width *
//                            kScaleFactor,
//                      ),
                        Icon(
                          Icons.create,
                          size: AppTextSize.large *
                              MediaQuery.of(context).size.width,
                          color: AppTextColor.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //build out the journal entries
            Consumer<DocumentSnapshot>(
              builder: (context, DocumentSnapshot journalSnap, _) {
                //check to make sure snapshot has data
                //if has data create a plant otherwise set to null to skip build
                Map journal = (journalSnap != null && journalSnap.data != null)
                    ? journalSnap.data
                    : null;
                //check to make sure plant is passed and there is at least one journal entry
                if (journal != null && journal.keys.length >= 1) {
                  //initialize list of entries
                  List<Map> values = [];
                  List<Widget> journalEntries = [];
//                String date;
                  //generate a list of the keys
                  List<String> keys = journal.keys.toList();
                  //sort the list
                  keys.sort((a, b) => a.toString().compareTo(b.toString()));
                  //now generate list of value
                  //reverse the keys so most recent is first
                  for (String key in keys) {
                    values.add(journal[key]);
                  }
                  //generate a widget for each entry and add to the list
                  for (Map entry in values) {
                    JournalData entryBuild = JournalData.fromMap(map: entry);
                    //allow the post to be edited only for 24hrs
                    bool showEdit = (DateTime.now().millisecondsSinceEpoch -
                                int.parse(entryBuild.date) <=
                            86400000)
                        ? true
                        : false;
//                  bool showDate = (date == entryBuild.date);
                    journalEntries.add(
                      JournalPage(
                        journal: entryBuild,
                        showDate: true,
                        showEdit: showEdit,
                        plantID: plant.id,
                      ),
                    );
//                  date = entryBuild.date;
                  }

                  //return the entries in a column
                  return Column(
                    //reverse the entries so most recent is first
                    children: journalEntries.reversed.toList(),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class JournalPage extends StatelessWidget {
  final JournalData journal;
  final bool showDate;
  final bool showEdit;
  final String plantID;
  JournalPage(
      {@required this.journal,
      @required this.showDate,
      @required this.showEdit,
      @required this.plantID});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          ContainerWrapper(
            marginVertical: 1.0,
            color: AppTextColor.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        journal.title.toUpperCase(),
                        style: TextStyle(
                          fontSize: AppTextSize.large *
                              MediaQuery.of(context).size.width,
                          color: AppTextColor.black,
                          fontWeight: AppTextWeight.medium,
                        ),
                      ),
                      SizedBox(),
                      showEdit == true
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
                                                    Provider.of<CloudDB>(
                                                            context)
                                                        .journalEntryUpdate(
                                                      arrayKey: data[
                                                          JournalKeys.date],
                                                      entry: data,
                                                      documentName: plantID,
                                                      action: true,
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
        ],
      ),
    );
  }
}
