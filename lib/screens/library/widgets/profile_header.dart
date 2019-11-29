import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/screens/library/widgets/stat_card.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/dialogs/dialog_input.dart';
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
          return ContainerWrapper(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onLongPress: () {
                    connectionLibrary == false
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogInput(
                                title: 'Set Name',
                                text:
                                    'Please create a user name.  This will be visible to other users.',
                                onPressedCancel: null,
                                onChangeInput: (value) {
                                  Provider.of<CloudDB>(context).newDataInput =
                                      value;
                                },
                                onPressedSubmit: () {
                                  Provider.of<CloudDB>(context)
                                      .updateUserDocument(
                                          data: Provider.of<CloudDB>(context)
                                              .updatePairInput(key: kUserName),
                                          userID: data.data[kUserID]);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          )
                        : null;
                  },
                  child: SectionHeader(
                      title: (data.data[kUserName] != null ||
                              !data.data.containsKey(kUserName))
                          ? data.data[kUserName]
                          : 'Name'),
                ),
                SizedBox(
                  height: 5.0,
                ),
                GestureDetector(
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
                                    imageName: kUserBackground);
                        //make sure upload completes
                        StorageTaskSnapshot completion =
                            await upload.onComplete;
                        //get the url string
                        String url = await Provider.of<CloudStore>(context)
                            .getDownloadURL(snapshot: completion);
                        //add image reference to plant document
                        Provider.of<CloudDB>(context).updateUserDocument(
                            data: Provider.of<CloudDB>(context).updatePairFull(
                              key: kUserBackground,
                              value: url,
                            ),
                            userID: data.data[kUserID]);
                      }
                    } else {}
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    margin: EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: kShadowBox,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: data.data[kUserBackground] != null
                            ? CachedNetworkImageProvider(
                                data.data[kUserBackground],
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
                                        imageName: kUserAvatar);
                            //make sure upload completes
                            StorageTaskSnapshot completion =
                                await upload.onComplete;
                            //get the url string
                            String url = await Provider.of<CloudStore>(context)
                                .getDownloadURL(snapshot: completion);
                            //add image reference to plant document
                            Provider.of<CloudDB>(context).updateUserDocument(
                                data: Provider.of<CloudDB>(context)
                                    .updatePairFull(
                                  key: kUserAvatar,
                                  value: url,
                                ),
                                userID: data.data[kUserID]);
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
                            backgroundColor: data.data[kUserAvatar] != null
                                ? kGreenDark
                                : Color(0x00000000),
                            backgroundImage: data.data[kUserAvatar] != null
                                ? CachedNetworkImageProvider(
                                    data.data[kUserAvatar],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: StatCard(
                        cardLabel: 'Plant',
                        cardValue: data.data[kUserTotalPlants] != null
                            ? data.data[kUserTotalPlants].toString()
                            : '0',
                      ),
                    ),
                    Expanded(
                      child: StatCard(
                        cardLabel: 'Collection',
                        cardValue: data.data[kUserTotalCollections] != null
                            ? data.data[kUserTotalCollections].toString()
                            : '0',
                      ),
                    ),
                    Expanded(
                      child: StatCard(
                        cardLabel: 'Group',
                        cardValue: data.data[kUserTotalGroups] != null
                            ? data.data[kUserTotalGroups].toString()
                            : '0',
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
