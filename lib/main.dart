import 'package:flutter/material.dart';
import 'package:mentorai/Screens/onboard/onboard.dart';

void main(List<String> args) {
  runApp(MentorAI());
}

class MentorAI extends StatelessWidget {
  const MentorAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: EdenOnboardingView());
  }
}
