import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/account/widgets/settings_card.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_collector/formats/text.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenLight,
      appBar: AppBar(
        backgroundColor: kGreenDark,
        centerTitle: true,
        title: Text(
          'Account',
          style: kAppBarTitle,
        ),
      ),
      body: StreamProvider<UserData>.value(
        value: CloudDB.streamUserData(
            userID: Provider.of<CloudDB>(context).currentUserFolder),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 3.0),
            ContainerWrapper(
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
                              Provider.of<CloudDB>(context).updateUserDocument(
                                data: CloudDB.updatePairFull(
                                    key: UserKeys.name,
                                    value: Provider.of<AppData>(context)
                                        .newDataInput),
                              );
                              Navigator.pop(context);
                            },
                            cardLabel: 'Name',
                            cardText: user.name,
                            dialogText: 'Please update your user name.',
                          ),
                          SettingsCard(
                            onPress: null,
                            onSubmit: () {
                              Provider.of<CloudDB>(context).updateUserDocument(
                                data: CloudDB.updatePairFull(
                                    key: UserKeys.region,
                                    value: Provider.of<AppData>(context)
                                        .newDataInput),
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
                              Provider.of<CloudDB>(context).updateUserDocument(
                                data: CloudDB.updatePairFull(
                                    key: UserKeys.about,
                                    value: Provider.of<AppData>(context)
                                        .newDataInput),
                              );
                              Navigator.pop(context);
                            },
                            cardLabel: 'About',
                            cardText: user.about,
                            dialogText:
                                'Tell others a bit about your plant collection.',
                          ),
                          SettingsCard(
                            onSubmit: null,
                            allowDialog: false,
                            onPress: () async {
                              //set userID for use in path generation
                              Provider.of<CloudStore>(context).setUserFolder(
                                  userID: (await Provider.of<UserAuth>(context)
                                          .getCurrentUser())
                                      .uid);
                              //get image from camera
                              File image =
                                  await Provider.of<CloudStore>(context)
                                      .getCameraImage(fromCamera: false);
                              //check to make sure the user didn't back out
                              if (image != null) {
                                //upload image
                                StorageUploadTask upload =
                                    Provider.of<CloudStore>(context)
                                        .uploadToUserSettingsTask(
                                            imageFile: image,
                                            imageName: UserKeys.avatar);
                                //make sure upload completes
                                StorageTaskSnapshot completion =
                                    await upload.onComplete;
                                //get the url string
                                String url =
                                    await Provider.of<CloudStore>(context)
                                        .getDownloadURL(snapshot: completion);
                                //add image reference to plant document
                                Provider.of<CloudDB>(context)
                                    .updateUserDocument(
                                  data: CloudDB.updatePairFull(
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
                          SettingsCard(
                            onSubmit: null,
                            allowDialog: false,
                            onPress: () async {
                              //set userID for use in path generation
                              Provider.of<CloudStore>(context).setUserFolder(
                                  userID: (await Provider.of<UserAuth>(context)
                                          .getCurrentUser())
                                      .uid);
                              //get image from camera
                              File image =
                                  await Provider.of<CloudStore>(context)
                                      .getCameraImage(fromCamera: false);
                              //check to make sure the user didn't back out
                              if (image != null) {
                                //upload image
                                StorageUploadTask upload =
                                    Provider.of<CloudStore>(context)
                                        .uploadToUserSettingsTask(
                                            imageFile: image,
                                            imageName: UserKeys.background);
                                //make sure upload completes
                                StorageTaskSnapshot completion =
                                    await upload.onComplete;
                                //get the url string
                                String url =
                                    await Provider.of<CloudStore>(context)
                                        .getDownloadURL(snapshot: completion);
                                //add image reference to user document
                                Provider.of<CloudDB>(context)
                                    .updateUserDocument(
                                  data: CloudDB.updatePairFull(
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
                          SettingsCard(
                              confirmDialog: true,
                              onSubmit: () {
                                //update settings
                                Provider.of<CloudDB>(context)
                                    .updateUserDocument(
                                  data: CloudDB.updatePairFull(
                                    key: UserKeys.expandGroup,
                                    value: (user.expandGroup == false),
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              onPress: null,
                              cardLabel: 'Collapse Groups by Default',
                              dialogText:
                                  'Change default settings for app launch?',
                              cardText:
                                  user.expandGroup == true ? 'No' : 'Yes'),
                          SettingsCard(
                              confirmDialog: true,
                              onSubmit: () {
                                //update settings
                                Provider.of<CloudDB>(context)
                                    .updateUserDocument(
                                  data: CloudDB.updatePairFull(
                                    key: UserKeys.expandCollection,
                                    value: (user.expandCollection == false),
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              onPress: null,
                              cardLabel: 'Collapse Collections by Default',
                              dialogText:
                                  'Change default settings for app launch?',
                              cardText:
                                  user.expandCollection == true ? 'No' : 'Yes'),
                        ],
                      );
                    }
                  }),
                  //TODO could swap this to StreamProvider
                  StreamBuilder<FirebaseUser>(
                    stream: Provider.of<UserAuth>(context)
                        .getCurrentUser()
                        .asStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<FirebaseUser> snapshot) {
                      if (!snapshot.hasData) return new Text('...');
                      return Column(
                        children: <Widget>[
                          SettingsCard(
                            onPress: null,
                            onSubmit: () {
                              //update the google authentication email profile
                              Provider.of<UserAuth>(context).userUpdateEmail(
                                  email: Provider.of<AppData>(context)
                                      .newDataInput);
                              //update the user document email
                              Provider.of<CloudDB>(context).updateUserDocument(
                                data: CloudDB.updatePairFull(
                                  key: UserKeys.email,
                                  value: Provider.of<AppData>(context)
                                      .newDataInput,
                                ),
                              );
                            },
                            cardLabel: 'Email',
                            cardText: snapshot.data.email,
                            dialogText:
                                'Please provide an updated email address.',
                          ),
                          SettingsCard(
                            onPress: null,
                            onSubmit: () {
                              bool result = Provider.of<UserAuth>(context)
                                  .validatePassword(
                                      Provider.of<AppData>(context)
                                          .newDataInput);
                              if (result == true) {
                                Provider.of<UserAuth>(context)
                                    .userUpdatePassword(
                                        password: Provider.of<AppData>(context)
                                            .newDataInput);
                                Navigator.pop(context);
                              } else {}
                            },
                            cardLabel: 'Password',
                            cardText: 'Update Password',
                            dialogText:
                                'Your password must have a capital letter, small letter, number, and special character. You will not be able to update otherwise.',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
