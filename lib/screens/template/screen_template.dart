import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/formats/colors.dart';

class ScreenTemplate extends StatelessWidget {
  final String screenTitle;
  final Widget body;
  final Widget bottomBar;
  final bool implyLeading;
  final backgroundColor;
  ScreenTemplate({
    @required this.screenTitle,
    @required this.body,
    this.bottomBar,
    this.implyLeading = true,
    this.backgroundColor = kGreenLight,
  });
  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    //App title size
    double fontSize =
        0.8 * AppBarFormatting.fontSize * MediaQuery.of(context).size.width;

    //*****SET WIDGET VISIBILITY END*****//

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kGreenDark,
        centerTitle: true,
        elevation: 20.0,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            (implyLeading == false)
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: fontSize,
                    ),
                  ),
            Text(
              screenTitle,
              style: TextStyle(
                color: AppBarFormatting.color,
                fontWeight: AppBarFormatting.fontWeight,
                fontSize: fontSize,
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
      body: body != null ? body : SizedBox(),
      bottomNavigationBar: bottomBar ?? SizedBox(),
    );
  }
}
