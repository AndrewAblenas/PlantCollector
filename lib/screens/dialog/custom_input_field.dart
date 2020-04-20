import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:provider/provider.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {@required this.hintText,
      @required this.smallText,
      @required this.onChange,
      this.inputIndex,
      this.obscure = false});

  final String hintText;
  final bool smallText;
  final Function onChange;
  final int inputIndex;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    //obscured text can't be multiline
    int maxLines = (obscure == true) ? 1 : 10;

    return TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
        ),
        obscureText: obscure,
        initialValue: hintText,
        cursorColor: AppTextColor.white,
        autofocus: true,
        textAlign: smallText == true ? TextAlign.start : TextAlign.center,
        minLines: 1,
        maxLines: maxLines,
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
