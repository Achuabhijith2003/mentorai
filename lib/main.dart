import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mentorai/Screens/onboard/onboard.dart';
import 'package:mentorai/provider/authprovider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding
  await Firebase.initializeApp(); // Initialize Firebase

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
      home: EdenOnboardingView(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
    );
  }
}
