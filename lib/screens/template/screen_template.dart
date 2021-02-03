import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/formats/colors.dart';

class ScreenTemplate extends StatelessWidget {
  final String screenTitle;
  final Widget body;
  final Widget bottomBar;
  final Widget actionButton;
  final bool implyLeading;
  final backgroundColor;
  ScreenTemplate({
    @required this.screenTitle,
    @required this.body,
    this.bottomBar,
    this.actionButton = const SizedBox(),
    this.implyLeading = true,
    this.backgroundColor = kGreenDark,
  });
  @override
  Widget build(BuildContext context) {
    //*****SET WIDGET VISIBILITY START*****//

    //App title size
    double fontSize =
        0.8 * AppBarFormatting.fontSize * MediaQuery.of(context).size.width;

    //*****SET WIDGET VISIBILITY END*****//

    return Scaffold(
      floatingActionButton: actionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kGreenDark,
        centerTitle: true,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: (implyLeading == false)
                  ? SizedBox()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.arrow_back,
                          size: fontSize * 1.2,
                        ),
                      ),
                    ),
            ),
            // Text(
            //   screenTitle,
            //   style: TextStyle(
            //     color: AppBarFormatting.color,
            //     fontWeight: AppBarFormatting.fontWeight,
            //     fontSize: fontSize,
            //   ),
            // ),
            Expanded(
              flex: 3,
              child: Image.asset(
                'assets/images/PlantCollectorText1000.png',
                width: 0.5 * MediaQuery.of(context).size.width,
              ),
            ),
            Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ),
      body: body != null ? body : SizedBox(),
      //this means the bottom bar will show over the body
      extendBody: true,
      bottomNavigationBar: bottomBar ?? SizedBox(),
    );
  }
}
