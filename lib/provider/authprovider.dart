import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authprovider extends ChangeNotifier {
  get userid => FirebaseAuth.instance.currentUser?.uid;
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

      // Create user in Firestore with image URL
      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('mentoruser').doc(user.uid).set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'uid': user.uid,
          'Catagories': '', // Set default or fetch if needed
          'role': '', // Set default or fetch if needed
          'imageUrl': user.photoURL ?? '',
        }, SetOptions(merge: true));
      }

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

  signupwithEmailandPassword(
    String email,
    String password,
    String name,
    String catagories,
    String role,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('Signed up as: ${userCredential.user?.email}');
      // After successful signup, create user in Firestore
      await createuserdb(
        name,
        email,
        userCredential.user?.uid ?? '',
        catagories,
        role,
      );
      return true;
    } catch (e) {
      print('Error signing up: $e');
      return false;
    }
  }

  createuserdb(
    String name,
    String email,
    String userid,
    String catagories,
    String role,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('mentoruser').doc(userid).set(
        {'name': name, 'email': email, 'uid': userid, 'Catagories': catagories, 'role': role},
      );
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

 passwordrecovery(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    print('Password reset email sent');
    return true;
  } catch (e) {
    print('Error sending password reset email: $e');
    return false;
  }
}

  getUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('mentoruser')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          return doc.data();
        } else {
          print('User document does not exist');
          return null;
        }
      } else {
        print('No user is currently signed in');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

}
