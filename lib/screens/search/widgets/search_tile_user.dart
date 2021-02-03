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
    return UserTile(
      //friend user
      user: user,
      buttonRow: Consumer<UserData>(
        builder: (context, UserData currentUser, _) {
          //check to make sure not null
          if (currentUser == null || user == null) {
            return SizedBox();
          } else {
            //perform checks
            bool sameUser = (user.id == currentUser.id);
            bool alreadyFriends = (currentUser.friends.contains(user.id));
            bool requestSent = (currentUser.requestsSent.contains(user.id));
//            bool recentUpdate =
//                (AppData.isRecentUpdate(lastUpdate: user.lastPlantUpdate) ||
//                    AppData.isRecentUpdate(lastUpdate: user.lastPlantAdd));
            return Row(
              children: <Widget>[
//                (recentUpdate == true)
//                    ? Padding(
//                        padding: EdgeInsets.only(right: 2.0),
//                        child: Icon(
//                          Icons.bubble_chart,
//                          size: AppTextSize.large *
//                              MediaQuery.of(context).size.width,
//                          color: kGreenMedium,
//                        ),
//                      )
//                    : SizedBox(),
                (sameUser == false && alreadyFriends == false)
                    ? GestureDetector(
                        onTap: () {
                          //PRE CHECKS
                          //determine if user data saved
                          bool userData =
                              (Provider.of<AppData>(context, listen: false)
                                      .currentUserInfo !=
                                  null);
                          //determine if user name set
                          bool userNameSet =
                              (Provider.of<AppData>(context, listen: false)
                                          .currentUserInfo
                                          .name !=
                                      null &&
                                  Provider.of<AppData>(context, listen: false)
                                          .currentUserInfo
                                          .name !=
                                      '');
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
                                        Provider.of<CloudDB>(context,
                                                listen: false)
                                            .updateUserDocument(
                                          data: AppData.updatePairFull(
                                              key: UserKeys.name,
                                              value: Provider.of<AppData>(
                                                      context,
                                                      listen: false)
                                                  .newDataInput),
                                        );
                                        //pop the context
                                        Navigator.pop(context);
                                      },
                                      onChange: (input) {
                                        Provider.of<AppData>(context,
                                                listen: false)
                                            .newDataInput = input;
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
                            String buttonText = 'YES';

                            title = (requestSent == false)
                                ? 'Send Friend Request'
                                : 'Resend Request';
                            dialogText = (requestSent == false)
                                ? 'Send a friend request?  If accepted, you will be able to share Libraries and chat.'
                                : 'Try sending again?';

                            //show a dialog to provide feedback
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogConfirm(
                                  hideCancel: false,
                                  title: title,
                                  text: dialogText,
                                  buttonText: buttonText,
                                  onPressed: () {
                                    //if all good send the request to friend
                                    Provider.of<CloudDB>(context, listen: false)
                                        .sendConnectionRequest(
                                            connectionID: user.id,
                                            connectionTokens:
                                                user.devicePushTokens);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: (requestSent == true)
                                ? kBackgroundGradientSolidGrey
                                : kGradientGreenVerticalDarkMed,
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
                              (requestSent == true) ? 'SENT' : 'ADD',
                              style: TextStyle(
                                color: AppTextColor.white,
                                fontWeight: AppTextWeight.heavy,
                                fontSize: AppTextSize.medium *
                                    MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            );
          }
        },
      ),
    );
  }
}
