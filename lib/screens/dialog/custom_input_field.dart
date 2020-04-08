import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:provider/provider.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {@required this.hintText,
      @required this.smallText,
      @required this.onChange,
      this.inputIndex});

  final String hintText;
  final bool smallText;
  final Function onChange;
  final int inputIndex;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
        ),
        initialValue: hintText,
        cursorColor: AppTextColor.white,
        autofocus: true,
        textAlign: smallText == true ? TextAlign.start : TextAlign.center,
        minLines: 1,
        maxLines: 10,
        onChanged: (change) {
          (inputIndex != null)
              ? Provider.of<AppData>(context).newListInput[inputIndex] = change
              : onChange(change);
        },
        style: smallText == true
            ? TextStyle(
                fontSize:
                    AppTextSize.medium * MediaQuery.of(context).size.width,
                fontWeight: AppTextWeight.heavy,
                color: AppTextColor.white,
              )
            : TextStyle(
                fontSize: AppTextSize.huge * MediaQuery.of(context).size.width,
                fontWeight: AppTextWeight.heavy,
                color: AppTextColor.white,
              ));
  }
}
