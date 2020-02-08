import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_collector/formats/text.dart';
import 'package:plant_collector/models/data_types/user_data.dart';
import 'package:plant_collector/models/user.dart';
import 'package:plant_collector/screens/login/widgets/login_template.dart';
import 'package:provider/provider.dart';
import 'package:plant_collector/screens/login/widgets/input_card.dart';
import 'package:plant_collector/models/cloud_db.dart';
import 'package:plant_collector/screens/login/widgets/button_auth.dart';
import 'package:plant_collector/widgets/dialogs/dialog_confirm.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginTemplate(
      leadingGraphic: Image(
        image: AssetImage('assets/images/logo.png'),
        height: 160 * MediaQuery.of(context).size.width * kScaleFactor,
      ),
      children: <Widget>[
        InputCard(
          keyboardType: TextInputType.emailAddress,
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
            return Column(
              children: <Widget>[
                InputCard(
                  keyboardType: TextInputType.text,
                  cardPrompt: userAuth.passwordHelper == false
                      ? 'Ensure your password has at least 8 characters.'
                          '\n\nIt must contain a special character, capital letter, small letter, and number.'
                      : 'Create a secure password',
                  obscureText: true,
                  onChanged: (input) {
                    userAuth.validatePassword(input);
                    userAuth.password = input;
                  },
                ),
                SizedBox(height: 20.0),
                InputCard(
                  keyboardType: TextInputType.text,
                  cardPrompt: 'Please confirm your password',
                  obscureText: true,
                  onChanged: (input) {
//                userAuth.validatePassword(input);
                    userAuth.passwordValidate = input;
                  },
                ),
              ],
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
              Provider.of<CloudDB>(context).addUserDocument(
                  data: UserData(
                    id: user.uid,
                    email: user.email,
                  ).toMap(),
                  userID: user.uid);
              //show dialog to update user
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogConfirm(
                    title: 'Account Created',
                    text:
                        'Next you\'ll receive an email from us to verify your account.\n\n'
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
                        'We had trouble registering you. Please check the email and password you provided and try again.'
                        '${Provider.of<UserAuth>(context).error != null ? Provider.of<UserAuth>(context).error : ''}',
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
    );
  }
}
