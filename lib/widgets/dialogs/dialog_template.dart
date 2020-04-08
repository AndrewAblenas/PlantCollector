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
          gradient: kBackgroundGradient,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 0.05 * MediaQuery.of(context).size.width,
              horizontal: 0.08 * MediaQuery.of(context).size.width),
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
                  color: AppTextColor.white,
                  shadows: kShadowText,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  text != null ? '$text' : '',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 1.1 *
                          AppTextSize.small *
                          MediaQuery.of(context).size.width,
                      fontWeight: AppTextWeight.heavy,
                      color: AppTextColor.white),
                ),
              ),
              SizedBox(
                height: 0.05 * MediaQuery.of(context).size.width,
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
