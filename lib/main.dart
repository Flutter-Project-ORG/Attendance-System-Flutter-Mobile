import 'package:attendance_system_flutter_mobile/views/on_boarding_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'res/colors.dart';
import 'views/navigation_view.dart';
import 'views/auth_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isFirstTime});

  final bool isFirstTime;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Attendance',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        fontFamily: 'JosefinSans',
        canvasColor: CustomColors.lightBgColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: CustomColors.lightPrimaryColor,
          secondary: CustomColors.lightSecondaryColor,
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: CustomColors.lightTextColor,
            fontSize: 24.0,
          ),
          bodyText2: TextStyle(
            color: CustomColors.lightTextColor,
            fontSize: 20.0,
          ),
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'JosefinSans',
        canvasColor: CustomColors.darkBgColor,
        iconTheme: const IconThemeData(
          color: CustomColors.darkPrimaryColor,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: CustomColors.darkPrimaryColor,
          secondary: CustomColors.darkSecondaryColor,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: CustomColors.darkTextColor,
            fontSize: 24.0,
          ),
          headline2: TextStyle(
            color: CustomColors.darkTextColor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
          headline3: TextStyle(
            color: CustomColors.darkTextColor,
            fontSize: 24.0,
            letterSpacing: 1.0,
          ),
          bodyText1: TextStyle(
            color: CustomColors.darkTextColor,
            fontSize: 24.0,
          ),
          bodyText2: TextStyle(
            color: CustomColors.darkTextColor,
            fontSize: 20.0,
          ),
          labelMedium: TextStyle(
            color: CustomColors.darkTextColor,
            fontSize: 18.0,
          ),
        ),
      ),
      home: isFirstTime
          ? const OnBoardingView()
          : user == null
              ? const AuthView()
              : const NavView(),
    );
  }
}
