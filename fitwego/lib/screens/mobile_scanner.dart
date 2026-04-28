import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../theme/app_theme.dart';

class BarcodeScannerPage extends StatefulWidget {
  final Function(String code)? onDetect;

  const BarcodeScannerPage({super.key, this.onDetect});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Scan Barcode"),
      ),
      body: Stack(
        children: [
          /// ✅ FIXED SCANNER (NEW API)
          MobileScanner(
            onDetect: (BarcodeCapture capture) {
              if (scanned) return;

              final List<Barcode> barcodes = capture.barcodes;

              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;

                if (code != null) {
                  scanned = true;

                  if (widget.onDetect != null) {
                    widget.onDetect!(code);
                  }

                  Navigator.pop(context);
                  break;
                }
              }
            },
          ),

          /// 🎯 SCAN BOX OVERLAY
          Center(
            child: Container(
              width: 250,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.primaryBlue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}