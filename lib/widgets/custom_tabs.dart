import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

//CUSTOM TAB
class CustomTab extends StatelessWidget {
  final Function onPress;
  final Widget symbol;
  final int tabSelected;
  final int tabNumber;
  CustomTab({
    @required this.symbol,
    @required this.onPress,
    this.tabSelected,
    @required this.tabNumber,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onPress();
        },
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: tabSelected == tabNumber ? kGreenMedium : kGreenDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                  5.0 * MediaQuery.of(context).size.width * kScaleFactor),
              topRight: Radius.circular(
                  5.0 * MediaQuery.of(context).size.width * kScaleFactor),
            ),
          ),
          child: symbol,
        ),
      ),
    );
  }
}
