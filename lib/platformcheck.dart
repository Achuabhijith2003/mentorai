import 'package:flutter/material.dart';
import 'package:mentorai/Screens/Auth/login.dart';
import 'package:mentorai/Screens/home.dart';
import 'package:mentorai/Screens/onboard/onboard.dart';
import 'package:mentorai/provider/authprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class Platformcheck extends StatelessWidget {
  const Platformcheck({super.key});

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context, listen: false);
    final platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.android) {
      return FutureBuilder<bool>(
        future: isOnboardingComplete(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final onboardingDone = snapshot.data!;
          if (!onboardingDone) {
            return const EdenOnboardingView();
          } else if (authProvider.userid != null) {
            return const Home();
          } else {
            return const SignInView();
          }
        },
      );
    } else if (platform == TargetPlatform.windows) {
      if (authProvider.userid != null) {
        return const Home();
      } else {
        return const SignInView();
      }
    } else if (platform == TargetPlatform.fuchsia) {
      if (authProvider.userid != null) {
        return const Home();
      } else {
        return const SignInView();
      }
    } else if (kIsWeb) {
      if (authProvider.userid != null) {
        return const Home();
      } else {
        return const SignInView();
      }
    } else {
      return const Center(
        child: Text('Unsupported platform', style: TextStyle(fontSize: 24)),
      );
    }
  }
}
