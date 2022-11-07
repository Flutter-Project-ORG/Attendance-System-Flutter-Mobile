import 'dart:convert';

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
  Barcode? result;
  void qr(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((event) async {
      print(event);

// /subjects-students/$insId/$subId
      /// TO DO: Attendance
      if (event.code == null) return;
      controller.pauseCamera();

      final key = encrypt.Key.fromUtf8(Constants.encryptKey);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter
          .decrypt(encrypt.Encrypted.fromBase64(event.code.toString()), iv: iv);
      Map data = jsonDecode(decrypted) as Map;
      DatabaseReference ref = FirebaseDatabase.instance.ref(
          "subjects-students/${data["insId"]}/${data["subId"]}/${FirebaseAuth.instance.currentUser!.uid}");
      await ref
          .set({"studentName": FirebaseAuth.instance.currentUser!.displayName});

      // ref = FirebaseDatabase.instance
      //     .ref("students/${FirebaseAuth.instance.currentUser!.uid}/subjects");
      // await ref.update(jsonEncode( data["subId"]));
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
              child: QRView(
                  key: _gLobalkey,
                  onQRViewCreated: qr,
                  overlay: QrScannerOverlayShape()),
            ),
            Center(
              child: (result != null)
                  ? Text(
                      '${result!.code}',
                      style: TextStyle(
                          color: CustomColors.lightSecondaryColor,
                          fontSize: 25),
                    )
                  : Text(
                      'Scan a code',
                      style: TextStyle(
                          color: CustomColors.lightSecondaryColor,
                          fontSize: 25),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
