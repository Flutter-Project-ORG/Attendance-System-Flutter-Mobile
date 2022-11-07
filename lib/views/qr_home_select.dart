import 'package:attendance_system_flutter_mobile/views/qr_subject_view.dart';

import 'package:attendance_system_flutter_mobile/views/qr_attendance_view.dart';
import 'package:flutter/material.dart';

class qr_home extends StatefulWidget {
  const qr_home({super.key});

  @override
  State<qr_home> createState() => _qr_homeState();
}

class _qr_homeState extends State<qr_home> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: (() {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return QrAttendanceView();
                })));
              }),
              child: Text("scan QR to take attendance")),
          ElevatedButton(
              onPressed: (() {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return QraViewsubject();
                })));
              }),
              child: Text("scan QR to Add subject"))
        ],
      ),
    );
  }
}
