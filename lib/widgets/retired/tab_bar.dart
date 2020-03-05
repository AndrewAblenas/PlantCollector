import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';

class TabBarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people)),
              Tab(
                child: Image(
                  image: AssetImage('assets/images/app_icon_white_128.png'),
                  height:
                      AppTextSize.medium * MediaQuery.of(context).size.width,
                ),
              ),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
          title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
