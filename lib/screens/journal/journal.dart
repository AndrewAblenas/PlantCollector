import 'package:flutter/material.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:provider/provider.dart';

class JournalScreen extends StatelessWidget {
  final bool connectionLibrary;
  final String userID;
  JournalScreen({this.connectionLibrary = true, @required this.userID});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData>.value(
      value: CloudDB.streamUserData(userID: userID),
      child: ScreenTemplate(
        screenTitle: 'Journal',
        body: ListView(
          primary: false,
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            //build out the journal entries
            Consumer<UserData>(
              builder: (context, UserData user, _) {
                //check to make sure snapshot has data
                //if has data create a plant otherwise set to null to skip build
                if (user != null && user.journal != null) {
                  //return the entries builder
                  return UIBuilders.displayActivityJournalTiles(
                      journals: user.journal,
                      documentID: user.id,
                      connectionLibrary: connectionLibrary,
                      context: context);
                } else {
                  return Column(
                    children: <Widget>[SizedBox()],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
