import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/animal_provider.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Animal Tag'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) async {
              if (!_isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                if (code != null) {
                  setState(() {
                    _isScanning = false;
                  });
                  _handleScannedCode(code);
                }
              }
            },
          ),
          // Scanner Overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (!_isScanning)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _handleScannedCode(String tagId) async {
    try {
      final animal = await Provider.of<AnimalProvider>(context, listen: false)
          .getAnimalByTagId(tagId);
      
      if (mounted) {
        context.pushReplacement('/animal-detail', extra: animal);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Animal not found: $tagId'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () {
                setState(() {
                  _isScanning = true;
                });
              },
            ),
          ),
        );
        setState(() {
          _isScanning = true;
        });
      }
    }
  }
}
