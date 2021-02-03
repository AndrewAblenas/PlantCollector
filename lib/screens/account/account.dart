import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/account/widgets/settings_card.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/set_username_bundle.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_collector/formats/text.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //easy provider
    CloudDB provCloudDBFalse = Provider.of<CloudDB>(context, listen: false);
    CloudStore provCloudStoreFalse =
        Provider.of<CloudStore>(context, listen: false);
    UserAuth provUserAuthFalse = Provider.of<UserAuth>(context, listen: false);
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: false);
    //easy format
    double relativeWidth = MediaQuery.of(context).size.width;
    return ScreenTemplate(
      backgroundColor: kGreenLight,
      screenTitle: 'Account',
      body: StreamProvider<UserData>.value(
        value:
            CloudDB.streamUserData(userID: provCloudDBFalse.currentUserFolder),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: ContainerWrapper(
                marginVertical: 5.0,
                child: Column(
                  children: <Widget>[
                    Consumer<UserData>(builder: (context, UserData user, _) {
                      if (user == null) {
                        return SizedBox();
                      } else {
                        return Column(
                          children: <Widget>[
                            SettingsCard(
                              onPress: null,
                              onSubmit: () {
                                provCloudDBFalse.updateUserDocument(
                                  data: AppData.updatePairFull(
                                      key: UserKeys.name,
                                      value: provAppDataFalse.newDataInput),
                                );
                                Navigator.pop(context);
                              },
                              cardLabel: 'User Handle',
                              cardText: user.name,
                              dialogText: 'Please update your user handle.',
                            ),
                            SettingsCard(
                              onPress: null,
                              onSubmit: () {
                                provCloudDBFalse.updateUserDocument(
                                  data: AppData.updatePairFull(
                                      key: UserKeys.region,
                                      value: provAppDataFalse.newDataInput),
                                );
                                Navigator.pop(context);
                              },
                              cardLabel: 'Region',
                              cardText: user.region,
                              dialogText: 'Please add your region.',
                            ),
                            SettingsCard(
                              onPress: null,
                              onSubmit: () {
                                provCloudDBFalse.updateUserDocument(
                                  data: AppData.updatePairFull(
                                      key: UserKeys.about,
                                      value: provAppDataFalse.newDataInput),
                                );
                                Navigator.pop(context);
                              },
                              cardLabel: 'About',
                              cardText: user.about,
                              dialogText:
                                  'Tell others a bit about your plant collection.',
                            ),
                            SettingsCard(
                              onPress: null,
                              onSubmit: () {
                                provCloudDBFalse.updateUserDocument(
                                  data: AppData.updatePairFull(
                                      key: UserKeys.link,
                                      value: provAppDataFalse.newDataInput),
                                );
                                Navigator.pop(context);
                              },
                              cardLabel: 'Link',
                              cardText:
                                  (user.link != '') ? user.link : 'Tap to Add',
                              dialogText:
                                  'Add a link or website.  Double check to make sure the address is correct.',
                            ),
                            ContainerWrapper(
                              marginVertical: 5.0,
                              color: AppTextColor.white,
                              child: Container(
                                height: 0.4 * relativeWidth,
                                width: 0.4 * relativeWidth,
                                padding: EdgeInsets.all(
                                  5.0,
                                ),
                                child: (user.avatar == '')
                                    ? Image.asset('assets/images/default.png')
                                    : CachedNetworkImage(
                                        imageUrl: user.avatar,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            SettingsCard(
                              onSubmit: null,
                              allowDialog: false,
                              onPress: () async {
                                //set userID for use in path generation
                                provCloudStoreFalse.setUserFolder(
                                    userID: (await provUserAuthFalse
                                            .getCurrentUser())
                                        .uid);
                                //get image from camera
                                File image = await provCloudStoreFalse
                                    .getImageFile(fromCamera: false);
                                //check to make sure the user didn't back out
                                if (image != null) {
                                  //upload image
                                  UploadTask upload = provCloudStoreFalse
                                      .uploadToUserSettingsTask(
                                          imageFile: image,
                                          imageName: UserKeys.avatar);
                                  //make sure upload completes
                                  TaskSnapshot completion = await upload;
                                  //get the url string
                                  String url = await provCloudStoreFalse
                                      .getDownloadURL(snapshot: completion);
                                  //add image reference to plant document
                                  provCloudDBFalse.updateUserDocument(
                                    data: AppData.updatePairFull(
                                      key: UserKeys.avatar,
                                      value: url,
                                    ),
                                  );
                                }
                              },
                              cardLabel: 'Picture',
                              cardText: 'Update Picture',
                              dialogText: 'Please set your display picture.',
                            ),
                            ContainerWrapper(
                              marginVertical: 5.0,
                              color: AppTextColor.white,
                              child: Container(
                                height: 0.4 * relativeWidth,
//                              width: 0.4 * relativeWidth,
                                padding: EdgeInsets.all(
                                  5.0,
                                ),
                                child: (user.background == '')
                                    ? Image.asset('assets/images/default.png')
                                    : CachedNetworkImage(
                                        imageUrl: user.background,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            SettingsCard(
                              onSubmit: null,
                              allowDialog: false,
                              onPress: () async {
                                //set userID for use in path generation
                                provCloudStoreFalse.setUserFolder(
                                    userID: (await provUserAuthFalse
                                            .getCurrentUser())
                                        .uid);
                                //get image from camera
                                File image = await provCloudStoreFalse
                                    .getImageFile(fromCamera: false);
                                //check to make sure the user didn't back out
                                if (image != null) {
                                  //upload image
                                  UploadTask upload = provCloudStoreFalse
                                      .uploadToUserSettingsTask(
                                          imageFile: image,
                                          imageName: UserKeys.background);
                                  //make sure upload completes
                                  TaskSnapshot completion = await upload;
                                  //get the url string
                                  String url = await provCloudStoreFalse
                                      .getDownloadURL(snapshot: completion);
                                  //add image reference to user document
                                  provCloudDBFalse.updateUserDocument(
                                    data: AppData.updatePairFull(
                                      key: UserKeys.background,
                                      value: url,
                                    ),
                                  );
                                }
                              },
                              cardLabel: 'Banner',
                              cardText: 'Update Banner',
                              dialogText: 'Please set your profile banner.',
                            ),
//                            SettingsCard(
//                                confirmDialog: true,
//                                onSubmit: () {
//                                  //update settings
//                                  provCloudDBFalse
//                                      .updateUserDocument(
//                                    data: CloudDB.updatePairFull(
//                                      key: UserKeys.expandGroup,
//                                      value: (user.expandGroup == false),
//                                    ),
//                                  );
//                                  Navigator.pop(context);
//                                },
//                                onPress: null,
//                                cardLabel: 'Collapse Groups by Default',
//                                dialogText:
//                                    'Change default settings for app launch?',
//                                cardText:
//                                    user.expandGroup == true ? 'No' : 'Yes'),
                            SettingsCard(
                                confirmDialog: true,
                                onSubmit: () {
                                  //update settings
                                  provCloudDBFalse.updateUserDocument(
                                    data: AppData.updatePairFull(
                                      key: UserKeys.sortPlantsAlphabetically,
                                      value: (user.sortPlantsAlphabetically ==
                                          false),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                onPress: null,
                                cardLabel:
                                    'Display ${GlobalStrings.plants} Alphabetically',
                                dialogText:
                                    'Change this setting based on Plant nickname?',
                                cardText: user.sortPlantsAlphabetically == true
                                    ? 'Yes'
                                    : 'No'),
                            SettingsCard(
                                confirmDialog: true,
                                onSubmit: () {
                                  //update settings
                                  provCloudDBFalse.updateUserDocument(
                                    data: AppData.updatePairFull(
                                      key: UserKeys.sortAlphabetically,
                                      value: (user.sortAlphabetically == false),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                onPress: null,
                                cardLabel:
                                    'Display ${GlobalStrings.collections} Alphabetically',
                                dialogText:
                                    'Change this setting next time the app starts?  Note jumping will occur when adding or renaming a Shelf.',
                                cardText: user.sortAlphabetically == true
                                    ? 'Yes'
                                    : 'No'),
                            SettingsCard(
                                confirmDialog: true,
                                onSubmit: () {
                                  //update settings
                                  provCloudDBFalse.updateUserDocument(
                                    data: AppData.updatePairFull(
                                      key: UserKeys.expandCollection,
                                      value: (user.expandCollection == false),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                onPress: null,
                                cardLabel:
                                    'Collapse ${GlobalStrings.collections} by Default',
                                dialogText:
                                    'Change default settings for app launch?',
                                cardText: user.expandCollection == true
                                    ? 'No'
                                    : 'Yes'),
                            SettingsCard(
                                confirmDialog: true,
                                onSubmit: () {
                                  //update settings
                                  provCloudDBFalse.updateUserDocument(
                                    data: AppData.updatePairFull(
                                      key: UserKeys.showWishList,
                                      value: (user.showWishList == false),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                onPress: null,
                                cardLabel: 'Enable Wishlist Shelf',
                                dialogText:
                                    'Change default settings for app launch?',
                                cardText:
                                    user.showWishList == true ? 'Yes' : 'No'),
                            SettingsCard(
                                confirmDialog: true,
                                onSubmit: () {
                                  //update settings
                                  provCloudDBFalse.updateUserDocument(
                                    data: AppData.updatePairFull(
                                      key: UserKeys.showSellList,
                                      value: (user.showSellList == false),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                onPress: null,
                                cardLabel: 'Enable Sell Shelf',
                                dialogText:
                                    'Change default settings for app launch?',
                                cardText:
                                    user.showSellList == true ? 'Yes' : 'No'),
                            SettingsCard(
                                confirmDialog: true,
                                onSubmit: () {
                                  //update settings
                                  provCloudDBFalse.updateUserDocument(
                                    data: AppData.updatePairFull(
                                      key: UserKeys.showCompostList,
                                      value: (user.showCompostList == false),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                onPress: null,
                                cardLabel: 'Enable Compost Shelf',
                                dialogText:
                                    'Change default settings for app launch?',
                                cardText: user.showCompostList == true
                                    ? 'Yes'
                                    : 'No'),
                            SettingsCard(
                                confirmDialog: true,
                                onSubmit: () {
                                  //update settings
                                  provCloudDBFalse.updateUserDocument(
                                    data: AppData.updatePairFull(
                                      key: UserKeys.privateLibrary,
                                      value: !user.privateLibrary,
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                onPress: null,
                                cardLabel: 'Only Allow Friends to View Library',
                                dialogText:
                                    'Change Library and Discover Stream visibility settings?',
                                cardText:
                                    user.privateLibrary == true ? 'Yes' : 'No'),
                            SettingsCard(
                              disableEdit: (provAppDataFalse
                                      .currentUserInfo.uniquePublicID !=
                                  ''),
                              onSubmit: () {},
                              confirmDialog: false,
                              allowDialog: false,
                              onPress: () {
                                //if '' the value is null in the db
                                //if 'not set' the user responded on to the friend popup with no
                                if (provAppDataFalse
                                            .currentUserInfo.uniquePublicID ==
                                        '' ||
                                    provAppDataFalse
                                            .currentUserInfo.uniquePublicID ==
                                        'not set') {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SetUsernameBundle();
                                      });
                                }
                              },
                              cardLabel: 'Unique Username',
                              //if null '' then display as not set
                              cardText: (user.uniquePublicID == '')
                                  ? 'not set'
                                  : user.uniquePublicID,
                            ),
                            StreamProvider<User>.value(
                              value:
                                  provUserAuthFalse.getCurrentUser().asStream(),
                              child: Consumer<User>(
                                builder:
                                    (BuildContext context, User snapshot, _) {
                                  if (snapshot == null) {
                                    return SizedBox();
                                  } else {
                                    return Column(
                                      children: <Widget>[
                                        SettingsCard(
                                          onPress: null,
                                          acceptButtonText: 'CONFIRM',
                                          authPromptText:
                                              '${snapshot.email}\n\nConfirm Password',
                                          obscureInput: true,
                                          cardLabel: 'Email',
                                          //this should be snap.email but it won't update
                                          cardText: user.email,
                                          dialogText: 'Input your password',
                                          onSubmit: () {
                                            //need to re authenticate
                                            String password =
                                                provAppDataFalse.newDataInput;
                                            provUserAuthFalse
                                                .reauthenticateUser(
                                                    password: password)
                                                .then((value) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return DialogScreenInput(
                                                      title: 'New Email',
                                                      acceptText: 'Update',
                                                      acceptOnPress: () {
                                                        //update the google authentication email profile
                                                        String data =
                                                            provAppDataFalse
                                                                .newDataInput;
                                                        print(data);
                                                        provUserAuthFalse
                                                            .userUpdateEmail(
                                                                email: data);
                                                        //update the user document email
                                                        provCloudDBFalse
                                                            .updateUserDocument(
                                                          data: AppData
                                                              .updatePairFull(
                                                            key: UserKeys.email,
                                                            value: data,
                                                          ),
                                                        );
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      onChange: (input) {
                                                        provAppDataFalse
                                                                .newDataInput =
                                                            input;
                                                      },
                                                      cancelText: 'Cancel',
                                                      hintText: '');
                                                },
                                              );
                                            });
                                          },
                                        ),
                                        SettingsCard(
                                          onPress: null,
                                          acceptButtonText: 'CONFIRM',
                                          authPromptText:
                                              '${snapshot.email}\n\nConfirm Password',
                                          obscureInput: true,
                                          onSubmit: () {
                                            //need to re authenticate
                                            String password =
                                                provAppDataFalse.newDataInput;
                                            provUserAuthFalse
                                                .reauthenticateUser(
                                                    password: password)
                                                .then((value) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return DialogScreenInput(
                                                      title:
                                                          'Your password must have a capital letter, small letter, and special character. You will not be able to update otherwise.',
                                                      acceptText: 'Update',
                                                      acceptOnPress: () {
                                                        bool result = provUserAuthFalse
                                                            .validatePassword(
                                                                provAppDataFalse
                                                                    .newDataInput);
                                                        if (result == true) {
                                                          provUserAuthFalse
                                                              .userUpdatePassword(
                                                                  password:
                                                                      provAppDataFalse
                                                                          .newDataInput);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        } else {}
                                                      },
                                                      onChange: (input) {
                                                        provAppDataFalse
                                                                .newDataInput =
                                                            input;
                                                      },
                                                      cancelText: 'Cancel',
                                                      hintText: null);
                                                },
                                              );
                                            });
                                          },
                                          cardLabel: 'Password',
                                          cardText: 'Update',
                                          dialogText: 'Input your password',
                                        ),
//                            SettingsCard(
//                              onPress: null,
//                              onSubmit: () {
//                                bool result = provUserAuthFalse
//                                    .validatePassword(
//                                        provAppDataFalse
//                                            .newDataInput);
//                                if (result == true) {
//                                  provUserAuthFalse
//                                      .userUpdatePassword(
//                                          password:
//                                              provAppDataFalse
//                                                  .newDataInput);
//                                  Navigator.pop(context);
//                                } else {}
//                              },
//                              cardLabel: 'Password',
//                              cardText: 'Update Password',
//                              dialogText:
//                                  'Your new password must have a capital letter, small letter, special character, and be at least eight characters long.',
//                            ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
