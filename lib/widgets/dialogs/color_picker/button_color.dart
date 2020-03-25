import 'package:flutter/material.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/collection_data.dart';
import 'package:provider/provider.dart';

class ButtonColor extends StatelessWidget {
  final Color color;
  final Function onPress;
  final String collectionID;
  ButtonColor(
      {@required this.color,
      @required this.onPress,
      @required this.collectionID});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      child: GestureDetector(
        onTap: () {
          List<int> colorUpload = [color.red, color.green, color.blue];
          Map data = CloudDB.updatePairFull(
              key: CollectionKeys.color, value: colorUpload);
          Provider.of<CloudDB>(context).updateDocumentInCollection(
              data: data,
              collection: DBFolder.collections,
              documentName: collectionID);
          onPress();
        },
        child: Container(
          margin: EdgeInsets.all(4.0),
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
