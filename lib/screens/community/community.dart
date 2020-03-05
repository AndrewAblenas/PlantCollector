import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:plant_collector/widgets/container_card.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/section_header.dart';

class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      screenTitle: GlobalStrings.community,
      bottomBar: BottomBar(selectionNumber: 5),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5.0,
        ),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            ContainerWrapper(
              child: Column(
                children: <Widget>[
                  SectionHeader(title: GlobalStrings.news),
                  ContainerCard(
                    color: AppTextColor.white,
                    child: Text('Future News List'),
                  ),
                ],
              ),
            ),
            ContainerWrapper(
              child: Column(
                children: <Widget>[
                  SectionHeader(title: GlobalStrings.events),
                  ContainerCard(
                    color: AppTextColor.white,
                    child: Text('Future Events List'),
                  ),
                ],
              ),
            ),
            ContainerWrapper(
              child: Column(
                children: <Widget>[
                  SectionHeader(title: 'Discover'),
                  ContainerCard(
                    color: AppTextColor.white,
                    child: Text('What other features may be useful?'),
                  ),
                ],
              ),
            ),
            ContainerWrapper(
              child: Column(
                children: <Widget>[
                  SectionHeader(title: 'Other Features?'),
                  ContainerCard(
                    color: AppTextColor.white,
                    child: Text(
                        'What is another useful feature that could go here?'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
