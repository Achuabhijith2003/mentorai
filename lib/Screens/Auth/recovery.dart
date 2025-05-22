import 'package:flutter/material.dart';
import 'package:mentorai/Assets/image.dart';
import 'package:mentorai/Screens/components/buttons.dart';
import 'package:mentorai/Screens/components/design.dart';
import 'package:mentorai/Screens/components/textfields.dart';
import 'package:mentorai/provider/authprovider.dart';
import 'package:provider/provider.dart';

class Recovery extends StatefulWidget {
  const Recovery({super.key});

  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  TextEditingController recovercontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<Authprovider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text("Account Recovery")),
      body: Stack(
        children: [
          WaveCard(),
          Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 24.0, right: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Enter your email address to receive password recovery instructions.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Center(
                  child: Image.asset(
                    AppImages.kOnboarding2,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                AuthField(
                  controller: recovercontroller,
                  hintText: "Enter Email",
                ),
                const SizedBox(height: 16),
                Center(
                  child: PrimaryButton(
                    onTap: () {
                      if (recovercontroller.text.isNotEmpty) {
                        authprovider.passwordrecovery(
                          recovercontroller.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Check your email for recovery instructions",
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a valid email"),
                          ),
                        );
                      }
                    },
                    text: "Send to Email",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
