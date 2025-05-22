import 'package:flutter/material.dart';
import 'package:mentorai/provider/authprovider.dart';
import 'package:provider/provider.dart';
import 'package:mentorai/Screens/Teacher/home.dart';
import 'package:mentorai/Screens/Student/home.dart';
import 'package:mentorai/Screens/Auth/login.dart';

class Checkuser extends StatelessWidget {
  const Checkuser({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context, listen: false);
    return FutureBuilder(
      future: authProvider.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: \\${snapshot.error}')),
          );
        }
        final userData = snapshot.data as Map<String, dynamic>?;
        if (userData == null) {
          // User data not found, go to login
          return const SignInView();
        }
        // You may want to check a specific field, e.g. 'Catagories' or 'role'
        final String? cat = userData['role']?.toString().toLowerCase();
        debugPrint('User role: \\${userData['role']} (cat: \\${cat})');
        if (cat != null && cat == 'teacher') {
          debugPrint('User is a teacher');
          return const Thome();
        } else {
          debugPrint('User is a Student');
          return const Shome();
        }
      },
    );
  }
}
