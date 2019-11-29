import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class LoginTemplate extends StatelessWidget {
  final Widget leadingGraphic;
  final List<Widget> children;
  LoginTemplate({@required this.leadingGraphic, @required this.children});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenLight,
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30.0),
          Container(
            height: 160.0 * MediaQuery.of(context).size.width * kScaleFactor,
            width: 160.0 * MediaQuery.of(context).size.width * kScaleFactor,
            child: leadingGraphic,
          ),
          SizedBox(height: 10.0),
          Text(
            ' Plant Collector',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 45.0 * MediaQuery.of(context).size.width * kScaleFactor,
              fontWeight: AppTextWeight.medium,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.0),
          Column(
            children: children,
          )
        ],
      ),
    );
  }
}
