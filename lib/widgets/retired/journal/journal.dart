import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/journal_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/plant/widgets/add_journal_button.dart';
import 'package:plant_collector/screens/plant/widgets/journal_tile.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:provider/provider.dart';

class JournalScreen extends StatelessWidget {
  final PlantData plant;
  JournalScreen({@required this.plant});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<DocumentSnapshot>.value(
      value: Provider.of<CloudDB>(context).streamPlant(
//          userID:
////    connectionLibrary == false
////    ?
//              Provider.of<CloudDB>(context).currentUserFolder,
//        : Provider.of<CloudDB>(context).connectionUserFolder,
          plantID: plant.id),
      child: ScreenTemplate(
        screenTitle: 'Journal',
        body: ListView(
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
            AddJournalButton(
              plantID: plant.id,
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
                      JournalTile(
                        journalList: null,
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
