import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mentorai/platformcheck.dart';
import 'package:provider/provider.dart';
import 'package:mentorai/provider/authprovider.dart';
import 'package:mentorai/firebase_options.dart';
import 'package:mentorai/models/teachermodels.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase

  runApp(
    ChangeNotifierProvider(
      create: (_) => Authprovider(),
      child: const MentorAI(),
    ),
  );
}

class MentorAI extends StatelessWidget {
  const MentorAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      home: Platformcheck(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
    );
  }
}
