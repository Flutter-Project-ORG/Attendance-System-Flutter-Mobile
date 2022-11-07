import 'package:attendance_system_flutter_mobile/views/login_view.dart';
import 'package:attendance_system_flutter_mobile/views/onBoarding_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'res/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// Ideal time to initialize
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
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
      home: const Log_in(),
    );
  }
}
