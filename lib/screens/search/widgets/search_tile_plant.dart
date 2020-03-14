import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/plant/plant.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:provider/provider.dart';

//SEARCH TILE
class SearchPlantTile extends StatelessWidget {
  final String collectionID;
  final PlantData plant;
  SearchPlantTile({@required this.plant, @required this.collectionID});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<AppData>(context).forwardingPlantID = plant.id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantScreen(
              connectionLibrary: false,
              communityView: false,
              plantID: plant.id,
              forwardingCollectionID: collectionID,
            ),
          ),
        );
      },
      child: ContainerWrapper(
        marginVertical: 0.0,
        color: AppTextColor.white,
        child: Padding(
          padding: EdgeInsets.all(0.03 * MediaQuery.of(context).size.width),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //Nickname
                  SizedBox(
                    width: 0.8 * MediaQuery.of(context).size.width,
                    child: Text(
                      plant != null ? plant.name : '',
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: AppTextColor.black,
                        fontWeight: AppTextWeight.medium,
                        fontSize: AppTextSize.large *
                            MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  //Genus, Species, Variety
                  SizedBox(
                    width: 0.8 * MediaQuery.of(context).size.width,
                    child: Text(
                      plant != null
                          ? '${plant.genus} ${plant.species} ${plant.variety}'
                          : '',
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: AppTextColor.black,
                        fontWeight: AppTextWeight.medium,
                        fontSize: AppTextSize.tiny *
                            MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}
