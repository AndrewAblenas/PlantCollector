import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/widgets/container_card.dart';

class CardTemplate extends StatelessWidget {
  final Map connectionMap;
  final List<Widget> buttonRow;
  final Function onLongPress;
  CardTemplate(
      {@required this.connectionMap,
      @required this.buttonRow,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Row(
                  children: buttonRow,
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
