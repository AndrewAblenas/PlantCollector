import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String date = AppData.feedbackDate();
    String userID = Provider.of<UserAuth>(context).signedInUser.uid;
    String userEmail = Provider.of<UserAuth>(context).signedInUser.email;
    return ScreenTemplate(
        screenTitle: 'Feedback',
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  ContainerWrapper(
                    child: TileWhite(
                      bottomPadding: 5.0,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Providing Feedback',
                              style: TextStyle(
                                color: AppTextColor.black,
                                fontWeight: AppTextWeight.medium,
                                fontSize: AppTextSize.huge *
                                    MediaQuery.of(context).size.width,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: 1.0,
                              color: kGreenDark,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              'At Plant Collector, we are plant people.  '
                              'We have done our best to ensure this application functions well, is enjoyable to use and provides you with something valuable.  '
                              'If for any reason we have failed to deliver, please provide your constructive feedback via the appropriate option below.  \n\n'
                              'Note: It may be necessary to access your application data in order to diagnose/fix an issue.  '
                              'This information will not be shared with any third party.  '
                              'In some situations we may also need to contact you to ensure thing have been resolved.  ',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AppTextColor.black,
                                fontWeight: AppTextWeight.medium,
                                fontSize: AppTextSize.small *
                                    MediaQuery.of(context).size.width,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ContainerWrapper(
                    child: Column(
                      children: <Widget>[
                        FeedbackButton(
                            promptA: 'Bug Title',
                            promptB: 'Summary',
                            buttonText: 'Report Bugs',
                            type: StorageFolder.feedbackBugs,
                            icon: Icons.bug_report),
                        FeedbackButton(
                            promptA: 'Feature Name',
                            promptB: 'Description',
                            buttonText: 'Suggest Features',
                            type: StorageFolder.feedbackFeatures,
                            icon: Icons.add_box),
                        //TODO move this functionality to user profile page?
                        FeedbackButton(
                            promptA: 'Issue Title',
                            promptB:
                                'Please describe the misconduct. Provide the offending user email if appropriate.',
                            buttonText: 'Report User',
                            type: StorageFolder.feedbackAbuse,
                            icon: Icons.report_problem),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class FeedbackButton extends StatelessWidget {
  FeedbackButton({
    @required this.promptA,
    @required this.promptB,
    @required this.type,
    @required this.buttonText,
    @required this.icon,
  });

  final String promptA;
  final String promptB;
  final String type;
  final String buttonText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    String date = AppData.feedbackDate();
    String userID = Provider.of<UserAuth>(context).signedInUser.uid;
    String userEmail = Provider.of<UserAuth>(context).signedInUser.email;
    return ButtonAdd(
      buttonText: buttonText,
      onPress: () {
        String title;
        showDialog(
          context: context,
          builder: (context) {
            //first screen to add the title
            return DialogScreenInput(
                title: promptA,
                acceptText: 'OK',
                acceptOnPress: () {
                  //save the title data
                  title = Provider.of<AppData>(context).newDataInput;
                  //clear text for next entry
                  Provider.of<AppData>(context).newDataInput = '';
                  //pop the window
                  Navigator.pop(context);
                  //show next dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      //first screen to add the title
                      return DialogScreenInput(
                          title: promptB,
                          acceptText: 'OK',
                          smallText: true,
                          acceptOnPress: () {
                            //save the title data
                            Provider.of<CloudDB>(context).createDocument(
                              data: CloudDB.userFeedback(
                                date: date,
                                title: title,
                                text:
                                    Provider.of<AppData>(context).newDataInput,
                                type: type,
                                userID: userID,
                                userEmail: userEmail,
                              ),
                              collection: type,
                            );
                            //clear text for next entry
                            Provider.of<AppData>(context).newDataInput = '';
                            //pop the window
                            Navigator.pop(context);
                          },
                          onChange: (input) {
                            Provider.of<AppData>(context).newDataInput = input;
                          },
                          cancelText: 'Cancel',
                          hintText: null);
                    },
                  );
                },
                onChange: (input) {
                  Provider.of<AppData>(context).newDataInput = input;
                },
                cancelText: 'Cancel',
                hintText: null);
          },
        );
      },
      buttonColor: AppTextColor.white,
      textColor: AppTextColor.black,
      icon: icon,
    );
  }
}
