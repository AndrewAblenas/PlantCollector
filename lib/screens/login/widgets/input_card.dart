import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class InputCard extends StatelessWidget {
  final String cardPrompt;
  final Function onChanged;
  final Function validator;
  final bool obscureText;
  final TextInputType keyboardType;
  InputCard(
      {this.cardPrompt,
      this.onChanged,
      this.validator,
      this.obscureText,
      @required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 20.0,
      ),
      child: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: keyboardType,
            textAlign: TextAlign.center,
            autofocus: false,
            cursorColor: kGreenDark,
            onChanged: onChanged,
            validator: validator,
            obscureText: obscureText == null ? false : obscureText,
            decoration: InputDecoration(
              focusColor: Colors.white,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kGreenDark),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kGreenDark,
                  width: 3.0,
                ),
              ),
            ),
            style: TextStyle(
              color: kGreenDark,
              fontSize: AppTextSize.medium * MediaQuery.of(context).size.width,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            cardPrompt,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kGreenDark,
              fontSize: AppTextSize.small * MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
