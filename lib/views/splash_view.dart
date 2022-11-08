import 'dart:async';
import 'package:attendance_system_flutter_mobile/views/login_view.dart';
import 'package:attendance_system_flutter_mobile/views/signup-view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool alreadyUsed = false;
  void getData() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    alreadyUsed = prefs.getBool("alreadyUsed") ?? false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return LogInView();
            })));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 56, 54, 54),
        body: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              width: 150,
              height: 150,
              child: Image.asset('assets/images/logo.jpg'),
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                    "Attendance App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Image(
                    width: 200,
                    height: 200,
                    image: AssetImage("assets/images/loading.gif")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
