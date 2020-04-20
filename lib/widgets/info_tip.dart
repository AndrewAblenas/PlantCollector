import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';

class InfoTip extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function onPress;
  final bool showAlways;
  InfoTip(
      {@required this.text,
      this.icon,
      @required this.onPress,
      this.showAlways});

  @override
  Widget build(BuildContext context) {
    //if show tips is true display tip otherwise empty widget
    return (Provider.of<AppData>(context).showTips == true ||
            showAlways == true)
        ? TileWhite(
            child: FlatButton(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Icon(
                        //if no icon provided use default
                        icon != null ? icon : Icons.help_outline,
                        color: kGreenDark,
                        size: AppTextSize.gigantic *
                            MediaQuery.of(context).size.width,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        color: AppTextColor.dark,
                        fontWeight: AppTextWeight.medium,
                        fontSize: 1.1 *
                            AppTextSize.small *
                            MediaQuery.of(context).size.width,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                onPress();
              },
            ),
          )
        : SizedBox();
  }
}
