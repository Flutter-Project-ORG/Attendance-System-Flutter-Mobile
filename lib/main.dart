import 'package:attendance_system_flutter_mobile/views/on_boarding_view.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'res/colors.dart';
import 'views/navigation_view.dart';
import 'views/auth_view.dart';
import 'views/todo/notification_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  final prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(isFirstTime: isFirstTime));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isFirstTime});

  final bool isFirstTime;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: (ReceivedAction receivedAction) async {
          Navigator.push(context,MaterialPageRoute(builder: (_) =>  NotificationView(
            title: receivedAction.title!, note: receivedAction.body!,
            time: receivedAction.actionDate!.toIso8601String().split('T')[0],
          )));
    });
    super.initState();
  }

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
        iconTheme: const IconThemeData(
          color: CustomColors.lightPrimaryColor,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: CustomColors.lightPrimaryColor,
          secondary: CustomColors.lightSecondaryColor,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: CustomColors.lightTextColor,
            fontSize: 24.0,
          ),
          headline2: TextStyle(
            color: CustomColors.lightTextColor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
          headline3: TextStyle(
            color: CustomColors.lightTextColor,
            fontSize: 24.0,
            letterSpacing: 1.0,
          ),
          headline4: TextStyle(
            color: CustomColors.lightTextColor,
            fontSize: 18.0,
          ),
          headline5: TextStyle(
            color: CustomColors.lightTextColor,
            fontSize: 16.0,
          ),
          bodyText1: TextStyle(
            color: CustomColors.lightTextColor,
            fontSize: 24.0,
          ),
          bodyText2: TextStyle(
            color: CustomColors.lightTextColor,
            fontSize: 20.0,
          ),
          labelMedium: TextStyle(
            color: CustomColors.lightTextColor,
            fontSize: 18.0,
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
          headline4: TextStyle(
            color: CustomColors.darkTextColor,
            fontSize: 18.0,
          ),
          headline5: TextStyle(
            color: CustomColors.darkTextColor,
            fontSize: 16.0,
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
      home: widget.isFirstTime
          ? const OnBoardingView()
          : user == null
              ? const AuthView()
              : const NavView(),
    );
  }
}
