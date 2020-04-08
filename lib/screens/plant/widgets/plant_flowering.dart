import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/bloom_data.dart';
import 'package:plant_collector/models/data_types/plant_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_select.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';

class PlantFlowering extends StatelessWidget {
  final PlantData plant;
  final bool connectionLibrary;
  PlantFlowering({@required this.plant, @required this.connectionLibrary});
  @override
  Widget build(BuildContext context) {
    return TileWhite(
      bottomPadding: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 0.02 * MediaQuery.of(context).size.width),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: UIBuilders.buildFloweringWidget(
                blooms: plant.bloomSequence,
                plantID: plant.id,
                connectionLibrary: connectionLibrary),
          ),
          (connectionLibrary == false)
              ? GestureDetector(
                  onTap: () {
                    //set to default to store future data
                    Provider.of<AppData>(context).newListInput = [
                      [0, 0],
                      [0, 0],
                      [0, 0],
                      [0, 0]
                    ];
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogScreenSelect(
                            title: 'New Information',
                            items: UIBuilders.generateDateButtons(
                                map: BloomKeys.descriptors),
                            onAccept: () {
                              //get the list of inputted data
                              List data =
                                  Provider.of<AppData>(context).newListInput;

                              //get the day of year, add to list
                              List bloomEntry = [];
                              for (List entry in data) {
                                int day = AppData.getDayOfYear(
                                    month: entry[0], day: entry[1]);
                                bloomEntry.add(day);
                              }

                              //pull the days and add to a map to upload the data
                              Map<String, dynamic> bloomMap = {
                                BloomKeys.bud: bloomEntry[0],
                                BloomKeys.first: bloomEntry[1],
                                BloomKeys.last: bloomEntry[2],
                                BloomKeys.seed: bloomEntry[3]
                              };

                              //upload the data
                              Provider.of<CloudDB>(context)
                                  .updateDocumentL1Array(
                                collection: DBFolder.plants,
                                document: plant.id,
                                key: PlantKeys.bloomSequence,
                                entries: [bloomMap],
                                action: true,
                              );

                              //clear and pop
                              Provider.of<AppData>(context).newListInput = [];
                              Navigator.pop(context);
                            },
                          );
                        });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_box,
                        color: AppTextColor.whitish,
                        size: AppTextSize.medium *
                            MediaQuery.of(context).size.width,
                      ),
                      Text(
                        ' Add Sequence',
                        textAlign: TextAlign.center,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: AppTextSize.tiny *
                              MediaQuery.of(context).size.width,
                          fontWeight: AppTextWeight.heavy,
                          color: AppTextColor.light,
                        ),
                      )
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class PlantFloweringSequence extends StatelessWidget {
  final String plantID;
  final bool connectionLibrary;
  final Widget sequenceRow;
  final Map<String, dynamic> sequenceMap;
  PlantFloweringSequence({
    @required this.plantID,
    @required this.connectionLibrary,
    @required this.sequenceRow,
    @required this.sequenceMap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (connectionLibrary == false) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogConfirm(
                hideCancel: false,
                title: 'Remove Bloom Sequence',
                text: 'Are you sure you would like to remove this information?',
                onPressed: () {
                  Provider.of<CloudDB>(context).updateDocumentL1Array(
                    collection: DBFolder.plants,
                    document: plantID,
                    key: PlantKeys.bloomSequence,
                    entries: [sequenceMap],
                    action: false,
                  );

                  Navigator.pop(context);
                },
              );
            },
          );
        }
      },
      child: Padding(
        padding:
            EdgeInsets.only(bottom: 0.02 * MediaQuery.of(context).size.width),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: sequenceRow),
//            SizedBox(
//              height: 0.05 * MediaQuery.of(context).size.width,
//            ),
            (connectionLibrary == false)
                ? GestureDetector(
                    onTap: () {
                      //set to default to store future data
                      Provider.of<AppData>(context).newListInput = [
                        [
                          UIBuilders.getMonthFromDayOfYear(
                              dayOfYear: sequenceMap[BloomKeys.bud]),
                          UIBuilders.getMonthDayFromDayOfYear(
                              dayOfYear: sequenceMap[BloomKeys.bud])
                        ],
                        [
                          UIBuilders.getMonthFromDayOfYear(
                              dayOfYear: sequenceMap[BloomKeys.first]),
                          UIBuilders.getMonthDayFromDayOfYear(
                              dayOfYear: sequenceMap[BloomKeys.first])
                        ],
                        [
                          UIBuilders.getMonthFromDayOfYear(
                              dayOfYear: sequenceMap[BloomKeys.last]),
                          UIBuilders.getMonthDayFromDayOfYear(
                              dayOfYear: sequenceMap[BloomKeys.last])
                        ],
                        [
                          UIBuilders.getMonthFromDayOfYear(
                              dayOfYear: sequenceMap[BloomKeys.seed]),
                          UIBuilders.getMonthDayFromDayOfYear(
                              dayOfYear: sequenceMap[BloomKeys.seed])
                        ],
                      ];
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogScreenSelect(
                              title: 'Update',
                              items: UIBuilders.generateDateButtons(
                                  map: BloomKeys.descriptors),
                              onAccept: () {
                                //get the list of inputted data
                                List data =
                                    Provider.of<AppData>(context).newListInput;

                                //get the day of year, add to list
                                List bloomEntry = [];
                                for (List entry in data) {
                                  int day = AppData.getDayOfYear(
                                      month: entry[0], day: entry[1]);
                                  bloomEntry.add(day);
                                }

                                //pull the days and add to a map to upload the data
                                Map<String, dynamic> bloomMap = {
                                  BloomKeys.bud: bloomEntry[0],
                                  BloomKeys.first: bloomEntry[1],
                                  BloomKeys.last: bloomEntry[2],
                                  BloomKeys.seed: bloomEntry[3]
                                };

                                //upload new data
                                Provider.of<CloudDB>(context)
                                    .updateDocumentL1Array(
                                  collection: DBFolder.plants,
                                  document: plantID,
                                  key: PlantKeys.bloomSequence,
                                  entries: [bloomMap],
                                  action: true,
                                );

                                //remove old data
                                Provider.of<CloudDB>(context)
                                    .updateDocumentL1Array(
                                  collection: DBFolder.plants,
                                  document: plantID,
                                  key: PlantKeys.bloomSequence,
                                  entries: [sequenceMap],
                                  action: false,
                                );

                                //clear and pop
                                Provider.of<AppData>(context).newListInput = [];
                                Navigator.pop(context);
                              },
                            );
                          });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.edit,
                        color: AppTextColor.light,
                        size: AppTextSize.small *
                            MediaQuery.of(context).size.width,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class BloomLine extends StatelessWidget {
  final int duration;
//  final Color color;
  final Gradient gradient;
  final String label;
  BloomLine(
      {@required this.duration, @required this.gradient, @required this.label});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: duration,
      child: Container(
          padding: EdgeInsets.all(0.012 * MediaQuery.of(context).size.width),
          decoration: BoxDecoration(
//            border: Border.all(
//              width: 1.0,
//            ),
//            color: color,
            gradient: gradient,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontSize: AppTextSize.tiny * MediaQuery.of(context).size.width,
              fontWeight: AppTextWeight.medium,
              color: AppTextColor.white,
            ),
          )),
    );
  }
}

class BloomDate extends StatelessWidget {
  final Color color;
  final String date;
  BloomDate({this.color = kGreenDark, @required this.date});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.01 * MediaQuery.of(context).size.width),
      decoration: BoxDecoration(
        gradient: kGradientDarkMidGreen,
        borderRadius:
            BorderRadius.circular(0.015 * MediaQuery.of(context).size.width),
        border: Border.all(
          width: 1.0,
          color: kGreenDark,
        ),
      ),
      child: Text(
        date,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppTextSize.tiny * MediaQuery.of(context).size.width,
          fontWeight: AppTextWeight.heavy,
          color: AppTextColor.white,
        ),
      ),
    );
  }
}
