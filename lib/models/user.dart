import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class UserAuth extends ChangeNotifier {
  //Variables
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email;
  String password;
  String passwordValidate;
  FirebaseUser signedInUser;
  bool showPasswordReset;
  int signInAttempts;
  bool passwordHelper;
  bool match;
  String error;

  //*****************HELPERS*****************

  //EXPOSE THE INSTANCE
  FirebaseAuth exposeFirebaseInstance() {
    return _firebaseAuth;
  }

  //*****************PASSWORD CHECKS*****************

  //PASSWORD VALIDATE
  //One Capital Letter, One Small Letter, One Number, One Special
  bool validatePassword(String password) {
    bool contents = validatePasswordContents(password);
    bool length = validatePasswordLength(password);
    contents && length == true ? passwordHelper = true : passwordHelper = false;
    notifyListeners();
    return passwordHelper;
  }

  //check for matching passwords
//  bool matchPasswords(String input) {
//    match = (password == input) ? true : false;
//    return match;
//  }

  //PASSWORD CONTENTS
  //One Capital Letter, One Small Letter
  bool validatePasswordContents(String password) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\/$&*~.]).{8,}$';
//    (?=.*?[0-9])
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(password);
  }

  //PASSWORD LENGTH
  bool validatePasswordLength(String password) {
    bool state;
    if (password != null) {
      password.length >= 8 ? state = true : state = false;
    } else {
      state = false;
    }
    return state;
  }

  //*****************GOOGLE SIGN IN*****************//

  //validate app for google sign in console.developers.google.com/apis
  //plant collector, settings, android, add fingerprint
  //SIGN IN THE USER WITH GOOGLE
//  Future<FirebaseUser> signInWithGoogle() async {
//    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//    final GoogleSignInAuthentication googleSignInAuthentication =
//        await googleSignInAccount.authentication;
//
//    //generate token
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleSignInAuthentication.accessToken,
//      idToken: googleSignInAuthentication.idToken,
//    );
//
//    //now generate a firebase user from the retrieved credentials
//    final AuthResult authResult =
//        await _firebaseAuth.signInWithCredential(credential);
//    final FirebaseUser user = authResult.user;
//
//    assert(!user.isAnonymous);
//    assert(await user.getIdToken() != null);
//
//    signedInUser = await _firebaseAuth.currentUser();
//    assert(user.uid == signedInUser.uid);
//
//    return signedInUser;
//  }

//  void signOutGoogle() async {
//    await googleSignIn.signOut();
//  }

  //*****************USER METHODS*****************//

  //REGISTER THE USER
  Future<FirebaseUser> userRegister() async {
    if (email != null &&
        passwordHelper == true &&
        password == passwordValidate) {
      try {
        AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        try {
          signedInUser = result.user;
          email = null;
          password = null;
        } catch (e) {
          print(e);
        }
      } catch (e) {
        print(e);
        if (e.toString().contains('EMAIL_ALREADY_IN_USE')) {
          error = '\n\nEMAIL ALREADY IN USE';
        }
      }
    } else {
      signedInUser = null;
    }
    return signedInUser;
  }

  //LOG THE USER IN
  Future<FirebaseUser> loginUser() async {
    AuthResult result;
    try {
      result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      signedInUser = result.user;
      showPasswordReset = false;
      signInAttempts = 0;
      email = null;
      password = null;
    } catch (e) {
      signInAttempts++;
      signInAttempts >= 1
          ? showPasswordReset = true
          : showPasswordReset = false;
      print(e);
    }
    return signedInUser;
  }

  //GET CURRENT USER
  Future<FirebaseUser> getCurrentUser() async {
    signedInUser = await _firebaseAuth.currentUser();
    print('getCurrentUser: Complete');
    return signedInUser;
  }

  //SIGN OUT USER
  Future<void> signOutUser() async {
    signedInUser = null;
    return _firebaseAuth.signOut();
  }

  //SEND PASSWORD RESET
  Future<void> sendPasswordReset() async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  //SEND EMAIL FOR VERIFICATION
  Future<void> userSendEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  //UPDATE PASSWORD
  Future<void> userUpdatePassword({@required String password}) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.updatePassword(password);
  }

  //UPDATE EMAIL
  Future<void> userUpdateEmail({@required String email}) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.updateEmail(email);
  }

  //DELETE ACCOUNT
  Future<void> userDelete() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.delete();
  }

//CHECK IF EMAIL HAS BEEN VERIFIED
  bool userIsVerified({@required FirebaseUser user}) {
    bool verified;
    if (user != null) {
      verified = user.isEmailVerified;
    } else {
      verified = false;
    }
    return verified;
  }

  //END OF SECTION
}
