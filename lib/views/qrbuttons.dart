import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrButtons extends StatefulWidget {
  const QrButtons({super.key});

  @override
  State<QrButtons> createState() => _QrButtonsState();
}

class _QrButtonsState extends State<QrButtons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('In/Out'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              child: Text('Attendance IN'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AttendanceIn(),
                    ));
              },
            ),
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                  child: Text('Attendance OUT'), onPressed: () {}))
        ],
      )),
    );
  }
}

class AttendanceIn extends StatefulWidget {
  const AttendanceIn({super.key});

  @override
  State<AttendanceIn> createState() => _AttendanceInState();
}

class _AttendanceInState extends State<AttendanceIn> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance IN'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('${result!.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
