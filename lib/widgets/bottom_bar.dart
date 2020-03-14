import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:provider/provider.dart';

//BOTTOM NAVIGATION BAR
class BottomBar extends StatelessWidget {
  final int selectionNumber;
  BottomBar({@required this.selectionNumber});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0 * MediaQuery.of(context).size.width * kScaleFactor,
      color: kGreenDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BottomTab(
            symbol: Icon(
              Icons.settings,
              color: AppTextColor.white,
              size: AppTextSize.huge * MediaQuery.of(context).size.width,
            ),
            navigate: () {
              Navigator.pushNamed(context, 'settings');
            },
            tabSelected: selectionNumber,
            tabNumber: 1,
          ),
          BottomTab(
            symbol: Icon(
              Icons.people,
              color: AppTextColor.white,
              size: AppTextSize.huge * MediaQuery.of(context).size.width,
            ),
            navigate: () {
              Navigator.pushNamed(context, 'connections');
            },
            tabSelected: selectionNumber,
            tabNumber: 2,
          ),
          BottomTab(
            symbol: Padding(
              padding: EdgeInsets.all(
                  5.0 * MediaQuery.of(context).size.width * kScaleFactor),
              child: Image(
                image: AssetImage('assets/images/app_icon_white_128.png'),
                height: AppTextSize.medium * MediaQuery.of(context).size.width,
              ),
            ),
            navigate: null,
            tabSelected: selectionNumber,
            tabNumber: 3,
          ),
          BottomTab(
            symbol: Icon(
              Icons.search,
              color: AppTextColor.white,
              size: AppTextSize.huge * MediaQuery.of(context).size.width,
            ),
            navigate: () {
              Provider.of<AppData>(context).setNewDataInput('');
              Navigator.pushNamed(context, 'search');
            },
            tabSelected: selectionNumber,
            tabNumber: 4,
          ),
          BottomTab(
            symbol: Icon(
              Icons.blur_circular,
              color: AppTextColor.white,
              size: AppTextSize.huge * MediaQuery.of(context).size.width,
            ),
            navigate: () {
              Navigator.pushNamed(context, 'community');
            },
            tabSelected: selectionNumber,
            tabNumber: 5,
          ),
        ],
      ),
    );
  }
}

//TAB
class BottomTab extends StatelessWidget {
  final Function navigate;
  final Widget symbol;
  final int tabSelected;
  final int tabNumber;
  BottomTab({
    @required this.symbol,
    @required this.navigate,
    this.tabSelected,
    @required this.tabNumber,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          //only navigate if user clicks on a tab that isn't currently selected
          if (tabSelected != tabNumber) {
            //don't pop context when leaving Library (tab 3), just navigate
            if (tabSelected == 3) {
              navigate();
              //when navigating to Library from any page, pop to get back
            } else if (tabNumber == 3) {
              Navigator.pop(context);
            } else {
              //otherwise pop the window and open the next
              Navigator.pop(context);
              navigate();
            }
          }
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
