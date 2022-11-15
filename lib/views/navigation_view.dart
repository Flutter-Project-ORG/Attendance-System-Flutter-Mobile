import 'package:flutter/material.dart';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:provider/provider.dart';

import '../view_model/todo/tasks_view_model.dart';
import 'news_view.dart';
import 'profile_view.dart';
import 'qr/qr_method_select_view.dart';
import 'todo/tasks_view.dart';

class NavView extends StatefulWidget {
  const NavView({super.key,this.isNotifiy});

  final bool? isNotifiy;

  @override
  State<NavView> createState() => _NavViewState();
}

class _NavViewState extends State<NavView> {
  int currentIndex = 0;

  final screens = [
    const NewsView(),
    const QrMethodSelectView(),
    const TasksView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    if(widget.isNotifiy == true){
      currentIndex = 2;
    }
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
              icon: Icon(Icons.notification_add),
              title: 'TO DO',
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
