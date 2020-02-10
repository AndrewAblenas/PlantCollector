import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
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
          Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextSection(
                title: 'Plant Collector',
                text:
                    'The purpose of Plant Collector is to provide an easy, intuitive, and feature rich tool to create your own personal plant library.  '
                    'Your library is organized into Groups.  '
                    'These groups contain your Collections.  '
                    'Finally, these Collections are where you\'ll find your plants.  ',
              ),
              TextSection(
                title: 'Groups',
                text:
                    'Groups hold your plant Collections are are used to organize your Library.  '
                    'You can add a new group by tapping the button on the library page.  '
                    'To rename, hold down on the Group name.  '
                    'You can quickly tap the Group name to change it\'s color.  '
                    'An arrow beside the name allows you to roll the Group up or down.  '
                    'When there are no Collections, a delete button is deplayed so you can remove the Group.  '
                    'The end of each Group provides a button to add Collections.  ',
              ),
              TextSection(
                title: 'Collections',
                text: 'Collections are where you can add your plants.  '
                    'Tap the add button to add a new plant.  '
                    'Holding down on a plant will allow you to move it to another Collection.  '
                    'You can rename a Collection by holding down on the Collection name.  '
                    'An arrow beside the name allows you to roll the Collection up or down.  '
                    'A Collection can only be deleted when it no longe holds any plants.  ',
              ),
              TextSection(
                title: 'Plant Profile',
                text:
                    'Tapping on a Collection plant will bring you to your plant\'s profile.  '
                    'Here you can add, edit, or delete/hide information.  '
                    'You can also add photos of your plant that you can scroll though to watch it grow.  \n\n'
                    'You can set any of the images as a thumbnail for the plant by tapping the grid icon (bottom right hand corner of the image).  '
                    'To view a full sized photo, just tap on the image.  \n\n'
                    'JOURNAL\n\n'
                    'A Journal attached to each plant, allow you to keep track of your plant related activites.  '
                    'These entries can be edited for 24hrs then are locked.  \n\n'
                    'CLONE\n\n'
                    'When viewing a friend\'s plant you can clone (copy) the plant data.  '
                    'This makes it easy if you have the same plant or would like to add it to a wishlist.  '
                    'The journal entries and images will not be copied.  ',
              ),
              TextSection(
                title: 'Connections and Chat',
                text:
                    'You can add friend\'s by there email address to view their plant library and chat.  '
                    'If the email address is not found, you will be able to send an invite link.  '
                    'They will not show as a friend until they accept your request.  \n\n'
                    'NOTIFICATIONS\n\n'
                    'In this version, if the app is closed, you will not receive message notifications.  '
                    'Message notifications will only be displayed while the app is running.  '
                    'The social aspect is in the early stages.  ',
              ),
              TextSection(
                title: 'Version and Development',
                text:
                    'The Plant Collector app is still undergoing initial testing.  Please feel free to share any suggestions to you may have to improve the application.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextSection extends StatelessWidget {
  final String title;
  final String text;
  TextSection({@required this.title, @required this.text});

  @override
  Widget build(BuildContext context) {
    return TileWhite(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: kHeaderText,
            ),
          ),
          Container(
            height: 1.0,
            width: 250.0,
            color: kGreenDark,
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text,
              style: kBodyText,
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}