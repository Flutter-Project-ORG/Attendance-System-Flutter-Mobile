import 'package:flutter/material.dart';

import 'res/colors.dart';
import 'views/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        canvasColor: CustomColors.lightBgColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: CustomColors.lightPrimaryColor,
          secondary: CustomColors.lightSecondaryColor,
        ),
      ),
      darkTheme: ThemeData(
        canvasColor: CustomColors.darkBgColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: CustomColors.darkPrimaryColor,
          secondary: CustomColors.darkSecondaryColor,
        ),
      ),
      home: const HomeView(),
    );
  }
}
