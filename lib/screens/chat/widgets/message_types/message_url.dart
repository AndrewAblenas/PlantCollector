import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_types/message_data.dart';
import 'package:plant_collector/models/message.dart';

class MessageUrl extends StatelessWidget {
  final MessageData message;
  final Color textColor;
  final TextAlign alignment;
  MessageUrl(
      {@required this.message,
      @required this.textColor,
      @required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTextSize.large * MediaQuery.of(context).size.width,
      child: FlatButton(
        onPressed: () {
          Message.launchURL(url: message.media);
        },
        child: Text(
          message.media,
          textAlign: alignment,
          style: TextStyle(
            fontSize: AppTextSize.message * MediaQuery.of(context).size.width,
            fontWeight: AppTextWeight.medium,
            color: textColor,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
