import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class MessageTemplate extends StatelessWidget {
  final Widget content;
  final MainAxisAlignment alignment;
  final Color color;
  MessageTemplate(
      {@required this.content, @required this.alignment, @required this.color});
  @override
  Widget build(BuildContext context) {
    double radius = 15.0;
    double bottomRight = (alignment == MainAxisAlignment.end) ? 0.0 : radius;
    double topLeft = (alignment == MainAxisAlignment.start) ? 0.0 : radius;
    return Container(
      child: Row(
        mainAxisAlignment: alignment,
        children: <Widget>[
          SizedBox(
            width: 10.0,
          ),
          Container(
            padding: EdgeInsets.only(
              top: 10.0,
              left: 10.0,
              right: 10.0,
              bottom: 5.0,
            ),
            margin: EdgeInsets.only(
              bottom: 7.0 * MediaQuery.of(context).size.width * kScaleFactor,
              top: 0.0,
            ),
            constraints: BoxConstraints(
              maxWidth: 0.75 * MediaQuery.of(context).size.width,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  topLeft,
                ),
                topRight: Radius.circular(
                  radius,
                ),
                bottomLeft: Radius.circular(
                  radius,
                ),
                bottomRight: Radius.circular(
                  bottomRight,
                ),
              ),
              boxShadow: kShadowBox,
            ),
            child: content,
          ),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
    );
  }
}
