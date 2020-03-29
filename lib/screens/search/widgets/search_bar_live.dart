import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/screens/search/widgets/search_bar_wrapper.dart';
import 'package:provider/provider.dart';

//SEARCH BAR WIDGET
class SearchBarLive extends StatefulWidget {
  @override
  _SearchBarLiveState createState() => _SearchBarLiveState();
}

class _SearchBarLiveState extends State<SearchBarLive> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.02 * MediaQuery.of(context).size.width,
      ),
      child: SearchBarWrapper(
        marginVertical: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.search),
              SizedBox(
                width: 0.04 * MediaQuery.of(context).size.width,
              ),
              SizedBox(
                width: 0.75 * MediaQuery.of(context).size.width,
                child: TextField(
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: AppTextColor.white,
                    fontSize:
                        AppTextSize.medium * MediaQuery.of(context).size.width,
                    fontWeight: AppTextWeight.medium,
                  ),
                  minLines: 1,
                  maxLines: 50,
                  onChanged: (value) {
                    Provider.of<AppData>(context).setInputSearchBarLive(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
