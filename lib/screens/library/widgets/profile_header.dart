import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_input.dart';
import 'package:plant_collector/screens/library/widgets/stat_card.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  final bool connectionLibrary;
  ProfileHeader({@required this.connectionLibrary});
  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentSnapshot>(
      builder: (context, data, _) {
        if (data != null && data.data != null) {
          //use to check user name in not empty before friend add
          UserData user = UserData.fromMap(map: data.data);
          Provider.of<AppData>(context).currentUserInfo = user;
          return ContainerWrapper(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onLongPress: () {
                    if (connectionLibrary == false)
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DialogScreenInput(
                                title: 'Update Name',
                                acceptText: 'Update',
                                acceptOnPress: () {
                                  //update user document with map
                                  Provider.of<CloudDB>(context)
                                      .updateUserDocument(
                                    data: CloudDB.updatePairFull(
                                        key: UserKeys.name,
                                        value: Provider.of<AppData>(context)
                                            .newDataInput),
                                  );
                                  //pop context
                                  Navigator.pop(context);
                                },
                                onChange: (input) {
                                  Provider.of<AppData>(context).newDataInput =
                                      input;
                                },
                                cancelText: 'Cancel',
                                hintText: null);
                          });
                  },
                  child: SectionHeader(
                      title: (user.name != '') ? user.name : 'Set Name'),
                ),
                SizedBox(
                  height: 5.0,
                ),
                GestureDetector(
                  onLongPress: () async {
                    if (connectionLibrary == false)
                      //set userID for use in path generation
                      Provider.of<CloudStore>(context).setUserFolder(
                          userID: (await Provider.of<UserAuth>(context)
                                  .getCurrentUser())
                              .uid);
                    //get image from camera
                    File image = await Provider.of<CloudStore>(context)
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
                      StorageTaskSnapshot completion = await upload.onComplete;
                      //get the url string
                      String url = await Provider.of<CloudStore>(context)
                          .getDownloadURL(snapshot: completion);
                      //add image reference to plant document
                      Provider.of<CloudDB>(context).updateUserDocument(
                        data: CloudDB.updatePairFull(
                          key: UserKeys.background,
                          value: url,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: kShadowBox,
                        color: kGreenDark),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 10.0,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: user.background != ''
                              ? CachedNetworkImageProvider(
                                  user.background,
                                )
                              : AssetImage(
                                  'assets/images/default.png',
                                ),
                        ),
                      ),
                      child: GestureDetector(
                        onLongPress: () async {
                          if (connectionLibrary == false) {
                            //set userID for use in path generation
                            Provider.of<CloudStore>(context).setUserFolder(
                                userID: (await Provider.of<UserAuth>(context)
                                        .getCurrentUser())
                                    .uid);
                            //get image from camera
                            File image = await Provider.of<CloudStore>(context)
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
                              Provider.of<CloudDB>(context).updateUserDocument(
                                data: CloudDB.updatePairFull(
                                  key: UserKeys.avatar,
                                  value: url,
                                ),
                              );
                            } else {}
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(),
                            CircleAvatar(
                              radius: 80.0 *
                                  MediaQuery.of(context).size.width *
                                  kScaleFactor,
                              backgroundColor: user.avatar != ''
                                  ? kGreenDark
                                  : Color(0x00000000),
                              backgroundImage: user.avatar != ''
                                  ? CachedNetworkImageProvider(
                                      user.avatar,
                                    )
                                  : AssetImage(
                                      'assets/images/app_icon_white_512.png'),
                            ),
                            SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: StatCard(
                        cardLabel: 'Plant',
                        cardValue:
                            user.plants != 0 ? user.plants.toString() : '0',
                      ),
                    ),
                    Expanded(
                      child: StatCard(
                        cardLabel: 'Collection',
                        cardValue: user.collections != 0
                            ? user.collections.toString()
                            : '0',
                      ),
                    ),
                    Expanded(
                      child: StatCard(
                        cardLabel: 'Group',
                        cardValue:
                            user.groups != 0 ? user.groups.toString() : '0',
                      ),
                    ),
//              Expanded(
//                child: StatCard(
//                  cardLabel: 'Photo',
//                  cardValue: data.getImageCount(
//                    plants: data.plants,
//                  ),
//                ),
//              ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
