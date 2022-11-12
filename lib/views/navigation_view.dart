import 'package:attendance_system_flutter_mobile/res/colors.dart';
import 'package:attendance_system_flutter_mobile/views/news_view.dart';
import 'package:attendance_system_flutter_mobile/views/profile_view.dart';
import 'package:attendance_system_flutter_mobile/views/qr_method_select_view.dart';
import 'package:attendance_system_flutter_mobile/trash/qr_attendance_view.dart';
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
    const NewsView(),
    const QrMethodSelectView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: ConvexAppBar(
          elevation: 24.0,
          items: const [
            TabItem(
              icon: Icon(Icons.home),
              title: 'Home',
            ),
            TabItem(
              icon: Icon(Icons.qr_code),
              title: 'QR',
            ),
            TabItem(
              icon: Icon(Icons.person),
              title: 'Profile',
            ),
          ],
          initialActiveIndex: 0,
          onTap: updateIndex,
          backgroundColor: Theme.of(context).canvasColor,
          activeColor: Theme.of(context).colorScheme.secondary,
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
