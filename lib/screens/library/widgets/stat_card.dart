import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class StatCard extends StatelessWidget {
  final String cardLabel;
  final String cardValue;
  StatCard({this.cardLabel, this.cardValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      constraints: BoxConstraints(maxWidth: double.infinity),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                cardValue != null ? cardValue.toString() : '0',
                style: TextStyle(
                  //reduce the font size as the value length increases
                  fontSize: 0.7 *
                      ((cardValue.length >= 4)
                          ? AppTextSize.gigantic * 3 / cardValue.length
                          : AppTextSize.gigantic) *
                      MediaQuery.of(context).size.width,
                  fontWeight: FontWeight.w300,
                  color: kGreenDark,
//              shadows: kShadowText,
                ),
              ),
            ),
          ),
          Container(
            height: 1.0,
            width: 60.0 * MediaQuery.of(context).size.width * kScaleFactor,
            color: kGreenMedium,
          ),
          SizedBox(height: 10.0),
          Text(
            cardLabel,
            style: TextStyle(
              color: Colors.black87,
              fontSize:
                  AppTextSize.small * MediaQuery.of(context).size.width * 0.9,
            ),
          ),
        ],
      ),
    );
  }
}
