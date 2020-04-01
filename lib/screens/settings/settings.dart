import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/models/data_storage/firebase_folders.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/screens/settings/info_screen.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/bottom_bar.dart';
import 'package:plant_collector/widgets/container_wrapper_gradient.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool admin = (Provider.of<AppData>(context).currentUserInfo.type ==
            UserTypes.creator ||
        Provider.of<AppData>(context).currentUserInfo.type == UserTypes.admin);
    return ScreenTemplate(
      implyLeading: false,
      screenTitle: 'Settings',
      bottomBar: BottomBar(
        selectionNumber: 5,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0 * MediaQuery.of(context).size.width * kScaleFactor,
          vertical: 0.0,
        ),
        child: ListView(
          primary: true,
          children: <Widget>[
            SizedBox(
              height: 10.0 * MediaQuery.of(context).size.width * kScaleFactor,
            ),
            admin
                ? Padding(
                    padding: EdgeInsets.only(
                        bottom: 10.0 *
                            MediaQuery.of(context).size.width *
                            kScaleFactor),
                    child: SettingsButton(
                        icon: Icons.work,
                        label: 'Admin Tools',
                        onPress: () {
                          if (admin) {
                            Navigator.pushNamed(context, 'admin');
                          }
                        }),
                  )
                : SizedBox(),
            GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 5.0),
              childAspectRatio: 1,
              crossAxisSpacing:
                  10.0 * MediaQuery.of(context).size.width * kScaleFactor,
              mainAxisSpacing:
                  10.0 * MediaQuery.of(context).size.width * kScaleFactor,
              crossAxisCount: 2,
              primary: false,
              children: <Widget>[
                SettingsButton(
                    icon: Icons.info_outline,
                    label: 'About',
                    onPress: () {
                      Navigator.pushNamed(context, 'about');
                    }),
                SettingsButton(
                    icon: Icons.account_box,
                    label: 'Account',
                    onPress: () {
                      Navigator.pushNamed(context, 'account');
                    }),
                SettingsButton(
                    icon: Icons.security,
                    label: 'Privacy',
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoScreen(
                            title: GlobalStrings.privacy,
                            documentName: DBDocument.privacyPolicy,
                          ),
                        ),
                      );
                    }),
                SettingsButton(
                    icon: Icons.people,
                    label: 'Conduct',
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoScreen(
                            title: GlobalStrings.guidelines,
                            documentName: DBDocument.communityGuidelines,
                          ),
                        ),
                      );
                    }),
//TODO
//                SettingsButton(
//                    icon: Icons.cloud_upload,
//                    label: 'Upload',
//                    onPress: () {
//                    }),
//                SettingsButton(
//                    icon: Icons.cloud_download,
//                    label: 'Download',
//                    onPress: () {
//                    }),
                SettingsButton(
                    icon: Icons.feedback,
                    label: 'Feedback',
                    onPress: () {
                      Navigator.pushNamed(context, 'feedback');
                    }),
                SettingsButton(
                    icon: Icons.exit_to_app,
                    label: 'Sign Out',
                    onPress: () {
                      Provider.of<UserAuth>(context).signOutUser();
                      Provider.of<UserAuth>(context).signedInUser = null;
                      Provider.of<AppData>(context).clearAppData();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'login');
                    }),
              ],
            ),
            SizedBox(
              height: 10.0 * MediaQuery.of(context).size.width * kScaleFactor,
            ),
          ],
        ),
      ),
    );
  }
}

//SETTINGS BUTTON
class SettingsButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onPress;
  SettingsButton(
      {@required this.icon, @required this.label, @required this.onPress});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: ContainerWrapperGradient(
        marginVertical: 0.0,
        child: Padding(
          padding: EdgeInsets.all(
            15.0 * MediaQuery.of(context).size.width * kScaleFactor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                icon,
                size: 100.0 * MediaQuery.of(context).size.width * kScaleFactor,
                color: AppTextColor.white,
              ),
              Text(
                label,
                style: TextStyle(
                  color: AppTextColor.white,
                  fontSize:
                      AppTextSize.huge * MediaQuery.of(context).size.width,
                  fontWeight: AppTextWeight.medium,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
