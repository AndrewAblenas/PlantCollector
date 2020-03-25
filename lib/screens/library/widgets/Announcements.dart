import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';

class Announcements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: true,
      child: ContainerWrapper(
        marginVertical: 0.0,
        child: Expandable(
          collapsed: AnnouncementsHeader(
            expanded: false,
          ),
          expanded: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnnouncementsHeader(expanded: true),
              Container(
                child: Consumer<DocumentSnapshot>(
                  builder: (context, DocumentSnapshot future, _) {
                    //make sure future is not null
                    if (future != null && future.data != null) {
                      //extract the data
                      Map communication = future.data;
                      List keys = communication.keys.toList();

                      //default list
                      List<Widget> widgets = [];

                      //get the different
                      for (String key in keys) {
                        List headers = communication[key];

                        for (Map section in headers) {
                          if (section['show'] == true) {
                            Widget article = TileWhite(
                              bottomPadding: 4.0,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        section['title'],
                                        style: TextStyle(
                                          color: AppTextColor.black,
                                          fontWeight: AppTextWeight.medium,
                                          fontSize: AppTextSize.medium *
                                              MediaQuery.of(context).size.width,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                    child: Container(
                                      height: 1.0,
                                      color: kGreenDark,
                                    ),
                                  ),
                                  Text(
                                    section['text'],
                                    style: TextStyle(
                                      color: AppTextColor.black,
                                      fontWeight: AppTextWeight.medium,
                                      fontSize: AppTextSize.small *
                                          MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            );
                            widgets.add(article);
                          }
                        }
                      }

                      //return the widget, only if more than 1 header
                      if (widgets.length > 0) {
                        return Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widgets,
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnnouncementsHeader extends StatelessWidget {
  final bool expanded;
  AnnouncementsHeader({
    @required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return TileWhite(
      bottomPadding: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Announcements',
              style: TextStyle(
                fontSize: AppTextSize.huge * MediaQuery.of(context).size.width,
                fontWeight: AppTextWeight.medium,
              ),
            ),
            ExpandableButton(
              child: CircleAvatar(
                radius: 16.0 * MediaQuery.of(context).size.width * kScaleFactor,
                backgroundColor: kGreenDark,
                child: Icon(
                  (expanded == true)
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 30.0 * MediaQuery.of(context).size.width * kScaleFactor,
                  color: AppTextColor.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
