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
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 135, 246, 217),
        selectedItemColor: Colors.blue,
        iconSize: 30,
        selectedFontSize: 13,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "scan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile"),
        ],
      ),
    );
  }
}
