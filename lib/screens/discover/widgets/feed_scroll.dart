import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_types/simple_button.dart';
import 'package:provider/provider.dart';

class FeedScroll extends StatelessWidget {
  final List<SimpleButton> items;
  FeedScroll({
    @required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 0.15 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: kBackgroundGradientMidReversed,
      ),
      child: Consumer<int>(builder: (context, selectedFeed, _) {
        //initialize
        List<Widget> widgets = [];
        int sequence = 0;

        for (SimpleButton button in items) {
          sequence++;

          widgets.add(
            FeedTile(
              icon: button.icon,
              onPress: button.onPress,
              type: button.type,
              index: sequence,
              selected: selectedFeed,
              queryField: button.queryField,
            ),
          );
        }

        //display as row for now
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widgets,
        );

        //if more buttons are added in the future
//        return GridView.count(
//          crossAxisCount: 1,
//          shrinkWrap: true,
//          primary: false,
//          scrollDirection: Axis.horizontal,
//          children: widgets,
//        );
      }),
    );
  }
}

class FeedTile extends StatelessWidget {
  final IconData icon;
  final Function onPress;
  final int index;
  final int selected;
  final Type type;
  final String queryField;
//  final bool isActive;
  FeedTile({
    @required this.icon,
    @required this.onPress,
    @required this.index,
    @required this.selected,
    @required this.type,
    @required this.queryField,
//    @required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onPress();
          //this sets number and type
          Provider.of<AppData>(context).setCustomFeedSelected(
            selectedNumber: index,
            selectedType: type,
            selectedQueryField: queryField,
          );
        },
        child: Container(
          padding: EdgeInsets.all(0.01 * MediaQuery.of(context).size.width),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: (index == selected)
                  ? kBackgroundGradientSolidLight
                  : kBackgroundGradientReversed,
            ),
            child: Padding(
              padding: EdgeInsets.all(0.02 * MediaQuery.of(context).size.width),
              child: Icon(
                icon,
                color: AppTextColor.white,
                size:
                    1.2 * AppTextSize.large * MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
