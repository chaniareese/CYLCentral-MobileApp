// This file has moved to lib/screens/admin/qr_scanner_screen.dart

import 'package:flutter/material.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Scanner')),
      body: const Center(
        child: Text('QR Code Scanner for on-site attendance.'),
      ),
    );
  }
}
