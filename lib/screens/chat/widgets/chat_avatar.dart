import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class ChatAvatar extends StatelessWidget {
  final String avatarLink;
  ChatAvatar({@required this.avatarLink});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30.0,
      backgroundColor: kGreenMedium,
      child: Container(
        padding: EdgeInsets.all(
          3.0,
        ),
        child: CircleAvatar(
          radius: 30.0,
          backgroundColor: AppTextColor.white,
          backgroundImage: avatarLink != null
              ? CachedNetworkImageProvider(avatarLink)
              : AssetImage(
                  'assets/images/default.png',
                ),
        ),
      ),
    );
  }
}
