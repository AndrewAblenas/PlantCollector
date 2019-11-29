import 'package:flutter/material.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/screens/connections/widgets/card_template.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';

class RequestCard extends StatelessWidget {
  final Map connectionMap;
  RequestCard({@required this.connectionMap});
  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      connectionMap: connectionMap,
      onTapLibrary: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogConfirm(
              title: 'Add Connection',
              text: 'Are you sure you would like to add this Connection?  '
                  'Once accepted, you will be able to view each other\'s plant libraries',
              buttonText: 'ADD',
              onPressed: () {
                //TODO move to connections
                Provider.of<CloudDB>(context).acceptConnectionRequest(
                    connectionID: connectionMap[kUserID]);
                Navigator.pop(context);
              },
            );
          },
        );
      },
      onTapChat: null,
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogConfirm(
              title: 'Remove Request',
              text: 'Are you sure you would like to remove this request?',
              buttonText: 'Remove',
              onPressed: () {
                Provider.of<CloudDB>(context).removeConnectionRequest(
                    connectionID: connectionMap[kUserID]);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
