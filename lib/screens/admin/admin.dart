import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/screens/library/widgets/plant_tile.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/button_add.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/section_header.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      implyLeading: false,
      screenTitle: '! Admin !',
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0 * MediaQuery.of(context).size.width * kScaleFactor,
          vertical: 0.0,
        ),
        child: ListView(
          primary: true,
          children: <Widget>[
            SizedBox(
              height: 10.0 * MediaQuery.of(context).size.width * kScaleFactor,
            ),
            ButtonAdd(
                buttonText: 'Run Admin Function',
                onPress: () {
//                  CloudDB.repackImageData(
//                      ref: Provider.of<CloudStore>(context).getStorageRef());
                }),
            SizedBox(
              height: 10.0 * MediaQuery.of(context).size.width * kScaleFactor,
            ),
            //show PlantData stream
            StreamProvider<List<PlantData>>.value(
              value: CloudDB.streamReportedPlants(),
              child: Consumer<List<PlantData>>(
                builder: (context, snap, _) {
                  if (snap == null) {
                    return SizedBox();
                  } else {
                    bool noDocuments = (snap.length == 0);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SectionHeader(title: 'Reported Plants'),
                        SizedBox(
                          height: 10.0,
                        ),
                        ContainerWrapper(
                          marginVertical: 0.0,
                          color: Colors.red,
                          child: noDocuments
                              ? Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(
                                    10.0,
                                  ),
                                  child: Text(
                                    'Nothing Reported 😊',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: AppTextSize.large *
                                          MediaQuery.of(context).size.width,
                                      color: AppTextColor.white,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: EdgeInsets.all(
                                    5.0,
                                  ),
                                  scrollDirection: Axis.vertical,
                                  itemCount: snap.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.all(1.0),
                                      child: PlantTile(
                                        connectionLibrary: true,
                                        communityView: true,
                                        collectionID: null,
                                        plant: snap[index],
                                        possibleParents: null,
                                      ),
                                    );
                                  }),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 10.0 * MediaQuery.of(context).size.width * kScaleFactor,
            ),
          ],
        ),
      ),
    );
  }
}
