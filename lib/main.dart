//import list
import 'package:flutter/material.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/screens/chat/chat.dart';
import 'package:plant_collector/screens/connections/connections.dart';
import 'package:plant_collector/screens/library/library.dart';
import 'package:plant_collector/screens/library/local_notification.dart';
import 'package:plant_collector/screens/login/login.dart';
import 'package:plant_collector/screens/login/register.dart';
import 'package:plant_collector/screens/plant/plant.dart';
import 'package:plant_collector/screens/settings.dart';
import 'package:plant_collector/screens/plant/image.dart';
import 'package:provider/provider.dart';
import 'models/app_data.dart';
import 'package:plant_collector/screens/account/account.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/screens/login/route.dart';
import 'package:plant_collector/screens/about.dart';
import 'package:plant_collector/screens/login/loading.dart';
import 'package:plant_collector/formats/colors.dart';

//main function call to launch app
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserAuth>(builder: (context) => UserAuth()),
        ChangeNotifierProvider<AppData>(builder: (context) => AppData()),
        ChangeNotifierProvider<CloudDB>(builder: (context) => CloudDB()),
//        ChangeNotifierProvider<UIBuilders>(builder: (context) => UIBuilders()),
        ChangeNotifierProvider<CloudStore>(builder: (context) => CloudStore()),
      ],
      child: PlantCollector(),
    ),
  );
}

//root function
class PlantCollector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocalNotificationWrapper(
      userId: Provider.of<AppData>(context).currentUserInfo.id,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plant Collector',
        initialRoute: 'loading',
        theme: Theme.of(context).copyWith(
          accentColor: kGreenDark,
          cursorColor: kGreenDark,
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: kGreenDark,
                width: 2.0,
              ),
            ),
          ),
        ),
        routes: {
          'loading': (context) => LoadingScreen(),
          'about': (context) => AboutScreen(),
          'route': (context) => RouteScreen(),
          'library': (context) => LibraryScreen(
                userID: null,
                connectionLibrary: false,
              ),
          'login': (context) => LoginScreen(),
          'register': (context) => RegisterScreen(),
          'plant': (context) => PlantScreen(
              connectionLibrary: null,
              plantID: null,
              forwardingCollectionID: null),
          'image': (context) => ImageScreen(),
          'settings': (context) => SettingsScreen(),
          'account': (context) => AccountScreen(),
          'connections': (context) => ConnectionsScreen(),
          'chat': (context) => ChatScreen(friend: null),
        },
      ),
    );
  }
}