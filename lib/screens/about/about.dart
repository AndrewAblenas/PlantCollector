import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/global.dart';
import 'package:plant_collector/screens/about/reference.dart';
import 'package:plant_collector/screens/template/screen_template.dart';
import 'package:plant_collector/widgets/container_wrapper.dart';
import 'package:plant_collector/widgets/tile_white.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(
      backgroundColor: kGreenLight,
      screenTitle: 'About',
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: ContainerWrapper(
              color: kGreenMedium,
              child: Column(
                children: <Widget>[
                  ReferenceButton(
                    title: GlobalStrings.app,
                    icon: null,
                    text:
                        'The purpose of ${GlobalStrings.app} is to provide an easy, intuitive, and feature rich tool to create and share your own personal ${GlobalStrings.plant} ${GlobalStrings.library}.  \n\n'
                        'The first tab is the ${GlobalStrings.discover} section.  Here you can find new Plants and new Friends.  \n\n'
                        'This is followed by the Search tab which allows you to search through your personal ${GlobalStrings.plant} Library.  \n\n'
                        'The centre tab provides access to your personal ${GlobalStrings.library}.  '
                        'Here you can build ${GlobalStrings.collections} (just like at home) to display your ${GlobalStrings.plants}.  \n\n'
                        'The fourth tab gives you access to your ${GlobalStrings.friends} where you can view their ${GlobalStrings.libraries}, start chats and accept ${GlobalStrings.friend} requests.  \n\n'
                        'Finally the ${GlobalStrings.settings} tab provides access to various information and settings.  ',
                  ),
                  ReferenceButton(
                    title: '${GlobalStrings.discover}',
                    icon: Icons.blur_circular,
                    text:
                        'The ${GlobalStrings.discover} section provides feeds of everyone\'s ${GlobalStrings.plants}.  '
                        'Here you can view Most Cloned, Most ${GlobalStrings.greenThumb}ed, Newest, and Recently Updated ${GlobalStrings.plants}.  The Top Collectors by total plant count are also shown.  ',
                  ),
                  ReferenceButton(
                    title: '${GlobalStrings.clone}',
                    indent: true,
                    icon: Icons.control_point_duplicate,
                    text:
                        'When viewing a plant you can ${GlobalStrings.clone} (copy) the ${GlobalStrings.plant} data.  '
                        'This makes it easy if you have the same ${GlobalStrings.plant}, received a division, or would like to add it to a wishlist.  \n\n'
                        'The Plant will automatically be added to the "Cloned" ${GlobalStrings.collection} in your ${GlobalStrings.library}.  '
                        'The ${GlobalStrings.journal} entries and images will not be copied and the Cloned Plant will not be shown in the ${GlobalStrings.discover} section until you add new images.  \n\n',
                  ),
                  ReferenceButton(
                    title: '${GlobalStrings.greenThumb}',
                    indent: true,
                    icon: Icons.thumb_up,
                    text:
                        'When viewing a ${GlobalStrings.plant} you can provide positive feedback by tapping the thumbs up button.  '
                        'This is called giving a ${GlobalStrings.greenThumb}.  ',
                  ),
                  ReferenceButton(
                      title: 'Search',
                      icon: Icons.search,
                      text:
                          'The Search section allows you to search through both your own personal ${GlobalStrings.plants} and all visible community ${GlobalStrings.plants}.  '
                          'This provides a quick way to find a ${GlobalStrings.plant} by name.  '),
                  ReferenceButton(
                      title: 'My Plants',
                      icon: Icons.person_outline,
                      indent: true,
                      text:
                          'Here you can filter through your own personal ${GlobalStrings.plant} ${GlobalStrings.library}.  '
                          'The more detailed your ${GlobalStrings.plant} profiles, the easier it is to find one.  \n\n'
                          'Any ${GlobalStrings.plants} that have matching information in the Display Name, Variety, Hybrid, Species, or Genus will be filtered live.'),
                  ReferenceButton(
                      title: 'All Plants',
                      icon: Icons.people_outline,
                      indent: true,
                      text:
                          'This tab allows you to search through all visible community ${GlobalStrings.plants}.  '
                          'Only ${GlobalStrings.plants} with exact text matches will be shown in the results.  '),
                  ReferenceButton(
                    title: GlobalStrings.library,
                    icon: null,
                    text:
                        'Your ${GlobalStrings.library} is the main page of this app.  '
                        'This page displays your profile header and is where you add all your ${GlobalStrings.plants}.  \n\n'
                        'Your ${GlobalStrings.library} is visible to the community by default.  '
                        'If made private, only accepted ${GlobalStrings.friends} will be able to view your ${GlobalStrings.library} '
                        'via the ${GlobalStrings.friends} page.  ',
                  ),
                  ReferenceButton(
                    title: 'Profile Header',
                    icon: Icons.table_chart,
                    indent: true,
                    text:
                        'The Profile Header displays information about you and your ${GlobalStrings.library}.  '
                        'The information displayed can be changed right on screen.  \n\n'
                        'Hold down on your name, avatar, or banner to customize them.  '
                        'Note this information can also be updated by tapping the ${GlobalStrings.settings} tab, then ${GlobalStrings.account}.  \n\n'
                        'Special ${GlobalStrings.collections} and certain ${GlobalStrings.plants} (such as your Wishlist and everything in it) are exluded from the Profile Header total counts.  ',
                  ),
                  ReferenceButton(
                    title: GlobalStrings.collections,
                    icon: Icons.storage,
                    indent: true,
                    text:
                        '${GlobalStrings.collections} contain your ${GlobalStrings.plants} and allow you to add new ones.  '
                        'You can rename a ${GlobalStrings.collection} by holding down on the ${GlobalStrings.collection} name.  \n\n'
                        'An arrow to the right of the name allows you to expand or collapse the ${GlobalStrings.collection}.  Hold down on this arrow to change the colour.  \n\n'
                        'A ${GlobalStrings.collection} can only be deleted when it no longer holds any ${GlobalStrings.plants}.  '
                        'Tap the green add button to add a new ${GlobalStrings.plant}.  '
                        'Holding down on a ${GlobalStrings.plant} tile will allow you to move it to another ${GlobalStrings.collection}.  \n\n'
                        'Certain default ${GlobalStrings.collections} (denoted with a star) have special properties.  '
                        'In some of these special ${GlobalStrings.collections} you are only allowed to remove (not add) ${GlobalStrings.plants}.',
                  ),
                  ReferenceButton(
                    title: GlobalStrings.plants,
                    icon: Icons.local_florist,
                    indent: true,
                    text:
                        'Tapping on a ${GlobalStrings.plant} tile will bring you to the ${GlobalStrings.plant}\'s profile.  '
                        'Here you can add, edit, delete, share, or hide information.  \n\n'
                        'You can also add photos of your ${GlobalStrings.plant}.  '
                        'To view a full sized photo, just tap on the image.  '
                        'You can set any uploaded image as a thumbnail for the ${GlobalStrings.plant} by tapping the grid icon (bottom right hand corner of the image).  \n\n'
                        'When you have more photos, the display will switch from carousel to a gridview.  When this happens, tap the image, then hold down on the full sized image to set as a thumbnail.  \n\n'
                        'Note: The first image added will be set as the ${GlobalStrings.plant} thumbnail.  '
                        'After you add an image the ${GlobalStrings.plant} becomes visible to the community unless your ${GlobalStrings.library} is private.  \n\n'
                        'JOURNAL\n\n'
                        'A ${GlobalStrings.journal} is attached to each ${GlobalStrings.plant}, allowing you to keep track of your ${GlobalStrings.plant} related activities.  '
                        'These entries can only be edited for 24hrs to allow spelling and grammar fixes.  '
                        'After this time they are locked to editing.  '
                        'All ${GlobalStrings.journal}s are visible to the community if the ${GlobalStrings.plant} is visible.  ',
                  ),
                  ReferenceButton(
                    title: '${GlobalStrings.friends}',
                    icon: Icons.people,
                    text:
                        'The ${GlobalStrings.friends} section is where you manage your Friends and chat.  '
                        'Once your Friend request is accepted you will see them as a ${GlobalStrings.friend}.  \n\n',
                  ),
                  ReferenceButton(
                    title: 'Requests',
                    indent: true,
                    icon: Icons.accessibility_new,
                    text:
                        'When people send you a friend request it will be displayed at the top of the ${GlobalStrings.friend} screen.  '
                        'You can accept or delete their request by tapping the appropriate buttons.  ',
                  ),
                  ReferenceButton(
                    title: 'Current Chats',
                    indent: true,
                    icon: Icons.message,
                    text:
                        'After you have started a chat with a ${GlobalStrings.friend} it will be displayed with a notification bubble in Current Chats.  '
                        'Chats are started via the message button in the section below.  ',
                  ),
                  ReferenceButton(
                    title: 'Connections',
                    indent: true,
                    icon: Icons.people_outline,
                    text:
                        'Connections displays all of your accepted ${GlobalStrings.friends}.  '
                        'You can start a chat here, view a ${GlobalStrings.friends}\'s ${GlobalStrings.library}, or remove someone by holding down on their tile. ',
                  ),
                  ReferenceButton(
                    title: 'Notifications',
                    indent: true,
                    icon: Icons.thumb_up,
                    text:
                        'Currently, if the app is closed, you will not receive message notifications.  '
                        'For the time being, any notifications will only be displayed while the app is running.  ',
                  ),
                  ReferenceButton(
                    title: '${GlobalStrings.settings}',
                    icon: Icons.settings,
                    text:
                        'The ${GlobalStrings.settings} screen allows you to view various categories of useful information and update your account.  ',
                  ),
                  ReferenceButton(
                    title: 'Version and Development',
                    icon: Icons.developer_mode,
                    text: 'Development is ongoing.  '
                        'Please feel free to share any suggestions you may have to improve the application.  '
                        'This can be done via tapping the ${GlobalStrings.settings} tab then ${GlobalStrings.feedback} button.  ',
                  ),
                  SizedBox(
                    height: 5.0,
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
  final IconData icon;
  final String title;
  final String text;
  final bool indent;
  ReferenceButton({
    @required this.icon,
    @required this.title,
    @required this.text,
    this.indent = false,
  });

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
      child: Row(
        children: <Widget>[
          indent
              ? Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(
                    Icons.subdirectory_arrow_right,
                    size: AppTextSize.large * MediaQuery.of(context).size.width,
                    color: AppTextColor.white,
                  ),
                )
              : SizedBox(),
          Expanded(
            child: TileWhite(
              bottomPadding: 0.0,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      (icon != null)
                          ? Icon(
                              icon,
                              size: AppTextSize.large *
                                  MediaQuery.of(context).size.width,
                            )
                          : Container(
                              width: AppTextSize.large *
                                  MediaQuery.of(context).size.width,
                              child: Image.asset(
                                'assets/images/badges/BadgeSmallBlackL4.png',
                              )),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          color: AppTextColor.black,
                          fontWeight: AppTextWeight.medium,
                          fontSize: AppTextSize.medium *
                              MediaQuery.of(context).size.width,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
