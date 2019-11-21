import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';

class InputCard extends StatelessWidget {
  final String cardPrompt;
  final Function onChanged;
  final Function validator;
  final bool obscureText;
  InputCard(
      {this.cardPrompt, this.onChanged, this.validator, this.obscureText});

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
            textAlign: TextAlign.center,
            autofocus: false,
            cursorColor: kGreenDark,
            onChanged: onChanged,
            validator: validator,
            obscureText: obscureText == null ? false : obscureText,
            decoration: InputDecoration(
              focusColor: Colors.white,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: kGreenDark,
                  width: 3.0,
                ),
              ),
            ),
            style: TextStyle(
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
              color: kGreenMedium,
              fontSize: AppTextSize.small * MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
