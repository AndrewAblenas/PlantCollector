import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/widgets/tile_white.dart';

class ReferenceScreen extends StatelessWidget {
  final String title;
  final String text;
  ReferenceScreen({@required this.title, @required this.text});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenLight,
      appBar: AppBar(
        backgroundColor: kGreenDark,
        centerTitle: true,
        title: Text(
          'Reference',
          style: kAppBarTitle,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextSection(
                title: title,
                text: text,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  final String title;
  final String text;
  TextSection({@required this.title, @required this.text});

  @override
  Widget build(BuildContext context) {
    return TileWhite(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: kHeaderText,
            ),
          ),
          Container(
            height: 1.0,
            width: 250.0,
            color: kGreenDark,
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text,
              style: kBodyText,
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
