import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/models/data_types/message_data.dart';

class MessagePhoto extends StatelessWidget {
  final MessageData message;
  MessagePhoto({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: CachedNetworkImage(
        imageUrl: message.media,
        fit: BoxFit.fitWidth,
      ),
      onPressed: () {},
    );
  }
}
