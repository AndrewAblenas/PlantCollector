import 'package:flutter/material.dart';
import 'package:plant_collector/widgets/get_image.dart';
import 'package:plant_collector/formats/colors.dart';

class AddPhoto extends StatelessWidget {
  final String plantID;
  final int plantCreationDate;
  final bool largeWidget;
  AddPhoto({
    @required this.plantID,
    @required this.plantCreationDate,
    @required this.largeWidget,
  });

  @override
  Widget build(BuildContext context) {
    double widgetScale = largeWidget ? 1.0 : 0.3;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: largeWidget ? 2.0 : 0.0),
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.94,
        decoration: largeWidget
            ? BoxDecoration(
                gradient: kGradientGreenVerticalDarkMed,
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
                gradient: kGradientGreenVerticalDarkMed,
              ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GetImage(
                imageFromCamera: true,
                plantCreationDate: plantCreationDate,
                largeWidget: largeWidget,
                widgetScale: widgetScale,
                plantID: plantID),
            GetImage(
                imageFromCamera: false,
                plantCreationDate: plantCreationDate,
                largeWidget: largeWidget,
                widgetScale: widgetScale,
                plantID: plantID),
          ],
        ),
      ),
    );
  }
}
