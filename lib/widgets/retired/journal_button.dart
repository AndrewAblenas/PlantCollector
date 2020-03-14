import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/widgets/container_card.dart';
import 'package:plant_collector/widgets/retired/journal/journal.dart';

class JournalButton extends StatelessWidget {
  final PlantData plant;
  JournalButton({@required this.plant});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //navigate to the journal page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalScreen(
              plant: plant,
            ),
          ),
        );
      },
      child: ContainerCard(
        color: AppTextColor.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5.0 * MediaQuery.of(context).size.width * kScaleFactor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.create,
                size: AppTextSize.large * MediaQuery.of(context).size.width,
                color: AppTextColor.black,
              ),
              SizedBox(
                width: 20.0 * MediaQuery.of(context).size.width * kScaleFactor,
              ),
              Text(
                'Plant Journal',
                style: TextStyle(
                  color: AppTextColor.black,
                  fontSize:
                      AppTextSize.huge * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.medium,
//                shadows: kShadowText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
