import 'dart:convert';
import 'dart:developer';

import 'package:attendance_system_flutter_mobile/res/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../res/constants.dart';

class QrAttendanceView extends StatefulWidget {
  const QrAttendanceView({
    super.key,
  });

  @override
  State<QrAttendanceView> createState() => _QrAttendanceViewState();
}

class _QrAttendanceViewState extends State<QrAttendanceView> {
  final GlobalKey _gLobalkey = GlobalKey();
  late final String title;
  QRViewController? controller;
  String? result;

  void qr(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((event) async {
      /// TO DO: Attendance
      if (event.code == null) return;
      controller.pauseCamera();
      try {
        final key = encrypt.Key.fromUtf8(Constants.encryptKey);
        final iv = encrypt.IV.fromLength(16);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));
        final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(event.code.toString()), iv: iv);
        Map<String, dynamic> data = jsonDecode(decrypted) as Map<String, dynamic>;
        if (!data.containsKey('path') || !data.containsKey('randomNum') || !data.containsKey('lecId')) {
          setState(() {
            result = 'Try again';
          });
          return;
        }
        DatabaseReference randomRef = FirebaseDatabase.instance.ref("lectures-temp/${data['lecId']}");
        final randomNum = await randomRef.get();
        if (randomNum.value.toString() != data['randomNum']) {
          setState(() {
            result = 'Try again';
          });
          return;
        }
        DatabaseReference ref =
            FirebaseDatabase.instance.ref("attendance/${data['path']}/${FirebaseAuth.instance.currentUser!.uid}");
        final x = await ref.get();
        ref.update({
          'isAttend': true,
        });
        setState(() {
          result = 'Successful';
        });
      } catch (e) {
        setState(() {
          result = 'Try again';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Attendance"),
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
                      '${result!}',
                      style: TextStyle(color: CustomColors.lightSecondaryColor, fontSize: 25),
                    )
                  : Text(
                      'Scan a code',
                      style: TextStyle(color: CustomColors.lightSecondaryColor, fontSize: 25),
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: result != null
          ? FloatingActionButton.extended(
              onPressed: () {
                controller!.resumeCamera();
                setState(() {
                  result = null;
                });
              },
              label: const Text('Scan again'),
              icon: const Icon(Icons.qr_code_2),
            )
          : null,
    );
  }
}
