import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_types/message_data.dart';

class MessageText extends StatelessWidget {
  final MessageData message;
  final Color textColor;
  final TextAlign alignment;
  MessageText({
    @required this.message,
    @required this.textColor,
    @required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    String date = formatDate(
        DateTime.fromMillisecondsSinceEpoch(message.time).toLocal(),
        [M, ' ', d, ', ', HH, ':', nn]);
    return Column(
      children: <Widget>[
        Text(
          message.text,
          textAlign: alignment,
          style: TextStyle(
            fontSize: AppTextSize.message * MediaQuery.of(context).size.width,
            fontWeight: AppTextWeight.medium,
            color: textColor,
          ),
        ),
        Text(
          date,
          style: TextStyle(
            fontSize: 8.0 * kScaleFactor * MediaQuery.of(context).size.width,
            fontWeight: AppTextWeight.medium,
            color: AppTextColor.medium,
          ),
        ),
      ],
    );
  }
}
