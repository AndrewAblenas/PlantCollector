import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_types/communication_data.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';

class Announcements extends StatelessWidget {
  final String title;
  final Color color;
  Announcements({
    @required this.title,
    this.color = kGreenDark,
  });
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: true,
      child: ContainerWrapper(
        color: color,
        marginVertical: 0.0,
        child: Expandable(
          collapsed: AnnouncementsHeader(
            title: title,
            expanded: false,
          ),
          expanded: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnnouncementsHeader(title: title, expanded: true),
              Container(
                child: Consumer<List<CommunicationData>>(
                    builder: (context, List future, _) {
                  //make sure future is not null
                  if (future != null && future.length > 0) {
                    List<Widget> widgets = [];
                    for (CommunicationData message in future) {
                      if (message.visible == true) {
                        Widget article = TileWhite(
                          bottomPadding: 5.0,
                          child: Padding(
                            padding: EdgeInsets.all(
                              5.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      message.subject,
                                      style: TextStyle(
                                        color: AppTextColor.black,
                                        fontWeight: AppTextWeight.medium,
                                        fontSize: AppTextSize.medium *
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                    message.icon,
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Container(
                                    height: 1.0,
                                    color: kGreenDark,
                                  ),
                                ),
                                Text(
                                  message.text,
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
                          ),
                        );
                        widgets.add(article);
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
                }),
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
  final String title;
  AnnouncementsHeader({
    @required this.expanded,
    @required this.title,
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
              title,
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
