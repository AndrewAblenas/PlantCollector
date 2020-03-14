import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:provider/provider.dart';

class ResultsScreen extends StatelessWidget {
  final List<Widget> searchResults;
  ResultsScreen({@required this.searchResults});
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      screenTitle: 'Results',
      child: ListView(
        children: <Widget>[
          SizedBox(height: 0.03 * MediaQuery.of(context).size.width),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.02 * MediaQuery.of(context).size.width,
            ),
            child: Consumer<AppData>(
              builder: (context, AppData data, _) {
                if (searchResults.length == 0)
                  searchResults.add(Container(
                    padding: EdgeInsets.all(
                      20.0,
                    ),
                    width: double.infinity,
                    child: Text(
                      'No exact results were found.\nPlease try another search.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppTextSize.medium *
                            MediaQuery.of(context).size.width,
                        fontWeight: AppTextWeight.medium,
                      ),
                    ),
                  ));
                return ListView(
                  primary: false,
                  shrinkWrap: true,
                  children: searchResults,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
