import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/plant/bloom_data.dart';
import 'package:plant_collector/models/data_types/plant/growth_data.dart';
import 'package:plant_collector/models/data_types/plant/plant_data.dart';
import 'package:plant_collector/screens/dialog/dialog_screen_select.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';

class PlantSequence extends StatelessWidget {
  final String plantID;
  final List<Map> sequenceData;
  final Type dataType;
  final bool connectionLibrary;
  PlantSequence(
      {@required this.plantID,
      @required this.sequenceData,
      @required this.dataType,
      @required this.connectionLibrary});
  @override
  Widget build(BuildContext context) {
    //determine title
    String title;
    if (dataType == BloomData) {
      title = 'Bloom Sequence';
    } else if (dataType == GrowthData) {
      title = 'Growth Cycle';
    } else {
      title = '';
    }

    return TileWhite(
      bottomPadding: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 0.01 * MediaQuery.of(context).size.width),
            child: Text(
              title,
              textAlign: TextAlign.center,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize:
                    AppTextSize.medium * MediaQuery.of(context).size.width,
                fontWeight: AppTextWeight.medium,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: UIBuilders.buildSequenceWidget(
                sequenceData: sequenceData,
                dataType: dataType,
                plantID: plantID,
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
                          return SequenceScreen(
                              dataType: dataType,
                              plantID: plantID,
                              sequenceMap: null);
//                            DialogScreenSelect(
//                            title: 'New Information',
//                            items: UIBuilders.generateDateButtons(
//                                map: BloomKeys.descriptors),
//                            onAccept: () {
//                              //get the list of inputted data
//                              List data =
//                                  Provider.of<AppData>(context).newListInput;
//
//                              //get the day of year, add to list
//                              List bloomEntry = [];
//                              for (List entry in data) {
//                                int day = AppData.getDayOfYear(
//                                    month: entry[0], day: entry[1]);
//                                bloomEntry.add(day);
//                              }
//
//                              //pull the days and add to a map to upload the data
//                              Map<String, dynamic> bloomMap = {
//                                BloomKeys.bud: bloomEntry[0],
//                                BloomKeys.first: bloomEntry[1],
//                                BloomKeys.last: bloomEntry[2],
//                                BloomKeys.seed: bloomEntry[3]
//                              };
//
//                              //upload the data
//                              Provider.of<CloudDB>(context)
//                                  .updateDocumentL1Array(
//                                collection: DBFolder.plants,
//                                document: plantID,
//                                key: PlantKeys.bloomSequence,
//                                entries: [bloomMap],
//                                action: true,
//                              );
//
//                              //clear and pop
//                              Provider.of<AppData>(context).newListInput = [];
//                              Navigator.pop(context);
//                            },
//                          );
                        });
                  },
                  onLongPress: () {
                    //not needed, widget disappears on it's own
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

class FullSequence extends StatelessWidget {
  final String plantID;
  final bool connectionLibrary;
  final Widget sequenceRow;
  final Map<String, dynamic> sequenceMap;
  final Type dataType;
  FullSequence({
    @required this.plantID,
    @required this.connectionLibrary,
    @required this.sequenceRow,
    @required this.sequenceMap,
    @required this.dataType,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //only allow for your library
        if (connectionLibrary == false) {
          //CLEAR ANY OLD DATA
          Provider.of<AppData>(context).newListInput = [];
//          Provider.of<AppData>(context).newListInput = [
//            [
//              UIBuilders.getMonthFromDayOfYear(
//                  dayOfYear: sequenceMap[BloomKeys.bud]),
//              UIBuilders.getMonthDayFromDayOfYear(
//                  dayOfYear: sequenceMap[BloomKeys.bud])
//            ],
//            [
//              UIBuilders.getMonthFromDayOfYear(
//                  dayOfYear: sequenceMap[BloomKeys.first]),
//              UIBuilders.getMonthDayFromDayOfYear(
//                  dayOfYear: sequenceMap[BloomKeys.first])
//            ],
//            [
//              UIBuilders.getMonthFromDayOfYear(
//                  dayOfYear: sequenceMap[BloomKeys.last]),
//              UIBuilders.getMonthDayFromDayOfYear(
//                  dayOfYear: sequenceMap[BloomKeys.last])
//            ],
//            [
//              UIBuilders.getMonthFromDayOfYear(
//                  dayOfYear: sequenceMap[BloomKeys.seed]),
//              UIBuilders.getMonthDayFromDayOfYear(
//                  dayOfYear: sequenceMap[BloomKeys.seed])
//            ],
//          ];
          showDialog(
              context: context,
              builder: (BuildContext context) {
                if (sequenceMap != null) {
                  //DATA TYPE DEPENDENT
                  List<String> keyList = [];
                  if (dataType == BloomData) {
                    keyList = BloomKeys.list;
                  } else if (dataType == GrowthData) {
                    keyList = GrowthKeys.list;
                  }
                  for (String item in keyList) {
                    Provider.of<AppData>(context).newListInput.add([
                      UIBuilders.getMonthFromDayOfYear(
                          dayOfYear: sequenceMap[item]),
                      UIBuilders.getMonthDayFromDayOfYear(
                          dayOfYear: sequenceMap[item])
                    ]);
                  }
                } else {
                  //set to default to store future data
                  Provider.of<AppData>(context).newListInput = [
                    [0, 0],
                    [0, 0],
                    [0, 0],
                    [0, 0]
                  ];
                }
                return SequenceScreen(
                    dataType: dataType,
                    plantID: plantID,
                    sequenceMap: sequenceMap);
              });
        }
      },
      onLongPress: () {
        if (connectionLibrary == false) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogConfirm(
                hideCancel: false,
                title: 'Remove Sequence',
                text: 'Are you sure you would like to remove this information?',
                onPressed: () {
                  String plantKey;
                  if (dataType == BloomData) {
                    plantKey = PlantKeys.bloomSequence;
                  } else if (dataType == GrowthData) {
                    plantKey = PlantKeys.growthSequence;
                  }
                  print(plantKey);
                  CloudDB.updateDocumentL1Array(
                    collection: DBFolder.plants,
                    document: plantID,
                    key: plantKey,
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
                ? Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.edit,
                      color: AppTextColor.light,
                      size:
                          AppTextSize.small * MediaQuery.of(context).size.width,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class SequenceScreen extends StatelessWidget {
  const SequenceScreen({
    @required this.plantID,
    @required this.dataType,
    @required this.sequenceMap,
  });

  final String plantID;
  final Type dataType;
  final Map<String, dynamic> sequenceMap;

  @override
  Widget build(BuildContext context) {
    //DATA TYPE DEPENDENT
    List<String> keyList = [];
    Map dateDescriptors = {};
    String plantKey = '';
    if (dataType == BloomData) {
      keyList = BloomKeys.list;
      dateDescriptors = BloomKeys.descriptors;
      plantKey = PlantKeys.bloomSequence;
    } else if (dataType == GrowthData) {
      keyList = GrowthKeys.list;
      dateDescriptors = GrowthKeys.descriptors;
      plantKey = PlantKeys.growthSequence;
    }
    print(sequenceMap);
    return DialogScreenSelect(
      title: 'Sequence',
      items: UIBuilders.generateDateButtons(map: dateDescriptors),
      onAccept: () {
        //get the day of year, add to list
        List entries = [];
        for (List entry in Provider.of<AppData>(context).newListInput) {
          int day = UIBuilders.getDayOfYear(month: entry[0], day: entry[1]);
          entries.add(day);
        }

        //pull the days and add to a map to upload the data
        Map<String, dynamic> valueMap = {};
        for (String item in keyList) {
          valueMap[item] = entries[keyList.indexOf(item)];
        }

        print(valueMap);
        //upload new data
        CloudDB.updateDocumentL1Array(
          collection: DBFolder.plants,
          document: plantID,
          key: plantKey,
          entries: [valueMap],
          action: true,
        );

        //TO CHECK EQUALITY OF MAPS
        int tally = 0;
        if (sequenceMap != null) {
          List mapValues1 = sequenceMap.values.toList();
          List mapValues2 = valueMap.values.toList();
          for (int item1 in mapValues1) {
            //add to tally if they don't match
            if (mapValues2[mapValues1.indexOf(item1)] != item1) {
              tally++;
            }
          }
        }

        if (sequenceMap != null && (tally != 0)) {
          //remove old data
          CloudDB.updateDocumentL1Array(
            collection: DBFolder.plants,
            document: plantID,
            key: plantKey,
            entries: [sequenceMap],
            action: false,
          );
        }

        //clear and pop
        Provider.of<AppData>(context).newListInput = [];
        Navigator.pop(context);
      },
    );
  }
}

class SequenceLine extends StatelessWidget {
  final int duration;
//  final Color color;
  final Gradient gradient;
  final String label;
  SequenceLine(
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
                fontWeight: AppTextWeight.heavy,
                color: AppTextColor.white,
                shadows: kShadowText),
          )),
    );
  }
}

class SequenceDate extends StatelessWidget {
  final Color color;
  final String date;
  SequenceDate({this.color = kGreenDark, @required this.date});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.01 * MediaQuery.of(context).size.width),
      decoration: BoxDecoration(
        gradient: kGradientGreenVerticalDarkMed,
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
