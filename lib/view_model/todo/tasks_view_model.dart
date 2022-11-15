import 'package:attendance_system_flutter_mobile/res/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TasksViewModel {


  Future<void> deleteTask(BuildContext context,String taskId)async{
    final NavigatorState navigator = Navigator.of(context);
    try{
      String studentId = FirebaseAuth.instance.currentUser!.uid;
      final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref('notes/$studentId/$taskId');
      await dbRef.remove();
      navigator.pop();
      Components.showSuccessSnackBar(context, text: 'Task deleted.');
    }catch(_){
      navigator.pop();
      Components.showErrorSnackBar(context, text: 'Try again.');
    }
  }
  
  Future<void> makeTaskCompleted(BuildContext context,String taskId)async{
    final NavigatorState navigator = Navigator.of(context);
    try{
      String studentId = FirebaseAuth.instance.currentUser!.uid;
      final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref('notes/$studentId/$taskId');
      await dbRef.update({
        'isFinished':true,
      });
      navigator.pop();
      Components.showSuccessSnackBar(context, text: 'Task updated.');
    }catch(_){
      navigator.pop();
      Components.showErrorSnackBar(context, text: 'Try again.');
    }
  }

}