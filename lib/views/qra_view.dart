import 'package:attendance_system_flutter_mobile/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QraView extends StatefulWidget {
  const QraView({
    super.key,
  });

  @override
  State<QraView> createState() => _QraViewState();
}

class _QraViewState extends State<QraView> {
  final GlobalKey _gLobalkey = GlobalKey();
  late final String title;
  QRViewController? controller;
  Barcode? result;
  void qr(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((event) {
      setState(() {
        result = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QRA"),
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
