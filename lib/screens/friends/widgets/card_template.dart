import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/widgets/tile_white.dart';

class CardTemplate extends StatelessWidget {
  final UserData user;
  final List<Widget> buttonRow;
  final Function onLongPress;
  CardTemplate(
      {@required this.user,
      @required this.buttonRow,
      @required this.onLongPress});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onLongPress();
      },
      child: TileWhite(
        bottomPadding: 0.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width: AppTextSize.tiny * MediaQuery.of(context).size.width),
            CircleAvatar(
              radius: 25.0 * MediaQuery.of(context).size.width * kScaleFactor,
              backgroundColor: AppTextColor.white,
              backgroundImage:
                  (user != null && user.avatar != null && user.avatar != '')
                      ? CachedNetworkImageProvider(user.avatar)
                      : AssetImage(
                          'assets/images/default.png',
                        ),
            ),
            SizedBox(
                width: AppTextSize.tiny * MediaQuery.of(context).size.width),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: 3.0,
                vertical: 4.0,
              ),
              child: Text(
                (user != null && user.name != null) ? user.name : '',
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  fontSize:
                      AppTextSize.large * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.medium,
                  color: AppTextColor.black,
                ),
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: buttonRow,
            ),
            SizedBox(
                width: AppTextSize.tiny * MediaQuery.of(context).size.width),
          ],
        ),
      ),
    );
  }
}
