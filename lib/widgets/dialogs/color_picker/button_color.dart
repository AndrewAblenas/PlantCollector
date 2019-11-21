import 'package:flutter/material.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:provider/provider.dart';

class ButtonColor extends StatelessWidget {
  final Color color;
  final Function onPress;
  final String groupID;
  ButtonColor(
      {@required this.color, @required this.onPress, @required this.groupID});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      child: FlatButton(
        onPressed: () {
          List<int> colorUpload = [color.red, color.green, color.blue];
          Map data = Provider.of<CloudDB>(context)
              .updatePairFull(key: kGroupColor, value: colorUpload);
          Provider.of<CloudDB>(context).updateDocumentInCollection(
              data: data, collection: kUserGroups, documentName: groupID);
          onPress();
        },
        child: Container(
          height: 100.0,
          width: 100.0,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
            BoxShadow(
                color: Colors.black54,
                blurRadius: 4.0,
                offset: Offset(0.0, 2.0)),
          ]),
        ),
      ),
    );
  }
}
