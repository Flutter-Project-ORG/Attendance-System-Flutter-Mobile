import 'package:flutter/material.dart';

import 'qr_camera_view.dart';

class QrMethodSelectView extends StatefulWidget {
  const QrMethodSelectView({super.key});

  @override
  State<QrMethodSelectView> createState() => _QrMethodSelectViewState();
}

class _QrMethodSelectViewState extends State<QrMethodSelectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                  'assets/images/attendance_img.png'),
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context,MaterialPageRoute(
                      builder:(_) => const QrCameraView(isToAttend: true)
                  ));
                },
                child: const Text("Scan QR to attend"),),
            Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
              child: Image.asset(
                  'assets/images/add_subject_img.png'),
            ),
            ElevatedButton(
              onPressed:(){
                Navigator.push(context,MaterialPageRoute(
                    builder:(_) => const QrCameraView(isToAttend: false)
                ));
              },
              child: const Text("Scan QR to register subject"),
            ),
            const SizedBox(
              height: 32.0,
            ),
          ],
        ),
      ),
    );
  }
}
