import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/message_data.dart';

class MessageSticker extends StatelessWidget {
  final MessageData message;
  MessageSticker({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(message.media),
      fit: BoxFit.fitWidth,
    );
  }
}
