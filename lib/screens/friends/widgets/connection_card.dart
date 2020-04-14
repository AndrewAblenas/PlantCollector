import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/chat/chat.dart';
import 'package:plant_collector/screens/friends/widgets/card_template.dart';
import 'package:plant_collector/screens/library/library.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';

class ConnectionCard extends StatelessWidget {
  final UserData user;
  final bool isRequest;
  ConnectionCard({@required this.user, @required this.isRequest});
  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    bool recentUpdate =
        (AppData.isRecentUpdate(lastUpdate: user.lastPlantUpdate) ||
            AppData.isRecentUpdate(lastUpdate: user.lastPlantAdd));

    //*****SET WIDGET VISIBILITY END*****//

    return GestureDetector(
      onTap: () {
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
      child: CardTemplate(
        user: user,
        buttonRow: <Widget>[
          SizedBox(
              width: AppTextSize.medium * MediaQuery.of(context).size.width),
          (recentUpdate == true)
              ? Icon(
                  Icons.bubble_chart,
                  size: AppTextSize.large * MediaQuery.of(context).size.width,
                  color: kGreenMedium,
                )
              : SizedBox(),
          Container(
//          width: 40 * MediaQuery.of(context).size.width * kScaleFactor,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ChatScreen(
                      friend: user,
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.chat,
                size: AppTextSize.large * MediaQuery.of(context).size.width,
                color: kGreenMedium,
              ),
            ),
          ),
        ],
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogConfirm(
                title: 'Remove Contact',
                text:
                    'Are you sure you would like to remove this contact?  You will no longer be able to chat or view each other\'s Libraries.',
                buttonText: 'Remove',
                hideCancel: false,
                onPressed: () {
                  Provider.of<CloudDB>(context)
                      .removeConnection(connectionID: user.id);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}
