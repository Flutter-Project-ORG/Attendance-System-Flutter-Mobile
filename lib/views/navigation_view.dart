import 'package:attendance_system_flutter_mobile/res/colors.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class nav extends StatefulWidget {
  const nav({super.key});

  @override
  State<nav> createState() => _navState();
}

class _navState extends State<nav> {
  int currentIndex = 0;

  final screens = [
    Center(
      child: Text("1"),
    ),
    Center(
      child: Text("2"),
    ),
    Center(
      child: Text("3"),
    )
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
