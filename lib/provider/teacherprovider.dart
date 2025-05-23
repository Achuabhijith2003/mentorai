import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Teacherprovider extends ChangeNotifier {
  final user = FirebaseAuth.instance.currentUser;

  get teachname => teachername();

  getTeacherprofile() async {
    try {
      final user = this.user;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
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

  teachername() async {
    try {
      final user = this.user;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('mentoruser')
                .doc(user.uid)
                .get();
        if (doc.exists) {
          return doc.data()!['name'];
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
