import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/constants.dart';

class MessageTemplate extends StatelessWidget {
  final Map message;
  final MainAxisAlignment alignment;
  final Color textColor;
  final Color color;
  MessageTemplate(
      {@required this.message,
      @required this.alignment,
      @required this.textColor,
      @required this.color});
  @override
  Widget build(BuildContext context) {
    String date = formatDate(
        DateTime.fromMillisecondsSinceEpoch(message[kMessageTime]).toLocal(),
        [M, ' ', d, ', ', HH, ':', nn]);
    return Container(
      child: Row(
        mainAxisAlignment: alignment,
        children: <Widget>[
          SizedBox(
            width: 10.0,
          ),
          Container(
            padding: EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              right: 8.0,
              bottom: 5.0,
            ),
            margin: EdgeInsets.only(
              bottom: 3.0,
            ),
            constraints: BoxConstraints(
              maxWidth: 0.75 * MediaQuery.of(context).size.width,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  6.0,
                ),
              ),
              boxShadow: kShadowBox,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  message[kMessageText],
                  style: TextStyle(
                    fontSize:
                        AppTextSize.small * MediaQuery.of(context).size.width,
                    fontWeight: AppTextWeight.heavy,
                    color: textColor,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize:
                        AppTextSize.tiny * MediaQuery.of(context).size.width,
                    fontWeight: AppTextWeight.medium,
                    color: AppTextColor.medium,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
    );
  }
}
