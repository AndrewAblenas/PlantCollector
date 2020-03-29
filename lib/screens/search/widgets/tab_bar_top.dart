import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_types/simple_button.dart';
import 'package:provider/provider.dart';

class TabBarTop extends StatelessWidget {
  final List<SimpleButton> items;
  TabBarTop({
    @required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 0.1 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
//        gradient: kBackgroundGradientMidReversed,
        color: kGreenDark,
      ),
      child: Consumer<int>(builder: (context, selectedTab, _) {
        //if selectedTab is null set a value
        if (selectedTab == null) {
          selectedTab = 1;
        }

        //initialize
        List<Widget> widgets = [];
        int sequence = 0;

        for (SimpleButton button in items) {
          sequence++;

          widgets.add(
            TabBarTab(
              label: button.label,
              onPress: button.onPress,
              index: sequence,
              selected: selectedTab,
            ),
          );
        }

        //display as row for now
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widgets,
        );
      }),
    );
  }
}

class TabBarTab extends StatelessWidget {
  final String label;
  final Function onPress;
  final int index;
  final int selected;

  TabBarTab({
    @required this.label,
    @required this.onPress,
    @required this.index,
    @required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onPress();
          //this sets number and type
          Provider.of<AppData>(context).setTabBarTopSelected(tabNumber: index);
        },
        child: Container(
          alignment: Alignment.center,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: (index == selected)
                ? kBackgroundGradientReversed
                : kBackgroundGradientSolidDark,
          ),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize:
                    AppTextSize.medium * MediaQuery.of(context).size.width,
                fontWeight: AppTextWeight.medium,
                color: AppTextColor.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
