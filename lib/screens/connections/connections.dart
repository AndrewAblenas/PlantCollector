import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/screens/connections/widgets/connection_card.dart';
import 'package:plant_collector/screens/connections/widgets/request_card.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/dialogs/dialog_input.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ConnectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      screenTitle: 'Connections',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            SizedBox(
              height: 10.0,
            ),
            ButtonAdd(
              buttonColor: kGreenDark,
              buttonText: 'Add Friend',
              dialog: DialogInput(
                  title: 'Add Friend',
                  text:
                      'Input your friend\'s email address.  If they aren\'t already signed up we\'ll send them an invitation email.',
                  onChangeInput: (value) {
                    Provider.of<AppData>(context).newDataInput = value;
                  },
                  onPressedSubmit: () async {
                    String friendID = await Provider.of<CloudDB>(context)
                        .getUserFromEmail(
                            userEmail:
                                Provider.of<AppData>(context).newDataInput);
                    print(friendID);
                    Navigator.pop(context);
                    if (friendID != null) {
                      Provider.of<CloudDB>(context)
                          .sendConnectionRequest(connectionID: friendID);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogConfirm(
                            title: 'Request Sent',
                            text:
                                'A request has been sent.  You will be able to share collections once it is accepted.',
                            buttonText: 'OK',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogConfirm(
                            title: 'Send Invite?',
                            text:
                                'No user was found with this email address.  Would you like to send an invite to download?',
                            buttonText: 'Invite',
                            onPressed: () {
                              //TODO when ready link to download app
                              Share.share(
                                  'I\'m using Plant Collector to keep a record of my plants and share my collection with friends.'
                                  '\n\n Check it out here: <download link>');
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }
                  },
                  onPressedCancel: null),
              onPress: () {},
            ),
//        Consumer<QuerySnapshot>(
//          builder: (context, QuerySnapshot connectionsSnap, _) {
//            if (connectionsSnap != null) {
//              return ContainerWrapper(
//                child: Column(
//                  children: <Widget>[
//                    //TODO builder function for connections in UIBuilders
//                    ConnectionCard(connectionMap: null),
//                  ],
//                ),
//              );
//            }
//          },
//        ),
            StreamProvider<QuerySnapshot>.value(
              value: Provider.of<CloudDB>(context).streamRequests(),
              child: Consumer<QuerySnapshot>(
                builder: (context, QuerySnapshot requestSnap, _) {
                  if (requestSnap != null && requestSnap.documents.length > 0) {
                    List<Widget> requestList = [];
                    for (DocumentSnapshot request in requestSnap.documents) {
                      requestList.add(RequestCard(connectionMap: request.data));
                    }
                    return ContainerWrapper(
                      child: Column(
                        children: <Widget>[
                          SectionHeader(
                            title: 'Requests',
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: requestList,
                          )
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            StreamProvider<QuerySnapshot>.value(
              value: Provider.of<CloudDB>(context).streamConnections(),
              child: Consumer<QuerySnapshot>(
                builder: (context, QuerySnapshot connectionsSnap, _) {
                  if (connectionsSnap != null &&
                      connectionsSnap.documents != null) {
                    List<Widget> connectionList = [];
                    for (DocumentSnapshot connection
                        in connectionsSnap.documents) {
                      connectionList.add(
                        FutureProvider<Map>.value(
                          value: Provider.of<CloudDB>(context)
                              .getConnectionProfile(
                                  connectionID: connection[kUserID]),
                          child: Consumer<Map>(
                            builder: (context, Map connectionMap, _) {
                              return ConnectionCard(
                                  connectionMap: connectionMap);
                            },
                          ),
                        ),
                      );
                    }
                    return ContainerWrapper(
                      child: Column(
                        children: <Widget>[
                          SectionHeader(
                            title: 'Connections',
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: connectionList,
                            childAspectRatio: 1.5,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
