import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

class Notify {
  Notify._();

  static final Notify instance = Notify._();

   Future<bool> createNotification(
      {required String title, required String note, required int interval}) async {
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    return awesomeNotifications.createNotification(
      schedule: NotificationInterval(interval: interval, timeZone: localTimeZone),
      content: NotificationContent(
        id: Random().nextInt(1000),
        title: title,
        body: note,
        channelKey: 'basic_channel',
      ),
    );
  }
}
