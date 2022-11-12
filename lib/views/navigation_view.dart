import 'package:attendance_system_flutter_mobile/res/colors.dart';
import 'package:attendance_system_flutter_mobile/views/news_view.dart';
import 'package:attendance_system_flutter_mobile/views/profile_view.dart';
import 'package:attendance_system_flutter_mobile/views/qr_home_select.dart';
import 'package:attendance_system_flutter_mobile/views/qr_attendance_view.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavView extends StatefulWidget {
  const NavView({super.key});

  @override
  State<NavView> createState() => _NavViewState();
}

class _NavViewState extends State<NavView> {
  int currentIndex = 0;

  final screens = [
    Container(
      child: NewsView(),
    ),
    Container(
      child: qr_home(),
    ),
    Container(
      child: ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(
              icon: Icon(Icons.home),
              title: 'Home',
            ),
            TabItem(icon: Icon(Icons.qr_code), title: 'QR'),
            TabItem(icon: Icon(Icons.person), title: 'Profile'),
          ],
          initialActiveIndex: 0, //optional, default as 0
          onTap: updateIndex,
          backgroundColor: CustomColors.lightBgColor,
          activeColor: CustomColors.darkPrimaryColor,
        ),
      ),
    );
  }

  void updateIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }
}
