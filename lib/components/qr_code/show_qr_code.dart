import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

void showQRCode(BuildContext context, String data) {
  //generate qr code
  // await Future.delayed(const Duration(microseconds: 500));

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(2),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        content: QRCodeView(
          data: data,
        )),
  );
}

class QRCodeView extends StatefulWidget {
  final String data;
  const QRCodeView({super.key, required this.data});

  @override
  State<QRCodeView> createState() => _QRCodeViewState();
}

class _QRCodeViewState extends State<QRCodeView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 300,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100
              // image: const DecorationImage(
              //     image: AssetImage("assets/images/test/qrgg.png"))
              ),
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey.shade700, width: 2)),
            child: PrettyQrView.data(
                data: widget.data,
                decoration:
                    PrettyQrDecoration(background: Colors.grey.shade50)),
          ),
        ),
      ],
    );
  }
}
