import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:provider/provider.dart';

class DayOfYearSelector extends StatelessWidget {
  final String buttonText;
  final int index;
  final DateTime timeNow;
  DayOfYearSelector({
    @required this.buttonText,
    @required this.index,
    @required this.timeNow,
  });

  @override
  Widget build(BuildContext context) {
    //easy reference
    //this must be true to ensure dialog screen updates
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: true);
    //easy scale
    double width = MediaQuery.of(context).size.width;
    return Provider<List>.value(
      value: provAppDataFalse.newListInput,
      child: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: AppTextSize.small * width, horizontal: 0.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: AppTextSize.tiny * width),
                  Text(
                    buttonText.toUpperCase(),
                    style: TextStyle(
                      fontSize:
                          AppTextSize.huge * MediaQuery.of(context).size.width,
                      fontWeight: AppTextWeight.medium,
                      color: AppTextColor.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      height: AppTextSize.large *
                          MediaQuery.of(context).size.width),
                  Consumer<List>(
                    builder: (context, List newInput, _) {
                      //get the existing date value
                      int dateMS = newInput[index];

                      //determine what string to show
                      //if date is set to zero (empty) the show select
                      String selectedValueDisplay = (dateMS == 0)
                          ? 'Select'
                          : UIBuilders.standardDateFormat(msSinceEpoch: dateMS);

                      //generate a list of previous indices to iterate through
                      List<int> previousList =
                          List<int>.generate(index, (i) => i);

                      //set the lowest possible date as a default starting point
                      int largest = -2177452799000;

                      //check value at each
                      for (int item in previousList) {
                        //if input is not default (0) and is largest so far
                        if (newInput[item] != 0 && newInput[item] > largest)
                          largest = newInput[item];
                      }

                      //no convert the largest value into a date to use
                      DateTime firstDate =
                          DateTime.fromMillisecondsSinceEpoch(largest);

                      //set last date
                      //start with the current date as the last date selectable
                      int lowest = timeNow.millisecondsSinceEpoch;

                      //create a list of indices after to iterate through
                      int length = newInput.length - (index + 1);
                      List<int> afterList =
                          List<int>.generate(length, (i) => i + index + 1);

                      //now check future values to see if one is less than present time
                      for (int dateIndex in afterList) {
                        //if date is not default and is less than lowest
                        if (newInput[dateIndex] != 0 &&
                            newInput[dateIndex] < lowest)
                          lowest = newInput[dateIndex];
                      }

                      //now get the date object from the int
                      DateTime lastDate =
                          DateTime.fromMillisecondsSinceEpoch(lowest);

                      //if the date has a value set this as the initial value
                      //otherwise default to current time (-10 to be safe)
                      DateTime initialDate = (dateMS == 0)
                          ? DateTime.fromMillisecondsSinceEpoch(
                              timeNow.millisecondsSinceEpoch - 10)
                          : DateTime.fromMillisecondsSinceEpoch(dateMS);

                      //this first check ensures changes haven't resulted in a date outside
                      //the past/present range
                      if (initialDate.millisecondsSinceEpoch >
                              firstDate.millisecondsSinceEpoch &&
                          initialDate.millisecondsSinceEpoch <
                              lastDate.millisecondsSinceEpoch) {
                        //no change needed
                      } else if (initialDate.millisecondsSinceEpoch <
                          firstDate.millisecondsSinceEpoch) {
                        initialDate = firstDate;
                      } else if (initialDate.millisecondsSinceEpoch >
                          lastDate.millisecondsSinceEpoch) {
                        initialDate = lastDate;
                      }

                      return GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            //this should be close to the beginning of year 1
                            firstDate: firstDate,
                            lastDate: lastDate,
                          ).then((date) {
                            if (date != null) {
                              //format date
                              int value = date.millisecondsSinceEpoch;
                              //save to input array
                              provAppDataFalse.setInputNewList(
                                  index: index, value: value);
                              //this must be here to prevent unstable widget tree
//                          Navigator.pop(context);
                            } else {
//                          Navigator.pop(context);
                            }
                          });
                        },
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(
                                0.02 * MediaQuery.of(context).size.width),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.0, color: AppTextColor.whitish),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              'DATE: $selectedValueDisplay',
                              style: TextStyle(
                                fontSize: AppTextSize.medium *
                                    MediaQuery.of(context).size.width,
                                fontWeight: AppTextWeight.heavy,
                                color: AppTextColor.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
//                      ),
//                      Expanded(
//                        child: Consumer<List>(
//                            builder: (context, List newInput, _) {
//                          //set values
//                          int selectedMonth = newInput[index][0];
//                          String selectedValue = newInput[index][1].toString();
//                          bool disableButton = false;
//
//                          //this prevents Jun 30 from showing as month 6 day 0
//                          //this happens when converting from day of year
//                          if (selectedMonth != 0 && selectedValue == '0') {
//                            selectedValue = DatesCustom
//                                .monthDayCount[selectedMonth]
//                                .toString();
//                          } else if (selectedValue == '0') {
//                            selectedValue = 'Select';
//                          }
//
//                          //on first screen load and if user selects 0 month
//                          if (newInput[index][0].toString() == '0') {
//                            provAppDataFalse.newListInput[index]
//                                [1] = 0;
//                            disableButton = true;
//                          }
//
//                          return GestureDetector(
//                            onTap: () {
//                              if (disableButton == false) {
//                                showDialog(
//                                    context: context,
//                                    builder: (BuildContext context) {
//                                      return DialogPicker(
//                                        title: 'Pick a Day',
//                                        columns: 5,
//                                        listViewHeight: 1.0 *
//                                            MediaQuery.of(context).size.width,
//                                        widgets: UIBuilders.dateButtonsList(
//                                            index1: index,
//                                            index2: 1,
//                                            numbers: UIBuilders.daysInMonth(
//                                                month: newInput[index][0])),
//                                      );
//                                    });
//                              }
//                            },
//                            child: Center(
//                              child: Container(
//                                padding: EdgeInsets.all(
//                                    0.02 * MediaQuery.of(context).size.width),
//                                decoration: BoxDecoration(
//                                  border: Border.all(
//                                      width: 1.0,
//                                      color: (disableButton == true)
//                                          ? Color(0x33FFFFFF)
//                                          : AppTextColor.whitish),
//                                  borderRadius: BorderRadius.circular(10.0),
//                                ),
//                                child: Text(
//                                  'DAY: $selectedValue',
//                                  style: TextStyle(
//                                    fontSize: AppTextSize.medium *
//                                        MediaQuery.of(context).size.width,
//                                    fontWeight: AppTextWeight.heavy,
//                                    color: (disableButton == true)
//                                        ? Color(0x33FFFFFF)
//                                        : AppTextColor.white,
//                                  ),
//                                ),
//                              ),
//                            ),
//                          );
//                        }),
//                      ),
//                    ],
//                  ),
                  SizedBox(
                      height:
                          AppTextSize.tiny * MediaQuery.of(context).size.width),
                ],
              ),
            ),
            Container(
              height: 1.0,
              color: kGreenDark,
            ),
          ],
        ),
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final int index1;
  final int index2;
  final int value;
  NumberButton(
      {@required this.index1, @required this.index2, @required this.value});
  @override
  Widget build(BuildContext context) {
    //easy scale
    AppData provAppDataFalse = Provider.of<AppData>(context, listen: false);
    String text = (value == 0) ? 'X' : value.toString();

    return GestureDetector(
      onTap: () {
        provAppDataFalse.newListInput[index1][index2] = value;
        provAppDataFalse.notify();
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, gradient: kGradientGreenVerticalDarkMed),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: AppTextColor.white,
              fontWeight: AppTextWeight.heavy,
              fontSize: AppTextSize.large * MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }
}
