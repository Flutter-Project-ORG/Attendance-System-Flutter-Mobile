import 'package:attendance_system_flutter_mobile/res/components.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helper/notify.dart';

class AddTaskViewModel {
  Future<void> addTask(BuildContext context,{
    required String title,
    required String note,
    required DateTime date,
    required TimeOfDay start,
    required TimeOfDay end,
    required int remind,
  }) async {
    if(title.isEmpty){
      Components.showErrorSnackBar(context, text: 'You must insert a title.');
      return;
    }
    if(note.isEmpty){
      Components.showErrorSnackBar(context, text: 'You must insert a note text.');
      return;
    }
    String studentId = FirebaseAuth.instance.currentUser!.uid;
    NavigatorState navigator = Navigator.of(context);
    showDialog(context: context, builder: (context){
      return const Center(child: CircularProgressIndicator());
    });
    try{
      final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref('notes/$studentId');
      await dbRef.push().set({
        'title':title,
        'note':note,
        'date':DateFormat('dd/MM/yyyy').format(date),
        'start':start.format(context),
        'end':end.format(context),
        'isFinished':false,
      });
      navigator.pop();
      navigator.pop();
    }catch(_){
      navigator.pop();
      Components.showErrorSnackBar(context, text: 'Something wrong. Try again.');
    }

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
