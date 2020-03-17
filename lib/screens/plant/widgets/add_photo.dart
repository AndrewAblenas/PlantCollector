import 'package:flutter/material.dart';
import 'package:plant_collector/widgets/get_image_camera.dart';
import 'package:plant_collector/widgets/get_image_gallery.dart';
import 'package:plant_collector/formats/colors.dart';

class AddPhoto extends StatelessWidget {
  final String plantID;
  final bool largeWidget;
  AddPhoto({
    @required this.plantID,
    @required this.largeWidget,
  });

  @override
  Widget build(BuildContext context) {
    double widgetScale = largeWidget ? 1.0 : 0.3;
    return Container(
      margin: EdgeInsets.only(bottom: largeWidget ? 10.0 : 0.0),
      padding: EdgeInsets.all(largeWidget ? 4.0 : 0.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.94,
        decoration: largeWidget
            ? BoxDecoration(
                gradient: kBackgroundGradientMid,
                boxShadow: [
                  BoxShadow(
                    color: kShadowColor,
                    blurRadius: 8.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: -5.0,
                  ),
                ],
              )
            : BoxDecoration(
                gradient: kBackgroundGradientMid,
              ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GetImageCamera(
                largeWidget: largeWidget,
                widgetScale: widgetScale,
                plantID: plantID),
            GetImageGallery(
                largeWidget: largeWidget,
                widgetScale: widgetScale,
                plantID: plantID),
          ],
        ),
      ),
    );
  }
}
