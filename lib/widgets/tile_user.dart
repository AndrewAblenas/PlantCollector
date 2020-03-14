import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';

//SEARCH TILE
class UserTile extends StatelessWidget {
  final UserData user;
  final Widget buttonRow;
  UserTile({@required this.user, @required this.buttonRow});
  @override
  Widget build(BuildContext context) {
    return ContainerWrapper(
      marginVertical: 1.0,
      color: AppTextColor.white,
      child: Padding(
        padding: EdgeInsets.all(0.03 * MediaQuery.of(context).size.width),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //Nickname
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius:
                      25.0 * MediaQuery.of(context).size.width * kScaleFactor,
                  backgroundColor: AppTextColor.white,
                  backgroundImage:
                      (user != null && user.avatar != null && user.avatar != '')
                          ? CachedNetworkImageProvider(user.avatar)
                          : AssetImage(
                              'assets/images/default.png',
                            ),
                ),
                SizedBox(
                  width: AppTextSize.tiny * MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  width: 0.5 * MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: AppTextSize.medium *
                                MediaQuery.of(context).size.width,
                            child: UIBuilders.getBadge(
                                userTotalPlants: user.plants),
                          ),
                          Text(
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
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
                buttonRow,
              ],
            ),
            SizedBox(
              height: AppTextSize.tiny * MediaQuery.of(context).size.width,
            ),
            SizedBox(
              width: 0.88 * MediaQuery.of(context).size.width,
              child: Text(
                user != null ? user.about : '',
                softWrap: true,
                style: TextStyle(
                  color: AppTextColor.black,
                  fontWeight: AppTextWeight.medium,
                  fontSize:
                      AppTextSize.small * MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
