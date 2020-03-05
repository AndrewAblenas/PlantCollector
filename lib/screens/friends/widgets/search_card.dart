import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/screens/friends/widgets/card_template.dart';

class ConnectionCard extends StatelessWidget {
  final UserData user;
  final bool isRequest;
  ConnectionCard({@required this.user, @required this.isRequest});
  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      user: user,
      buttonRow: <Widget>[
        Container(
//          width: 40 * MediaQuery.of(context).size.width * kScaleFactor,
          child: GestureDetector(
            onTap: () {
              //TODO send request
              //copy over from friend page, add friend button from email
            },
            child: Icon(
              Icons.add_box,
              size: AppTextSize.large * MediaQuery.of(context).size.width,
              color: kGreenDark,
            ),
          ),
        ),
      ],
      onLongPress: () {
        //do nothing on long press
      },
    );
  }
}
