import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/screens/login/widgets/input_card.dart';
import 'package:plant_collector/models/classes.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/screens/login/widgets/button_auth.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      builder: (context) => AppData(),
      child: Scaffold(
        backgroundColor: kGreenLight,
        body: ListView(
          children: <Widget>[
            SizedBox(height: 30.0),
            Image(
              image: AssetImage('assets/images/logo.png'),
              height: 160 * MediaQuery.of(context).size.width * kTextScale,
            ),
            SizedBox(height: 10.0),
            Text(
              'Plant Collector',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTextSize.huge * MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            InputCard(
              cardPrompt: 'Enter your email address',
              onChanged: (input) {
                Provider.of<UserAuth>(context).email = input;
              },
              validator: (input) {
                String response;
                if (Provider.of<UserAuth>(context).email.contains('@')) {
                  response = 'Please double check your email';
                }
                return response;
              },
            ),
            SizedBox(height: 20.0),
            Consumer<UserAuth>(
              builder: (context, userAuth, child) {
                return InputCard(
                  cardPrompt: userAuth.passwordHelper == false
                      ? 'Ensure your password has at least 8 characters.'
                          '\n\nIt must contain a special character, capital letter, small letter, and number.'
                      : 'Password',
                  obscureText: true,
                  onChanged: (input) {
                    userAuth.validatePassword(input);
                    userAuth.password = input;
                  },
                );
              },
            ),
            SizedBox(height: 20.0),
            ButtonAuth(
              text: 'Register',
              onPress: () async {
                FirebaseUser user =
                    await Provider.of<UserAuth>(context).userRegister();
                //create DB entry for user
                if (user != null) {
                  //send email verification
                  Provider.of<UserAuth>(context).userSendEmail();
                  //TODO likely remove this no need for secondary user db
                  Provider.of<CloudDB>(context).addDocument(
                    data: User(
                      userID: user.uid,
                      userEmail: user.email,
                    ).toMap(),
                    userID: user.uid,
                  );
                  //show dialog to update user
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogConfirm(
                        title: 'Account Created',
                        text:
                            'You\'re almost there!  Soon you\'ll receive an email from us to verify your account.  '
                            'Then you can get started building your first plant Collection!',
                        buttonText: 'OK',
                        onPressed: () {
                          Navigator.pop(context);
                          //send to login page
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogConfirm(
                        title: 'Sign in Issue',
                        text:
                            'We had trouble registering you. Please check your email and password and try again',
                        buttonText: 'OK',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }
              },
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
