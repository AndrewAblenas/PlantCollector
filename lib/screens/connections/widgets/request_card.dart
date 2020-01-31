import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/connections/widgets/card_template.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:provider/provider.dart';

class RequestCard extends StatelessWidget {
  //TODO revamp and change to RequestData
  final UserData user;
  RequestCard({@required this.user});
  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      user: user,
      buttonRow: <Widget>[
        Container(
          width: 45 * MediaQuery.of(context).size.width * kScaleFactor,
          child: FlatButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogConfirm(
                    title: 'Remove Request',
                    text: 'Are you sure you would like to remove this request?',
                    buttonText: 'Remove',
                    onPressed: () {
                      Provider.of<CloudDB>(context)
                          .removeConnectionRequest(connectionID: user.id);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
            child: Icon(
              Icons.delete,
              size: AppTextSize.small * MediaQuery.of(context).size.width,
              color: AppTextColor.white,
            ),
          ),
        ),
        CircleAvatar(
          radius: 35.0 * MediaQuery.of(context).size.width * kScaleFactor,
          backgroundColor: AppTextColor.white,
          backgroundImage:
              (user != null && user.avatar != null && user.avatar != '')
                  ? CachedNetworkImageProvider(user.avatar)
                  : AssetImage(
                      'assets/images/default.png',
                    ),
        ),
        Container(
          width: 45 * MediaQuery.of(context).size.width * kScaleFactor,
          child: FlatButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogConfirm(
                    title: 'Add Connection',
                    text:
                        'Are you sure you would like to add this Connection?  '
                        'Once accepted, you will be able to view each other\'s plant libraries and chat.',
                    buttonText: 'ADD',
                    onPressed: () {
                      Provider.of<CloudDB>(context)
                          .acceptConnectionRequest(connectionID: user.id);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
            child: Icon(
              Icons.add_box,
              size: AppTextSize.small * MediaQuery.of(context).size.width,
              color: AppTextColor.white,
            ),
          ),
        ),
      ],
      onLongPress: () {
        null;
      },
    );
  }
}
