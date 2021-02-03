import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/screens/library/widgets/plant_tile.dart';
import 'package:plant_collector/screens/plant/plant.dart';
import 'package:plant_collector/widgets/tile_white.dart';
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
        Provider.of<AppData>(context, listen: false).forwardingPlantID =
            plant.id;
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
      child: TileWhite(
        child: Padding(
          padding: EdgeInsets.all(0.02 * MediaQuery.of(context).size.width),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 0.15 * MediaQuery.of(context).size.width,
                height: 0.15 * MediaQuery.of(context).size.width,
                child: plant.thumbnail != ''
                    ? CachedNetworkImage(
                        imageUrl: plant.thumbnail,
                        fit: BoxFit.cover,
                        // fit: BoxFit.cover,
                        errorWidget: (context, error, _) {
                          return PlantTileDefaultImage(iconScale: 0.5);
                        })
                    : PlantTileDefaultImage(iconScale: 0.5),
              ),
              SizedBox(width: 5.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    SizedBox(
                      height: 0.01 * MediaQuery.of(context).size.width,
                    ),
                    //Genus, Species, Variety
                    Wrap(
                      children: UIBuilders.buildPlantName(substrings: [
                        [PlantKeys.genus, plant.genus],
                        [PlantKeys.species, plant.species],
                        [PlantKeys.hybrid, plant.hybrid],
                        [PlantKeys.variety, plant.variety],
                      ], context: context),
                    ),
//                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ),
    );
  }
}
