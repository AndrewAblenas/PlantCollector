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
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      constraints: BoxConstraints(maxWidth: double.infinity),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: kShadowBox,
        color: kBackgroundLight,
      ),
      child: Column(
        children: <Widget>[
          Text(
            cardValue != null ? cardValue.toString() : '0',
            style: TextStyle(
              fontSize:
                  AppTextSize.gigantic * MediaQuery.of(context).size.width,
              fontWeight: FontWeight.w300,
              color: kGreenDark,
//              shadows: kShadowText,
            ),
          ),
          Container(
            height: 1.0,
            width: 60.0 * MediaQuery.of(context).size.width * kTextScale,
            color: kGreenMedium,
          ),
          const SizedBox(height: 10.0),
          Text(
            cardValue == '1' ? '$cardLabel' : '${cardLabel}s',
            style: TextStyle(
              color: Colors.black87,
              fontSize: AppTextSize.tiny * MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
