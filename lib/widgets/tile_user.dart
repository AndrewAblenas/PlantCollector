import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/library/library.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:provider/provider.dart';

//SEARCH TILE
class UserTile extends StatelessWidget {
  final UserData user;
  final Widget buttonRow;
  UserTile({@required this.user, @required this.buttonRow});
  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    //enable dialogs only if library belongs to the current user
    bool showUniquePublicID = (user != null &&
        user.uniquePublicID != '' &&
        user.uniquePublicID != 'not set');

    //*****SET WIDGET VISIBILITY END*****//

    return GestureDetector(
      onTap: () {
        //Only navigate if the private library is false
        if (user.privateLibrary == false ||
            //or if it's true but the other user friend list contains the current user
            (user.privateLibrary == true &&
                user.friends.contains(
                    Provider.of<AppData>(context).currentUserInfo.id)))
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LibraryScreen(
                userID: user.id,
                connectionLibrary: true,
              ),
            ),
          );
      },
      child: ContainerWrapper(
        marginVertical: 1.0,
        color: AppTextColor.white,
        child: Padding(
          padding: EdgeInsets.all(0.03 * MediaQuery.of(context).size.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //Nickname
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius:
                        25.0 * MediaQuery.of(context).size.width * kScaleFactor,
                    backgroundColor: AppTextColor.white,
                    backgroundImage: (user != null &&
                            user.avatar != null &&
                            user.avatar != '')
                        ? CachedNetworkImageProvider(user.avatar)
                        : AssetImage(
                            'assets/images/default.png',
                          ),
                  ),
                  SizedBox(
                    width: AppTextSize.tiny * MediaQuery.of(context).size.width,
                  ),
                  Expanded(
//                  width: 0.5 * MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: AppTextSize.large *
                                  MediaQuery.of(context).size.width,
                              child: UIBuilders.getBadge(
                                  userTotalPlants: user.plants),
                            ),
                            Expanded(
                              child: Text(
                                user != null ? user.name : '',
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  color: AppTextColor.black,
                                  fontWeight: AppTextWeight.medium,
                                  fontSize: AppTextSize.large *
                                      MediaQuery.of(context).size.width,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          user != null ? user.region : '',
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: AppTextColor.black,
                            fontWeight: AppTextWeight.medium,
                            fontSize: AppTextSize.tiny *
                                MediaQuery.of(context).size.width,
                          ),
                        ),
                        (showUniquePublicID == true)
                            ? Text(
                                '( ${user.uniquePublicID} )',
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  color: AppTextColor.black,
                                  fontWeight: AppTextWeight.medium,
                                  fontSize: AppTextSize.tiny *
                                      MediaQuery.of(context).size.width,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  buttonRow,
                ],
              ),
              SizedBox(
                height: 0.01 * MediaQuery.of(context).size.width,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
//                    width: 0.88 * MediaQuery.of(context).size.width,
                    child: Text(
                      user != null ? user.about : '',
                      softWrap: true,
                      style: TextStyle(
                        color: AppTextColor.black,
                        fontWeight: AppTextWeight.medium,
                        fontSize: AppTextSize.small *
                            MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  //show a private library icon
                  (user.privateLibrary == true)
                      ? Icon(
                          Icons.lock_outline,
                          size: AppTextSize.tiny *
                              MediaQuery.of(context).size.width,
                          color: AppTextColor.light,
                        )
                      : SizedBox(),
                ],
              ),
              //ADMIN AND CREATOR VISIBLE ONLY
//            (Provider.of<AppData>(context).currentUserInfo.type ==
//                        UserTypes.admin ||
//                    Provider.of<AppData>(context).currentUserInfo.type ==
//                        UserTypes.creator)
//                ? AdminButton(
//                    label: 'Report ${user.id}',
//                    onPress: () {
//                      Provider.of<CloudDB>(context)
//                          .reportUser(userID: user.id, issue: 'Admin Report');
//                    })
//                : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
