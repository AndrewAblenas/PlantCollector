import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/builders_general.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/widgets/dialogs/color_picker/dialog_picker.dart';
import 'package:provider/provider.dart';

class DialogItemBloom extends StatelessWidget {
  final String buttonText;
  final int index;
//  final List<DropdownMenuItem> itemList1;
  DialogItemBloom({
    @required this.buttonText,
    @required this.index,
//    @required this.itemList1,
  });

  @override
  Widget build(BuildContext context) {
    return Provider<List>.value(
      value: Provider.of<AppData>(context).newListInput,
      child: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical:
                      AppTextSize.small * MediaQuery.of(context).size.width,
                  horizontal: 0.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                      height: AppTextSize.large *
                          MediaQuery.of(context).size.width),
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DialogPicker(
                                    title: 'Pick a Month',
                                    columns: 4,
                                    listViewHeight: 0.55 *
                                        MediaQuery.of(context).size.width,
                                    widgets: UIBuilders.dateButtonsList(
                                        index1: index,
                                        index2: 0,
                                        numbers: DatesCustom.monthNumbers),
                                  );
                                });
                          },
                          child: Consumer<List>(
                              builder: (context, List newInput, _) {
                            String selectedValue =
                                newInput[index][0].toString();
                            if (selectedValue == '0') {
                              selectedValue = 'Select';
                            }
                            return Center(
                                child: Container(
                              padding: EdgeInsets.all(
                                  0.02 * MediaQuery.of(context).size.width),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0, color: AppTextColor.whitish),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                'MONTH: $selectedValue',
                                style: TextStyle(
                                  fontSize: AppTextSize.medium *
                                      MediaQuery.of(context).size.width,
                                  fontWeight: AppTextWeight.heavy,
                                  color: AppTextColor.white,
                                ),
                              ),
                            ));
                          }),
                        ),
                      ),
                      Expanded(
                        child: Consumer<List>(
                            builder: (context, List newInput, _) {
                          //set values
                          String selectedValue = newInput[index][1].toString();
                          bool disableButton = false;

                          if (selectedValue == '0') {
                            selectedValue = 'Select';
                          }

                          //on first screen load and if user selects 0 month
                          if (newInput[index][0].toString() == '0') {
                            Provider.of<AppData>(context).newListInput[index]
                                [1] = 0;
                            disableButton = true;
                          }

                          return GestureDetector(
                            onTap: () {
                              if (disableButton == false) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DialogPicker(
                                        title: 'Pick a Day',
                                        columns: 5,
                                        listViewHeight: 1.0 *
                                            MediaQuery.of(context).size.width,
                                        widgets: UIBuilders.dateButtonsList(
                                            index1: index,
                                            index2: 1,
                                            numbers: UIBuilders.daysInMonth(
                                                month: newInput[index][0])),
                                      );
                                    });
                              }
                            },
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(
                                    0.02 * MediaQuery.of(context).size.width),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0,
                                      color: (disableButton == true)
                                          ? Color(0x33FFFFFF)
                                          : AppTextColor.whitish),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  'DAY: $selectedValue',
                                  style: TextStyle(
                                    fontSize: AppTextSize.medium *
                                        MediaQuery.of(context).size.width,
                                    fontWeight: AppTextWeight.heavy,
                                    color: (disableButton == true)
                                        ? Color(0x33FFFFFF)
                                        : AppTextColor.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: AppTextSize.large *
                          MediaQuery.of(context).size.width),
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
    String text = (value == 0) ? 'X' : value.toString();

    return GestureDetector(
      onTap: () {
        Provider.of<AppData>(context).newListInput[index1][index2] = value;
        Provider.of<AppData>(context).notify();
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, gradient: kGradientDarkMidGreen),
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
