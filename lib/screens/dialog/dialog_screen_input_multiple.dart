import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/screens/dialog/custom_input_field.dart';
import 'package:plant_collector/screens/dialog/dialog_screen.dart';

class DialogScreenInputMultiple extends StatelessWidget {
  final String title;
  final String acceptText;
  final Function acceptOnPress;
  final Function onChange;
  final String cancelText;
//  final Function cancelFunction;
  final String hintText;
  final bool smallText;
  final List<String> keys;
  DialogScreenInputMultiple(
      {@required this.title,
      @required this.acceptText,
      @required this.acceptOnPress,
      @required this.onChange,
      @required this.cancelText,
//        @required this.cancelFunction,
      @required this.hintText,
      this.smallText,
      @required this.keys});
  @override
  Widget build(BuildContext context) {
    return DialogScreen(
      title: title,
      children: <Widget>[
        Column(
          children: <Widget>[
            //COMPLETE IF NEEDED IN THE FUTURE
          ],
        ),
        CustomInputField(
            hintText: hintText, smallText: smallText, onChange: onChange),
        SizedBox(
          height: AppTextSize.large * MediaQuery.of(context).size.width,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () {
//                  Provider.of<AppData>(context).newDataInput = null;
                  Navigator.pop(context);
                },
                child: Text(
                  cancelText.toUpperCase(),
                  style: TextStyle(
                    fontSize:
                        AppTextSize.large * MediaQuery.of(context).size.width,
                    fontWeight: AppTextWeight.medium,
                    color: kButtonCancel,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                onPressed: () {
                  acceptOnPress();
                },
                child: Text(
                  acceptText.toUpperCase(),
                  style: TextStyle(
                    fontSize:
                        AppTextSize.large * MediaQuery.of(context).size.width,
                    fontWeight: AppTextWeight.medium,
                    color: kButtonAccept,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
