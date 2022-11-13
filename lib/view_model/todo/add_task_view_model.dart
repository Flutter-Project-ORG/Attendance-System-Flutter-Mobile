import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../../helper/notify.dart';

class AddTaskViewModel {
  Future<void> addTask({
    required String title,
    required String note,
    required DateTime date,
    required TimeOfDay start,
    required int remind,
  }) async {
    int remindInSeconds = remind * 60;
    DateTime currentDate = DateTime.now();
    DateTime realDate = DateTime(date.year,date.month,date.day,start.hour,start.minute);
    int secondRemain = realDate.difference(currentDate).inSeconds - remindInSeconds;
    if(secondRemain < 5){
      secondRemain = 5;
    }
    Notify.instance.createNotification(title: title, note: note, interval: secondRemain);
  }
}
