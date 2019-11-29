import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/widgets/container_card.dart';

class CardTemplate extends StatelessWidget {
  final Map connectionMap;
  final Function onTapLibrary;
  final Function onTapChat;
  final Function onLongPress;
  CardTemplate(
      {@required this.connectionMap,
      @required this.onTapLibrary,
      @required this.onTapChat,
      @required this.onLongPress});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onLongPress();
      },
      child: ContainerCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius:
                      30.0 * MediaQuery.of(context).size.width * kScaleFactor,
                  backgroundColor: AppTextColor.white,
                  backgroundImage: (connectionMap != null &&
                          connectionMap[kUserAvatar] != null)
                      ? CachedNetworkImageProvider(connectionMap[kUserAvatar])
                      : AssetImage(
                          'assets/images/default.png',
                        ),
                ),
                Container(
                  width: AppTextSize.huge * MediaQuery.of(context).size.width,
                  child: FlatButton(
                    onPressed: () {
                      onTapLibrary();
                    },
                    child: Icon(
                      Icons.photo_library,
                      size:
                          AppTextSize.huge * MediaQuery.of(context).size.width,
                      color: AppTextColor.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: AppTextSize.medium * MediaQuery.of(context).size.width,
                ),
                Container(
                  width: AppTextSize.huge * MediaQuery.of(context).size.width,
                  child: FlatButton(
                    onPressed: () {
                      onTapChat();
                    },
                    child: Icon(
                      Icons.chat,
                      size:
                          AppTextSize.huge * MediaQuery.of(context).size.width,
                      color: AppTextColor.white,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                horizontal: 3.0,
                vertical: 8.0,
              ),
              child: Text(
                (connectionMap != null && connectionMap[kUserName] != null)
                    ? connectionMap[kUserName]
                    : '',
                overflow: TextOverflow.fade,
                softWrap: true,
                style: TextStyle(
                  fontSize:
                      AppTextSize.large * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.medium,
                  color: AppTextColor.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
