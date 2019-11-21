import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:plant_collector/models/constants.dart';
import 'package:plant_collector/screens/library/widgets/stat_card.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';

class StatCardRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: StatCard(
            cardLabel: 'Plant',
            cardValue: Provider.of<CloudDB>(context).plants != null
                ? Provider.of<CloudDB>(context).plants.length.toString()
                : '0',
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: StatCard(
            cardLabel: 'Collection',
            cardValue: Provider.of<CloudDB>(context).collections != null
                ? Provider.of<CloudDB>(context).collections.length.toString()
                : '0',
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: StatCard(
            cardLabel: 'Photo',
            cardValue: Provider.of<CloudDB>(context).getImageCount(
              plants: Provider.of<CloudDB>(context).plants,
            ),
          ),
        ),
      ],
    );
  }
}
