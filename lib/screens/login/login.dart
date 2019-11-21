import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/colors.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/app_data.dart';
import 'package:plant_collector/widgets/stateful_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/screens/login/widgets/input_card.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/screens/login/widgets/button_auth.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        Provider.of<UserAuth>(context).signInAttempts = 0;
      },
      child: Scaffold(
        backgroundColor: kGreenLight,
        body: ListView(
          children: <Widget>[
            SizedBox(height: 30.0),
            Container(
              height: 160.0 * MediaQuery.of(context).size.width * kTextScale,
              width: 160.0 * MediaQuery.of(context).size.width * kTextScale,
              child: FlareActor('assets/animations/grow_border.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "Grow"),
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
              cardPrompt: 'Enter your email',
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
            Consumer<UserAuth>(builder: (context, userAuth, child) {
              return userAuth.showPasswordReset == true
                  ? FlatButton(
                      child: Text(
                        'Email Password Reset?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppTextSize.medium *
                              MediaQuery.of(context).size.width,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogConfirm(
                              title: 'Password Reset',
                              text: 'Send an email to reset your password?',
                              buttonText: 'Yes',
                              onPressed: () {
                                Provider.of<UserAuth>(context)
                                    .sendPasswordReset();
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                    )
                  : Container();
            }),
            InputCard(
              cardPrompt: 'Password',
              obscureText: true,
              onChanged: (input) {
                Provider.of<UserAuth>(context).password = input;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            ButtonAuth(
              text: 'Sign in',
              onPress: () async {
                //log user in
                FirebaseUser user =
                    (await Provider.of<UserAuth>(context).loginUser());
                //check if verified
                bool verified =
                    Provider.of<UserAuth>(context).userIsVerified(user: user);
                //if user is logged in and verified
                if (user != null && verified == true) {
                  String userID = user.uid;
                  Provider.of<AppData>(context).setUserID(userIDString: userID);
                  Provider.of<CloudDB>(context).userID = userID;
                  Provider.of<AppData>(context).createDirectories(user: userID);
                  //have to sent to loading first to then sent to route and initiate first stream
                  Navigator.pushNamed(context, 'loading');
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogConfirm(
                        title: 'Sign in Issue',
                        text:
                            'We had trouble signing you in. Please make sure your email and password are correct.'
                            '\n\nIf you recently registered, please respond to the email we sent you.',
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
            Padding(
              padding: EdgeInsets.all(20.0),
              child: FlatButton(
                child: Text(
                  'Register a new account',
                  style: TextStyle(
                    color: kGreenMedium,
                    fontSize:
                        AppTextSize.small * MediaQuery.of(context).size.width,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'register');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
