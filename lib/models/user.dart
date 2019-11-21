import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuth extends ChangeNotifier {
  //Variables
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String email;
  String password;
  FirebaseUser signedInUser;
  bool showPasswordReset;
  int signInAttempts;
  bool passwordHelper;

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

  //PASSWORD CONTENTS
  //One Capital Letter, One Small Letter, One Number, One Special
  bool validatePasswordContents(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$';
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

  //*****************USER METHODS*****************

  //REGISTER THE USER
  Future<FirebaseUser> userRegister() async {
    if (email != null && passwordHelper == true) {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      signedInUser = result.user;
      email = null;
      password = null;
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
      signInAttempts >= 2
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

  //SIGN OUT USER
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
