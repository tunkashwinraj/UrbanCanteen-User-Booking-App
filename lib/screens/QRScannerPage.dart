import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  final String? orderId;

  QRScanner({this.orderId});

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Stack(
        children: [
          _buildScannerView(),
        ],
      ),
    );
  }

  Widget _buildScannerView() {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
      cameraFacing: CameraFacing.back,
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _handleScannedData(scanData.code);
    });
  }



  void _handleScannedData(String? qrData) async {
    if (qrData == null) {
      print('Error: QR data is null');
      return;
    }

    if (qrData != 'sdfdsfdsf23r32') { // Change to your fixed QR code
      print('QR code does not match the expected value');
      return;
    }

    try {
      // Retrieve the order document
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('new_orders')
          .doc(widget.orderId)
          .get();

      // Cast order data to Map<String, dynamic>
      Map<String, dynamic>? orderData = orderSnapshot.data() as Map<String, dynamic>?;

      // Check if the order exists and its status is 'New Order'
      if (orderSnapshot.exists && orderData?['status'] == 'New Order') {
        // Update the order status to 'Pending'
        await FirebaseFirestore.instance
            .collection('new_orders')
            .doc(widget.orderId)
            .update({
          'status': 'Pending',
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to Pending'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Invalid order or order status already changed.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error handling scanned data: $e'),
          duration: Duration(seconds: 2),
        ),
      );
      print('Error handling scanned data: $e');
    }
  }



  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
