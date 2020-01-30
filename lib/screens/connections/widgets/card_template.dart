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
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: user.background != ''
                  ? CachedNetworkImage(
                      imageUrl: user.background, fit: BoxFit.cover)
                  : Image.asset(
                      'assets/images/default.png',
                      fit: BoxFit.cover,
                    ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    height:
                        AppTextSize.tiny * MediaQuery.of(context).size.width),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Color(0x55000000),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: buttonRow,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Color(0x55000000),
                    ),
                    child: Text(
                      (user != null && user.name != null) ? user.name : '',
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: AppTextSize.large *
                            MediaQuery.of(context).size.width,
                        fontWeight: AppTextWeight.medium,
                        color: AppTextColor.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
