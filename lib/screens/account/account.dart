import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/screens/account/widgets/settings_card.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_collector/formats/text.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenLight,
      appBar: AppBar(
        backgroundColor: kGreenDark,
        centerTitle: true,
        title: Text(
          'Account',
          style: kAppBarTitle,
        ),
      ),
      //TODO could swap this to StreamProvider
      body: StreamBuilder<FirebaseUser>(
          stream: Provider.of<UserAuth>(context).getCurrentUser().asStream(),
          builder:
              (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (!snapshot.hasData) return new Text('...');
            return ListView(
              children: <Widget>[
                SizedBox(height: 3.0),
                SettingsCard(
                  onSubmit: null,
                  cardLabel: 'Name',
                  cardText: snapshot.data.displayName,
                  allowDialog: false,
                  dialogText: null,
                ),
                SettingsCard(
                  onSubmit: () {
                    Provider.of<UserAuth>(context).userUpdateEmail(
                        email: Provider.of<CloudDB>(context).newDataInput);
                  },
                  cardLabel: 'Email',
                  cardText: snapshot.data.email,
                  dialogText: 'Please provide an updated email address.',
                ),
                SettingsCard(
                  onSubmit: () {
                    bool result = Provider.of<UserAuth>(context)
                        .validatePassword(
                            Provider.of<CloudDB>(context).newDataInput);
                    if (result == true) {
                      Provider.of<UserAuth>(context).userUpdatePassword(
                          password: Provider.of<CloudDB>(context).newDataInput);
                      Navigator.pop(context);
                    } else {}
                  },
                  cardLabel: 'Password',
                  cardText: 'Update Password',
                  dialogText:
                      'Your password must have a capital letter, small letter, number, and special character. You will not be able to update otherwise.',
                ),
              ],
            );
          }),
    );
  }
}
