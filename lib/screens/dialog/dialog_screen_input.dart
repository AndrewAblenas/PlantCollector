import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/screens/dialog/custom_input_field.dart';
import 'package:plant_collector/screens/dialog/dialog_screen.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';

class DialogScreenInput extends StatelessWidget {
  final String title;
  final String acceptText;
  final Function acceptOnPress;
  final Function onChange;
  final String cancelText;
//  final Function cancelFunction;
  final String hintText;
  final bool smallText;
  final bool obscure;
  DialogScreenInput(
      {@required this.title,
      @required this.acceptText,
      @required this.acceptOnPress,
      @required this.onChange,
      @required this.cancelText,
//        @required this.cancelFunction,
      @required this.hintText,
      this.smallText,
      this.obscure = false});
  @override
  Widget build(BuildContext context) {
    return DialogScreen(
      title: title,
      children: <Widget>[
        CustomInputField(
          hintText: hintText,
          smallText: smallText,
          onChange: onChange,
          obscure: obscure,
        ),
        SizedBox(
          height: AppTextSize.large * MediaQuery.of(context).size.width,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () {
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
                onPressed: () async {
                  ConnectivityResult connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (connectivityResult != ConnectivityResult.none) {
                    acceptOnPress();
                  } else {
                    //show a dialog notifying the user
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DialogConfirm(
                            title: 'Updates Failed',
                            text:
                                'Make sure you are online and your current network isn\'t blocking google firebase.  '
                                'Otherwise, try connecting to another network.',
                            hideCancel: true,
                            onPressed: () {
                              Navigator.pop(context);
                            });
                      },
                    );
                  }
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
