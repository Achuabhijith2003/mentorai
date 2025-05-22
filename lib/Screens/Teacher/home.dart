import 'package:flutter/material.dart';
import 'package:mentorai/Screens/Auth/login.dart';
import 'package:mentorai/provider/authprovider.dart';
import 'package:provider/provider.dart';
import 'package:mentorai/Screens/components/design.dart';

class Thome extends StatefulWidget {
  const Thome({super.key});

  @override
  State<Thome> createState() => _ThomeState();
}

class _ThomeState extends State<Thome> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home-Teacher"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Handle logout action
              bool sucess = await authProvider.signout();
              if (sucess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInView()),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WaveCard(height: 350, color: Colors.blue.withOpacity(0.15)),
          Center(
            child: Text("Welcome to MentorAI", style: TextStyle(fontSize: 24)),
          ),
          // Add more widgets here as needed
        ],
      ),
    );
  }
}
