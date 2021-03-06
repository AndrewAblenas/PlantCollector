import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/screens/search/widgets/search_bar_wrapper.dart';
import 'package:plant_collector/widgets/tile_white.dart';
import 'package:provider/provider.dart';

//SEARCH BAR WIDGET

class SearchBarSubmit extends StatelessWidget {
  final Function onPress;
  SearchBarSubmit({@required this.onPress});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 1.0,
      ),
      child: SearchBarWrapper(
        marginVertical: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 0.04 * MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {
                        onPress();
                      },
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: AppTextColor.white,
                        fontSize: AppTextSize.medium *
                            MediaQuery.of(context).size.width,
                        fontWeight: AppTextWeight.medium,
                      ),
                      minLines: 1,
                      maxLines: 1,
                      onChanged: (value) {
                        Provider.of<AppData>(context, listen: false)
                            .newDataInput = value;
                        int length = value.length;
                        if (value[length - 1] == '\n') onPress();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 0.04 * MediaQuery.of(context).size.width,
                  ),
                  GestureDetector(
                    onTap: () {
                      onPress();
                      FocusScope.of(context).unfocus();
                    },
                    child: TileWhite(
                      child: Icon(
                        Icons.search,
                        size: AppTextSize.huge *
                            MediaQuery.of(context).size.width,
                      ),
                      bottomPadding: 5.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(),
                  Text(
                    'exact username search',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: kGreenLight,
                      fontSize:
                          AppTextSize.tiny * MediaQuery.of(context).size.width,
                      fontWeight: AppTextWeight.medium,
                    ),
                  ),
                  SizedBox(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
