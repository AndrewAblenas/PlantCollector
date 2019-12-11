import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/chat/chat.dart';
import 'package:plant_collector/screens/connections/widgets/card_template.dart';
import 'package:plant_collector/screens/library/library.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';

class ConnectionCard extends StatelessWidget {
  final UserData user;
  ConnectionCard({@required this.user});
  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      user: user,
      buttonRow: <Widget>[
        Container(
          width: 50 * MediaQuery.of(context).size.width * kScaleFactor,
          child: FlatButton(
            onPressed: () {
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
            child: Icon(
              Icons.photo_library,
              size: AppTextSize.huge * MediaQuery.of(context).size.width,
              color: AppTextColor.white,
            ),
          ),
        ),
        SizedBox(
          width: AppTextSize.tiny * MediaQuery.of(context).size.width,
        ),
        Container(
          width: 50 * MediaQuery.of(context).size.width * kScaleFactor,
          child: FlatButton(
            onPressed: () {
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
              size: AppTextSize.huge * MediaQuery.of(context).size.width,
              color: AppTextColor.white,
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
              onPressed: () {
                Provider.of<CloudDB>(context)
                    .removeConnection(connectionID: user.id);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
