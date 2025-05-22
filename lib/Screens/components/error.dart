import 'package:flutter/material.dart';

class Errorbottom extends StatefulWidget {
  const Errorbottom({super.key});

  @override
  State<Errorbottom> createState() => _ErrorbottomState();
}

class _ErrorbottomState extends State<Errorbottom> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Center(
        child: Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text('Error', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
