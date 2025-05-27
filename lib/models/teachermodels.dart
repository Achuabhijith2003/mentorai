import 'package:mentorai/Assets/image.dart';
import 'package:flutter/material.dart';
import 'package:mentorai/Screens/Teacher/addsub.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  void navigateToAddSubject() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => const AddSubjectPage()),
    );
  }
}

class Tmenu {
  String title;
  String image;
  final Function()? ontap;
  Tmenu({required this.title, required this.image, this.ontap});
}

List<Tmenu> tmenuList = [
  Tmenu(
    title: 'Add Subject',
    image: AppImages.kTeacher,
    ontap: NavigationService().navigateToAddSubject,
  ),
  Tmenu(title: 'My Profile', image: AppImages.kTeacher),
  Tmenu(title: 'My Courses', image: AppImages.kTeacher),
  Tmenu(title: 'My Students', image: AppImages.kTeacher),
  Tmenu(title: 'My Payments', image: AppImages.kTeacher),
  Tmenu(title: 'Settings', image: AppImages.kTeacher),
];
