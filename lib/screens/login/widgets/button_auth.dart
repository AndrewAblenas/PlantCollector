import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

//authentication button
class ButtonAuth extends StatelessWidget {
  //constructor
  ButtonAuth({
    @required this.text,
    @required this.onPress,
    this.showImage,
    this.textSize = AppTextSize.huge,
  });
  final String text;
  final double textSize;
  final Function onPress;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 50.0,
        ),

        //gesture detector
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              gradient: kGradientGreenVerticalDarkMed,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  5.0,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 30.0,
              ),
              child: Row(
                children: <Widget>[
                  //leading image if desired
                  (showImage == false)
                      ? SizedBox()
                      : Image(
                          image: AssetImage(
                              'assets/images/app_icon_white_512.png'),
                          height: AppTextSize.huge *
                              MediaQuery.of(context).size.width,
                        ),

                  //button text
                  Text(
                    ' $text',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textSize * MediaQuery.of(context).size.width,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: onPress,
        ),
        SizedBox(
          width: 50.0,
        ),
      ],
    );
  }
}
