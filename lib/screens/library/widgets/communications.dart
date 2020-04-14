import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/communication_data.dart';
import 'package:plant_collector/screens/library/widgets/Announcements.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';

class Communications extends StatelessWidget {
  final String title;
  final Color color;
  Communications({
    @required this.title,
    this.color = kGreenDark,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<List<CommunicationData>>(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        UIBuilders.communicationDataIcon(
                            type: message.type,
                            size: AppTextSize.large *
                                MediaQuery.of(context).size.width),
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
                    GestureDetector(
                      onTap: () {
                        Map<String, dynamic> data = {
                          CommunicationKeys.read: true,
                          CommunicationKeys.visible: false
                        };
                        CloudDB.updateDocument(
                            reference: message.reference, data: data);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 15.0,
                        ),
                        decoration: BoxDecoration(
                          gradient: kGradientGreenVerticalDarkMed,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              5.0,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          child: Text(
                            'UNDERSTOOD',
                            style: TextStyle(
                              color: AppTextColor.white,
                              fontWeight: AppTextWeight.heavy,
                              fontSize: AppTextSize.medium *
                                  MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
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
        if (widgets.length > 0) {
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
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widgets,
                        ),
                      ),
                    ),
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
    });
  }
}
