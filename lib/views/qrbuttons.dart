import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../api/attendanceapi.dart';

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
                  child: Text('Attendance OUT'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => AttendanceOUT())));
                  }))
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
  attendancein() {
    final service = AttendanceServices();

    service.apiCallAttendance(
      {
        "in_time": DateTime.now(),
        "out_time": "0",
      },
    ).then((value) {
      if (value.error != null) {
        print("get data >>>>>> " + value.error!);

        const snackbar = SnackBar(content: Text('Attendance Sent'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    });
  }

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
                  ? ElevatedButton(
                      onPressed: () {
                        attendancein();
                      },
                      child: Text('Send IN Attendance'))
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

class AttendanceOUT extends StatefulWidget {
  const AttendanceOUT({super.key});

  @override
  State<AttendanceOUT> createState() => _AttendanceOUTState();
}

class _AttendanceOUTState extends State<AttendanceOUT> {
  attendanceout() {
    final service = AttendanceServices();

    service.apiCallAttendance(
      {
        "in_time": "0",
        "out_time": DateTime.now(),
      },
    ).then((value) {
      if (value.error != null) {
        print("get data >>>>>> " + value.error!);
      }
    });
    const snackbar = SnackBar(content: Text('Attendance Sent'));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

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
        title: Text('Attendance OUT'),
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
                  ? ElevatedButton(
                      onPressed: () {
                        attendanceout();
                      },
                      child: Text('Send OUT Attendance'))
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
