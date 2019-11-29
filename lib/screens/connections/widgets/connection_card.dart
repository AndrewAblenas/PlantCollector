import 'package:flutter/material.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/screens/chat/chat.dart';
import 'package:plant_collector/screens/connections/widgets/card_template.dart';
import 'package:plant_collector/screens/library/library.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';

class ConnectionCard extends StatelessWidget {
  final Map connectionMap;
  ConnectionCard({@required this.connectionMap});
  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      connectionMap: connectionMap,
      onTapLibrary: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LibraryScreen(
              userID: connectionMap[kUserID],
              connectionLibrary: true,
            ),
          ),
        );
      },
      onTapChat: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ChatScreen(
              connectionMap: connectionMap,
            ),
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogConfirm(
              title: 'Remove Contact',
              text: 'Are you sure you would like to remove this contact?',
              buttonText: 'Remove',
              onPressed: () {
                Provider.of<CloudDB>(context)
                    .removeConnection(connectionID: connectionMap[kUserID]);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
