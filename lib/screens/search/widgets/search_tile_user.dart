import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/widgets/tile_user.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';

//SEARCH TILE
class SearchUserTile extends StatelessWidget {
  final UserData user;
  SearchUserTile({@required this.user});
  @override
  Widget build(BuildContext context) {
    //check if already friends
    bool alreadyFriends =
        Provider.of<AppData>(context).currentUserInfo.friends.contains(user.id);
    //check if user is same as current user
    bool sameUser =
        (Provider.of<AppData>(context).currentUserInfo.id == user.id);
    return UserTile(
      user: user,
      buttonRow: (alreadyFriends || sameUser)
          ? SizedBox()
          : GestureDetector(
              onTap: () {
                //PRE CHECKS
                //determine if user data saved
                bool userData =
                    (Provider.of<AppData>(context).currentUserInfo != null);
                //determine if user name set
                bool userNameSet = (Provider.of<AppData>(context)
                            .currentUserInfo
                            .name !=
                        null &&
                    Provider.of<AppData>(context).currentUserInfo.name != '');
                //first, direct user to create a user name
                if (userData && !userNameSet) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogScreenInput(
                            title:
                                'Before adding a friend, first create your user name.',
                            acceptText: 'Add',
                            acceptOnPress: () {
                              //update user document to add user name
                              Provider.of<CloudDB>(context).updateUserDocument(
                                data: CloudDB.updatePairFull(
                                    key: UserKeys.name,
                                    value: Provider.of<AppData>(context)
                                        .newDataInput),
                              );
                              //pop the context
                              Navigator.pop(context);
                            },
                            onChange: (input) {
                              Provider.of<AppData>(context).newDataInput =
                                  input;
                            },
                            cancelText: 'Cancel',
                            hintText: null);
                      });
                }
                //AFTER CHECKS ADD FRIEND
                if (userData && userNameSet) {
                  //determine dialog text
                  String title;
                  String dialogText;
                  String buttonText = 'OK';
                  Function onPressed = () {};
                  //if all good send the request to friend
                  Provider.of<CloudDB>(context)
                      .sendConnectionRequest(connectionID: user.id);
                  title = 'Request Sent';
                  dialogText =
                      'A request has been sent.  You will be able to share collections once it is accepted.';

                  //show a dialog to provide feedback
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogConfirm(
                        hideCancel: true,
                        title: title,
                        text: dialogText,
                        buttonText: buttonText,
                        onPressed: () {
                          onPressed();
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: kBackgroundGradientMid,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      5.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
                  child: Text(
                    'ADD',
                    style: TextStyle(
                      color: AppTextColor.white,
                      fontWeight: AppTextWeight.heavy,
                      fontSize: AppTextSize.medium *
                          MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
