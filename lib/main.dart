//import list
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/screens/about/reference.dart';
import 'package:plant_collector/screens/admin/admin.dart';
import 'package:plant_collector/screens/chat/chat.dart';
import 'package:plant_collector/screens/discover//discover.dart';
import 'package:plant_collector/screens/friends//friends.dart';
import 'package:plant_collector/screens/feedback/feedback.dart';
import 'package:plant_collector/screens/library/library.dart';
import 'package:plant_collector/screens/library/local_notification.dart';
import 'package:plant_collector/screens/login/login.dart';
import 'package:plant_collector/screens/login/register.dart';
import 'package:plant_collector/screens/plant/plant.dart';
import 'package:plant_collector/screens/search/search.dart';
import 'package:plant_collector/screens/settings/settings.dart';
import 'package:plant_collector/screens/plant/image.dart';
import 'package:provider/provider.dart';
import 'models/app_data.dart';
import 'package:plant_collector/screens/account/account.dart';
import 'package:plant_collector/models/cloud_store.dart';
import 'package:plant_collector/screens/login/route.dart';
import 'package:plant_collector/screens/about/about.dart';
import 'package:plant_collector/screens/login/loading.dart';
import 'package:plant_collector/formats/colors.dart';

//main function call to launch app
void main() {
  //change the navigation bar to match
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserAuth>(create: (context) => UserAuth()),
        ChangeNotifierProvider<AppData>(create: (context) => AppData()),
        ChangeNotifierProvider<CloudDB>(create: (context) => CloudDB()),
//        ChangeNotifierProvider<UIBuilders>(builder: (context) => UIBuilders()),
        ChangeNotifierProvider<CloudStore>(create: (context) => CloudStore()),
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
      userId: Provider.of<AppData>(context).currentUserInfo != null
          ? Provider.of<AppData>(context).currentUserInfo.id
          : 'Not logged in',
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
          'reference': (context) => ReferenceScreen(title: null, text: null),
          'route': (context) => RouteScreen(),
          'library': (context) => LibraryScreen(
                userID: null,
                connectionLibrary: false,
              ),
          'login': (context) => LoginScreen(),
          'register': (context) => RegisterScreen(),
          'plant': (context) => PlantScreen(
              connectionLibrary: null,
              communityView: null,
              plantID: null,
              forwardingCollectionID: null),
          'image': (context) => ImageScreen(connectionLibrary: null),
          'settings': (context) => SettingsScreen(),
          'account': (context) => AccountScreen(),
          'connections': (context) => FriendsScreen(),
          'community': (context) => DiscoverScreen(),
          'chat': (context) => ChatScreen(
                friend: null,
              ),
          'feedback': (context) => FeedbackScreen(),
          'search': (context) => SearchScreen(),
          'admin': (context) => AdminScreen(),
        },
      ),
    );
  }
}
