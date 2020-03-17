import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/about/reference.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/tile_white.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenLight,
      appBar: AppBar(
        backgroundColor: kGreenDark,
        centerTitle: true,
        title: Text(
          'About',
          style: kAppBarTitle,
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: ContainerWrapper(
              color: kGreenMedium,
              child: Column(
                children: <Widget>[
                  ReferenceButton(
                    title: GlobalStrings.app,
                    text:
                        'The purpose of ${GlobalStrings.app} is to provide an easy, intuitive, and feature rich tool to create and share your own personal ${GlobalStrings.plant} ${GlobalStrings.library}.  '
                        'Your ${GlobalStrings.library} is organized into ${GlobalStrings.groups}.  \n\n'
                        'Each of these ${GlobalStrings.groups} contain any ${GlobalStrings.collections} that you have added.  '
                        'These ${GlobalStrings.collections} in turn, are where you add your ${GlobalStrings.plants}.  ',
                  ),
                  ReferenceButton(
                    title: GlobalStrings.library,
                    text:
                        'Your ${GlobalStrings.library} is the main page of this app.  '
                        'This page displays your profile header and is where you add all your ${GlobalStrings.plants}.  \n\n'
                        'After you have added some ${GlobalStrings.friends}, you will be able to view their ${GlobalStrings.libraries} as well.  '
                        'Their ${GlobalStrings.libraries} via the ${GlobalStrings.discover} tab at the bottom of the screen.  ',
                  ),
                  ReferenceButton(
                    title: 'Profile Header',
                    text:
                        'The Profile Header displays information about you and your ${GlobalStrings.library}.  '
                        'The information displayed can be changed right on screen.  \n\n'
                        'Hold down on your name, avatar, or banner to customize them.  '
                        'Note this information can also be updated by tapping the ${GlobalStrings.settings} tab, then ${GlobalStrings.account}.  ',
                  ),
                  ReferenceButton(
                    title: GlobalStrings.groups,
                    text:
                        '${GlobalStrings.groups} hold your ${GlobalStrings.collections} and are used to organize your ${GlobalStrings.library}.  '
                        'You can add a new ${GlobalStrings.group} by tapping the Add ${GlobalStrings.group} button at the bottom of the ${GlobalStrings.library} page.  \n\n'
                        'To rename, hold down on the ${GlobalStrings.group} name.  '
                        'Tap the ${GlobalStrings.group} name to customize it\'s colour.  '
                        'An arrow to the right of the name allows you to collapse or expand the ${GlobalStrings.group}.  \n\n'
                        'When there are no ${GlobalStrings.collections}, a delete button is deplayed so you can delete the ${GlobalStrings.group}.  '
                        'At the end of each ${GlobalStrings.group} there is a button that allows you to add ${GlobalStrings.collections}.  ',
                  ),
                  ReferenceButton(
                    title: GlobalStrings.collections,
                    text:
                        '${GlobalStrings.collections} contain your ${GlobalStrings.plants} and allow you to add new ones.  '
                        'You can rename a ${GlobalStrings.collection} by holding down on the ${GlobalStrings.collection} name.  \n\n'
                        'An arrow to the right of the name allows you to move the ${GlobalStrings.collection} to a different ${GlobalStrings.group}.  '
                        'A ${GlobalStrings.collection} can only be deleted when it no longe holds any ${GlobalStrings.plants}.  '
                        'An arrow at the bottom allows you to collapse or expand the ${GlobalStrings.collection}.  \n\n'
                        'Tap the green add button to add a new ${GlobalStrings.plant}.  '
                        'Holding down on a ${GlobalStrings.plant} tile will allow you to move it to another ${GlobalStrings.collection}.  ',
                  ),
                  ReferenceButton(
                    title: GlobalStrings.plants,
                    text:
                        'Tapping on a ${GlobalStrings.plant} tile will bring you to your ${GlobalStrings.plant}\'s profile.  '
                        'Here you can add, edit, delete, share, or hide information.  '
                        'You can also add photos of your ${GlobalStrings.plant}.  '
                        'To view a full sized photo, just tap on the image.  \n\n'
                        'You can set any uploaded image as a thumbnail for the ${GlobalStrings.plant} by tapping the grid icon (bottom right hand corner of the image).  '
                        'Note: The first image added will be set as the ${GlobalStrings.plant} thumbnail by default.  \n\n'
                        'JOURNAL\n\n'
                        'A ${GlobalStrings.journal} is attached to each ${GlobalStrings.plant}, allowing you to keep track of your ${GlobalStrings.plant} related activities.  '
                        'These entries can be edited for 24hrs then are locked.  '
                        'The ${GlobalStrings.journal} is only visible to you and cannot be viewed by ${GlobalStrings.friends}.  \n\n'
                        'CLONE\n\n'
                        'When viewing a ${GlobalStrings.friend}\'s plant you can ${GlobalStrings.clone} (copy) the ${GlobalStrings.plant} data.  '
                        'This makes it easy if you have the same ${GlobalStrings.plant}, received a division, or would like to add it to a wishlist.  '
                        'The ${GlobalStrings.journal} entries and images will not be copied.  \n\n'
                        'Another button is provided next to the ${GlobalStrings.clone} button that allows you to like a ${GlobalStrings.friend}\'s ${GlobalStrings.plant}.  '
                        'This is called giving a ${GlobalStrings.greenThumb}.  ',
                  ),
                  ReferenceButton(
                    title: '${GlobalStrings.friends} and Chat',
                    text:
                        'You can add ${GlobalStrings.friends} by their email address to view their ${GlobalStrings.plant} ${GlobalStrings.library} and chat.  '
                        'If their email address is not found, you will be able to send an invite link.  '
                        'They have to accept your request before you will see them as a ${GlobalStrings.friend}.  \n\n'
                        'NOTIFICATIONS\n\n'
                        'Currently, if the app is closed, you will not receive message notifications.  '
                        'Message notifications will only be displayed while the app is running.  '
                        'The social aspect is in the early stages.  ',
                  ),
                  ReferenceButton(
                    title: '${GlobalStrings.discover}',
                    text:
                        'The ${GlobalStrings.discover} section allows you to view other users ${GlobalStrings.plants}, provides ${GlobalStrings.announcements}, shows Top Collectors, and allows you to exact name search for a User.  \n\n'
                        'The newest, most cloned, and most ${GlobalStrings.greenThumb}ed ${GlobalStrings.plants} are shown here to allow you to discover new ${GlobalStrings.plants}, clone a ${GlobalStrings.plant} to your ${GlobalStrings.collection}, and discover new Users.  ',
                  ),
                  ReferenceButton(
                    title: 'Version and Development',
                    text:
                        'The ${GlobalStrings.app} app is still undergoing development and testing.  '
                        'Please feel free to share any suggestions you may have to improve the application.  '
                        'This can be done via tapping the ${GlobalStrings.settings} tab then ${GlobalStrings.feedback} button.  ',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReferenceButton extends StatelessWidget {
  final String title;
  final String text;
  ReferenceButton({@required this.title, @required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReferenceScreen(title: title, text: text),
          ),
        );
      },
      child: TileWhite(
        bottomPadding: 0.0,
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: kHeaderText,
            ),
          ),
        ),
      ),
    );
  }
}
