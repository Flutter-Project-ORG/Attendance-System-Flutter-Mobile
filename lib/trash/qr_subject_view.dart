import 'dart:convert';
import 'dart:developer';

import 'package:attendance_system_flutter_mobile/res/colors.dart';
import 'package:attendance_system_flutter_mobile/res/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class QraViewsubject extends StatefulWidget {
  const QraViewsubject({
    super.key,
  });

  @override
  State<QraViewsubject> createState() => _QraViewsubjectState();
}

class _QraViewsubjectState extends State<QraViewsubject> {
  final GlobalKey _gLobalkey = GlobalKey();
  late final String title;
  QRViewController? controller;
  String? result;

  void qr(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((event) async {
      /// TO DO: Add Subject
      if (event.code == null) return;
      controller.pauseCamera();
      final key = encrypt.Key.fromUtf8(Constants.encryptKey);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(event.code.toString()), iv: iv);
      Map<String, dynamic> data = jsonDecode(decrypted) as Map<String, dynamic>;

      DatabaseReference sRef =
          FirebaseDatabase.instance.ref("students/${FirebaseAuth.instance.currentUser!.uid}/subjects");
      final DataSnapshot test = await sRef.get();
      List? studentSubject = test.value as List?;
      if (studentSubject != null && studentSubject.contains(data["subId"])) {
        setState(() {
          result = 'You already have this subject';
        });
        return;
      }
      studentSubject ??= [];
      studentSubject = studentSubject.toList();
      studentSubject.add(data["subId"]);
      await sRef.set(studentSubject);
      DatabaseReference ssRef = FirebaseDatabase.instance
          .ref("subjects-students/${data["insId"]}/${data["subId"]}/${FirebaseAuth.instance.currentUser!.uid}");
      await ssRef.set({
        "studentName": FirebaseAuth.instance.currentUser!.displayName,
      });

      setState(() {
        result = 'Added successfully';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add subject"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              width: 400,
              child: QRView(key: _gLobalkey, onQRViewCreated: qr, overlay: QrScannerOverlayShape()),
            ),
            Center(
              child: (result != null)
                  ? Text(
                      '${result}',
                      style: TextStyle(color: CustomColors.lightSecondaryColor, fontSize: 25),
                    )
                  : Text(
                      'Scan a code',
                      style: TextStyle(color: CustomColors.lightSecondaryColor, fontSize: 25),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: result!=null? FloatingActionButton.extended(
        onPressed: () {
          controller!.resumeCamera();
          setState(() {
            result = null;
          });
        },
        label: const Text('Scan again'),
        icon: const Icon(Icons.qr_code_2),
      ):null,
    );
  }
}
