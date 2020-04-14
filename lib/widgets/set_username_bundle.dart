import 'package:flutter/material.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';

class SetUsernameBundle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DialogConfirm(
      title: 'Set Unique Username',
      text:
          'Would you like to set an unique username so friends can easily find you?  ',
      buttonText: 'YES',
      hideCancel: false,
      onCancel: () {
        //update the value with map
        CloudDB.updateDocumentL1(
            collection: DBFolder.users,
            document: Provider.of<AppData>(context).currentUserInfo.id,
            data: {
              UserKeys.uniquePublicID: 'not set',
            });
      },
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return DialogScreenInput(
                  title:
                      'Please set a unique Username.  Only use lowercase characters, numbers, periods, and underscores.  \n'
                      '(a-z) (0-9) (._)',
                  acceptText: 'Submit',
                  acceptOnPress: () async {
                    //get the input
                    String input = Provider.of<AppData>(context)
                        .newDataInput
                        .toLowerCase();

                    //validate input
                    if (AppData.validateUsernameLength(input) == true &&
                        AppData.validateUsernameContents(input) == true) {
                      //search for user name and provide popup
                      List<UserData> results =
                          await CloudDB.userSearchExact(input: input);

                      //check for matches
                      if (results.length > 0) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DialogConfirm(
                                title: 'Already in Use',
                                text:
                                    'This Username is already in use, please try another.  ',
                                buttonText: 'Try Again',
                                hideCancel: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                            });
                      } else {
                        //update the value with map
                        CloudDB.updateDocumentL1(
                            collection: DBFolder.users,
                            document: Provider.of<AppData>(context)
                                .currentUserInfo
                                .id,
                            data: {
                              UserKeys.uniquePublicID: input,
                            });
                        //pop input dialog
                        Navigator.pop(context);
                        //pop first dialog
                        Navigator.pop(context);
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DialogConfirm(
                              title: 'Incorrect Format',
                              text:
                                  'Make sure your username is 3-20 characters in length and contains only '
                                  'lower case letters, numbers, periods, and underscores.  ',
                              buttonText: 'Try Again',
                              hideCancel: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            );
                          });
                    }
                  },
                  onChange: (input) {
                    Provider.of<AppData>(context).newDataInput = input;
                  },
                  cancelText: 'Cancel',
                  hintText: null);
            });
      },
    );
  }
}
