import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/data_types/communication_data.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';

class Announcements extends StatelessWidget {
  final String title;
  final Color color;
  Announcements({@required this.title, this.color = kGreenDark});
  @override
  Widget build(BuildContext context) {
    return Consumer<List<CommunicationData>>(
      builder: (context, List future, _) {
        //make sure future is not null
        if (future != null && future.length > 0) {
          List<Widget> widgets = [];
          for (CommunicationData message in future) {
            if (message.visible == true) {
              Widget article = AnnouncementArticle(message: message);
              widgets.add(article);
            }
          }
          //return the widget, only if more than 1 header
          if (widgets.length > 0) {
            return ExpandableNotifier(
              initialExpanded: false,
              child: Container(
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
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widgets,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        } else {
          return SizedBox();
        }
      },
    );
  }
}

//widget for each individual announcement
class AnnouncementArticle extends StatelessWidget {
  AnnouncementArticle({
    @required this.message,
  });

  final CommunicationData message;

  @override
  Widget build(BuildContext context) {
    return TileWhite(
      bottomPadding: 0,
      child: Padding(
        padding: EdgeInsets.all(
          5.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  message.subject,
                  style: TextStyle(
                    color: AppTextColor.black,
                    fontWeight: AppTextWeight.medium,
                    fontSize:
                        AppTextSize.medium * MediaQuery.of(context).size.width,
                  ),
                ),
                UIBuilders.communicationDataIcon(
                    type: message.type,
                    size:
                        AppTextSize.large * MediaQuery.of(context).size.width),
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
                fontSize: AppTextSize.small * MediaQuery.of(context).size.width,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
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
      bottomPadding: 0,
      topPadding: 0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 4,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:
                      AppTextSize.huge * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.medium,
                  color: AppTextColor.dark,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ExpandableButton(
                child: CircleAvatar(
                  radius:
                      16.0 * MediaQuery.of(context).size.width * kScaleFactor,
                  backgroundColor: kGreenLight,
                  child: Icon(
                    (expanded == true)
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size:
                        30.0 * MediaQuery.of(context).size.width * kScaleFactor,
                    color: AppTextColor.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
