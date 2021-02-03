import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/screens/library/widgets/plant_tile.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:provider/provider.dart';

class QueryScreen extends StatelessWidget {
  final Map queryMap;
  QueryScreen({@required this.queryMap});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PlantData>>.value(
      value: CloudDB.streamUserPlantQuery(queryMap: queryMap),
      child: ScreenTemplate(
        screenTitle: 'Results',
        body: ListView(
          children: <Widget>[
            Consumer<List<PlantData>>(
              builder: (context, results, _) {
                if (results == null || results.length < 1) {
                  return Container(
                    padding: EdgeInsets.all(
                      20.0,
                    ),
                    width: double.infinity,
                    child: Text(
                      'No results were found.\nPlease try another search.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppTextSize.medium *
                            MediaQuery.of(context).size.width,
                        fontWeight: AppTextWeight.medium,
                      ),
                    ),
                  );
                } else {
                  List<Widget> widgets = [];
                  for (PlantData plant in results) {
                    widgets.add(
                      Container(
                        child: PlantTile(
                          connectionLibrary: true,
                          communityView: true,
                          collectionID: null,
                          plant: plant,
                          possibleParents: null,
                        ),
                      ),
                    );
                  }
                  return Container(
                    color: kGreenDark,
                    child: GridView.count(
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0,
                      crossAxisCount: 3,
                      primary: false,
                      shrinkWrap: true,
                      children: widgets,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
