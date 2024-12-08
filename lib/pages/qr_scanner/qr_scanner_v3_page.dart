import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tracking_app_v1/models/responseTypes/user_profile.dart';
import 'package:tracking_app_v1/pages/account/user_profile_page.dart';
import 'package:tracking_app_v1/pages/common/home_page.dart';
import 'package:tracking_app_v1/pages/products/product_detail_page.dart';
import 'package:tracking_app_v1/utils/qr_decode.dart';

class QRScannerV3Page extends StatefulWidget {
  @override
  State<QRScannerV3Page> createState() => _QRScannerV3PageState();
}

class _QRScannerV3PageState extends State<QRScannerV3Page> {
  MobileScannerController controller = MobileScannerController();
  bool isProcessing = false; // Prevent multiple scans at once

  // Simulated navigation function
  void navigateToDetailPage(String type, String key) {
    Navigator.pop(context); // Close the dialog
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ));

    // Navigator.pop(context); // Close the dialog

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Navigating to $type detail...")),
    );
    // Add navigation logic here
    switch (type) {
      case "product":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailPage(productId: key)));
        break;
      case "user":
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(
                  userProfile: UserProfile(id: key, fullName: "", email: "")),
            ));
        break;
      default:
        break;
    }
  }

  void processScanResult(String? result) {
    if (result == null || isProcessing) return;

    isProcessing = true; // Lock processing to prevent duplicate handling

    print("Got result: $result");

    var data = QrDecode.DecodeQRString(result);

    if (data.isNotEmpty) {
      print("Data is: ${data.keys.first} value ${data.values.first}");
    }

    if (data.isNotEmpty) {
      final type = data.keys.first; // "product" or "user"
      final uuid = data.values.first; // Extracted UUID
      controller.stop();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Scanned a $type profile'),
          content: const Text('Do you want to view the details?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.start();
                isProcessing = false; // Unlock processing
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
            TextButton(
              onPressed: () {
                navigateToDetailPage(type, uuid);
                isProcessing = false; // Unlock processing
                controller.start();
              },
              child: Text('View Details',
                  style: TextStyle(color: Colors.blue[500])),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Scanned result doesn't match expected format!")),
      );
      isProcessing = false; // Unlock processing
      controller.start();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Scan '),
            Icon(Icons.document_scanner)
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,

            // : false, // Avoid duplicate scanning
            onDetect: (capture) {
              final Barcode? barcode = capture.barcodes.firstOrNull;
              if (barcode != null) {
                processScanResult(barcode.rawValue);
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const Text(
                  //   'Point the camera at a QR or barcode',
                  //   style: TextStyle(color: Colors.white, fontSize: 16),
                  // ),
                  // const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      controller.stop();
                      Navigator.pop(context);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.keyboard_arrow_left, color: Colors.black,),
                        const Text(' Back', style: TextStyle(color: Colors.black, fontSize: 16),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
