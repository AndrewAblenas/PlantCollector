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
                    print(dataType);
                    //maybe these should be set elsewhere?
                    Provider.of<AppData>(context, listen: false).newListInput =
                        (dataType == BloomData) ? [0, 0, 0, 0, 0] : [0, 0, 0];
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SequenceScreen(
                              dataType: dataType,
                              plantID: plantID,
                              sequenceMap: null);
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
  final String dateText;
  FullSequence({
    @required this.plantID,
    @required this.connectionLibrary,
    @required this.sequenceRow,
    @required this.sequenceMap,
    @required this.dataType,
    @required this.dateText,
  });
  @override
  Widget build(BuildContext context) {
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: false);
    return GestureDetector(
      onTap: () {
        //only allow for your library
        if (connectionLibrary == false) {
          //clear any old data
          provAppDataFalse.newListInput = [];
          //then open a dialog
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
                    provAppDataFalse.newListInput.add(sequenceMap[item]);
                  }
                } else {
                  //set to default to store future data
                  if (dataType == BloomData) {
                    provAppDataFalse.newListInput = [
                      0,
                      0,
                      0,
                      0,
                      0,
                    ];
                  } else if (dataType == GrowthData) {
                    provAppDataFalse.newListInput = [
                      0,
                      0,
                      0,
                    ];
                  }
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
                    plantKey = PlantKeys.sequenceBloom;
                  } else if (dataType == GrowthData) {
                    plantKey = PlantKeys.sequenceGrowth;
                  }
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
        child: Column(
          children: <Widget>[
            Row(
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
                          size: AppTextSize.small *
                              MediaQuery.of(context).size.width,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            Text(
              dateText,
              style: TextStyle(
                fontSize: AppTextSize.tiny * MediaQuery.of(context).size.width,
                fontWeight: AppTextWeight.heavy,
                color: AppTextColor.medium,
              ),
            )
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
      plantKey = PlantKeys.sequenceBloom;
    } else if (dataType == GrowthData) {
      keyList = GrowthKeys.list;
      dateDescriptors = GrowthKeys.descriptors;
      plantKey = PlantKeys.sequenceGrowth;
    }
    return DialogScreenSelect(
      title: 'Sequence',
      items: UIBuilders.generateDateButtons(map: dateDescriptors),
      onAccept: () {
        //get the day of year, add to list
//        List entries = [];
//        for (List entry in Provider.of<AppData>(context).newListInput) {
//          int day = UIBuilders.getDayOfYear(month: entry[0], day: entry[1]);
//          entries.add(day);
//        }
        List data = Provider.of<AppData>(context, listen: false).newListInput;

        //pull the days and add to a map to upload the data
        Map<String, dynamic> valueMap = {};
        for (String item in keyList) {
          valueMap[item] = data[keyList.indexOf(item)];
        }

        //upload new data
        CloudDB.updateDocumentL1Array(
          collection: DBFolder.plants,
          document: plantID,
          key: plantKey,
          entries: [valueMap],
          action: true,
        );

        //TO CHECK EQUALITY OF MAPS
        bool changed = false;
        if (sequenceMap != null) {
          List mapValues1 = sequenceMap.values.toList();
          List mapValues2 = valueMap.values.toList();
          //if the length is different, there was clearly a change
          if (mapValues1.length != mapValues2.length) {
            changed = true;
          } else {
            //if the length is the same, check to see if the values changed
            for (int item2 in mapValues2) {
              //add to tally if they don't match
              if (mapValues1[mapValues2.indexOf(item2)] != item2) {
                changed = true;
                break;
              }
            }
          }
        }

        if (sequenceMap != null && (changed == true)) {
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
        Provider.of<AppData>(context, listen: false).newListInput = [];
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
//    int flex = (duration ~/ 86400000);
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
