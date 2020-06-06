import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:plant_collector/widgets/updates_row.dart';

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
    //*****SET WIDGET VISIBILITY START*****//

//    bool recentUpdate =
//        (AppData.isRecentUpdate(lastUpdate: user.lastPlantUpdate) ||
//            AppData.isRecentUpdate(lastUpdate: user.lastPlantAdd));

    String recentPlantAddText =
        AppData.lastPlantAdd(lastAdd: user.lastPlantAdd);
    bool recentPlantAdd = (recentPlantAddText.length != 0);

    String recentPlantUpdateText =
        AppData.lastPlantUpdate(lastUpdate: user.lastPlantUpdate);
    bool recentPlantUpdate = (recentPlantUpdateText.length != 0);

    //*****SET WIDGET VISIBILITY END*****//

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
              radius: 30.0 * MediaQuery.of(context).size.width * kScaleFactor,
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
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: 3.0,
                  vertical: 4.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            (user != null && user.name != null)
                                ? user.name
                                : '',
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: AppTextSize.large *
                                  MediaQuery.of(context).size.width,
                              fontWeight: AppTextWeight.medium,
                              color: AppTextColor.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //show recent new plants
                    (recentPlantAdd == true)
                        ? UpdatesRow(
                            text: recentPlantAddText,
                            textSize: AppTextSize.small,
                            icon: Icons.add_circle_outline,
                          )
                        : SizedBox(),
                    //show recent plant updates
                    (recentPlantUpdate == true)
                        ? UpdatesRow(
                            text: recentPlantUpdateText,
                            textSize: AppTextSize.tiny,
                            icon: Icons.bubble_chart,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
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
