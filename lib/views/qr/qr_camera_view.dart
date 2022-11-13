import 'package:attendance_system_flutter_mobile/view_model/qr_camera_view_model.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCameraView extends StatefulWidget {
  const QrCameraView({super.key, required this.isToAttend});

  final bool isToAttend;

  @override
  State<QrCameraView> createState() => _QrCameraViewState();
}

class _QrCameraViewState extends State<QrCameraView> {
  final GlobalKey _globalKey = GlobalKey();
  late final String title;
  QRViewController? controller;
  String? result;
  final QrCameraViewModel _viewModel = QrCameraViewModel();

  void qr(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((event) async {
      if (event.code == null) return;
      controller.pauseCamera();
      try {
        String id = FirebaseAuth.instance.currentUser!.uid;
        Map<String, dynamic> data =
            _viewModel.decryptDate(event.code.toString());

        if (widget.isToAttend) {
          if (!data.containsKey('path') ||
              !data.containsKey('randomNum') ||
              !data.containsKey('lecId')) {
            setState(() {
              result = 'Try again';
            });
            return;
          }
          DatabaseReference randomRef =
              FirebaseDatabase.instance.ref("lectures-temp/${data['lecId']}");
          final randomNum = await randomRef.get();
          if (randomNum.value.toString() != data['randomNum']) {
            setState(() {
              result = 'Try again';
            });
            return;
          }
          DatabaseReference ref = FirebaseDatabase.instance.ref(
              "attendance/${data['path']}/$id");
          ref.update({
            'isAttend': true,
          });
          setState(() {
            result = 'You are attend now!';
          });
        } else {
          if (!data.containsKey('subId') ||
              !data.containsKey('subName') ||
              !data.containsKey('insId')) {
            setState(() {
              result = 'Try again';
            });
            return;
          }
          DatabaseReference sRef = FirebaseDatabase.instance.ref(
              "students/$id/subjects/${data["subId"]}");
          final DataSnapshot subForStudent = await sRef.get();
          Map? studentSubject = subForStudent.value as Map?;
          if (studentSubject != null) {
            setState(() {
              result = 'You already have this subject';
            });
            return;
          }
          await sRef.set({
            'insId':data["insId"],
            'subName':data["subName"],
          });
          DatabaseReference ssRef = FirebaseDatabase.instance.ref(
              "subjects-students/${data["insId"]}/${data["subId"]}/$id");
          await ssRef.set({
            "studentName": FirebaseAuth.instance.currentUser!.displayName,
          });

          setState(() {
            result = 'Added successfully';
          });
        }
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
        title:
            Text(widget.isToAttend ? "Scan to Attend" : 'Scan to add subject'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 400,
              width: 400,
              child: QRView(
                key: _globalKey,
                onQRViewCreated: qr,
                overlay: QrScannerOverlayShape(),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: (result != null)
                  ? Text(
                      result!,
                      style: Theme.of(context).textTheme.headline3,
                    )
                  : Text(
                      'Scan a code',
                      style: Theme.of(context).textTheme.headline3,
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
