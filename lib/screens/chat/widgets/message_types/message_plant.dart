import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/message_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/plant/plant.dart';
import 'package:provider/provider.dart';

class MessagePlant extends StatelessWidget {
  final MessageData message;
  final Color textColor;
  final bool connectionLibrary;
  MessagePlant({
    @required this.message,
    @required this.textColor,
    @required this.connectionLibrary,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Provider.of<CloudDB>(context).connectionUserFolder = message.sender;
        if (message.media != null || message.media != '') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlantScreen(
                  connectionLibrary: connectionLibrary,
                  communityView: true,
                  plantID: message.media,
                  forwardingCollectionID: null),
            ),
          );
        }
      },
      child: StreamProvider<DocumentSnapshot>.value(
        value: Provider.of<CloudDB>(context)
            .streamPlant(plantID: message.media, userID: message.sender),
        child: Consumer<DocumentSnapshot>(
          builder: (context, DocumentSnapshot plantSnap, _) {
            if (plantSnap == null) {
              return SizedBox(
                height:
                    120.0 * MediaQuery.of(context).size.width * kScaleFactor,
              );
            } else if (plantSnap.data == null) {
              return Text(
                'Nothing to display!'
                '\n\nThis plant profile could not be found. It may have been deleted.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:
                      AppTextSize.message * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.medium,
                  color: AppTextColor.light,
                ),
              );
            } else {
              return Column(
                children: <Widget>[
                  Container(
                    width: 120.0 *
                        MediaQuery.of(context).size.width *
                        kScaleFactor,
                    child: plantSnap[PlantKeys.thumbnail] != null
                        ? CachedNetworkImage(
                            imageUrl: plantSnap[PlantKeys.thumbnail],
                            fit: BoxFit.fitWidth,
                          )
                        : Image.asset(
                            'assets/images/default.png',
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    plantSnap[PlantKeys.name],
                    style: TextStyle(
                      fontSize: AppTextSize.message *
                          MediaQuery.of(context).size.width,
                      fontWeight: AppTextWeight.medium,
                      color: textColor,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
