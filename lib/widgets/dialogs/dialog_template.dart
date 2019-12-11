import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/formats/colors.dart';

class DialogTemplate extends StatelessWidget {
  final String title;
  final String text;
  final List<Widget> list;
  DialogTemplate(
      {@required this.title, @required this.text, @required this.list});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            colors: [kGreenMedium, kGreenLight],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 5.0,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:
                      AppTextSize.large * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.heavy,
                  color: AppTextColor.black,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 1.0,
                width: double.infinity,
                child: Container(
                  color: kGreenDark,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                text != null ? '$text' : '',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize:
                        AppTextSize.medium * MediaQuery.of(context).size.width,
                    fontWeight: AppTextWeight.medium,
                    color: AppTextColor.black),
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(
                children: list,
              )
            ],
          ),
        ),
      ),
    );
  }
}
