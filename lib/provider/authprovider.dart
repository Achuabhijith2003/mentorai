import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authprovider extends ChangeNotifier {
  // get userid => authid;
  // sign with google
  signinwithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('Google sign-in aborted');
        return false;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      print('Signed in with Google: ${userCredential.user?.email}');
      notifyListeners();
      return true;
    } catch (e) {
      print('Error signing in with Google: $e');
      return false;
    }
  }

  signinwithEmailandPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('Signed in as: ${userCredential.user?.email}');
      return true;
    } catch (e) {
      print('Error signing in: $e');
      return false;
    }
  }

  signout() {
    try {
      // Sign out from Google
      GoogleSignIn().signOut();
      FirebaseAuth.instance.signOut();
      print('Signed out successfully');
      return true;
    } catch (e) {
      print('Error signing out: $e');
      return false;
    }
  }

signupwithEmailandPassword(String email, String password ) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('Signed up as: ${userCredential.user?.email}');
      return true;
    } catch (e) {
      print('Error signing up: $e');
      return false;
    }
  }

}
