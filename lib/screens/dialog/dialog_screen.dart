import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class DialogScreen extends StatelessWidget {
  final String title;
  final List<Widget> children;
  DialogScreen({@required this.title, @required this.children});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kGreenDark, kGreenLight],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: ListView(
          primary: true,
          shrinkWrap: true,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                    height: 50.0 *
                        MediaQuery.of(context).size.width *
                        kScaleFactor),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          AppTextSize.huge * MediaQuery.of(context).size.width),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: AppTextSize.huge *
                            MediaQuery.of(context).size.width,
                        fontWeight: AppTextWeight.medium,
                        color: kGreenDark),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                      AppTextSize.huge * MediaQuery.of(context).size.width),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
