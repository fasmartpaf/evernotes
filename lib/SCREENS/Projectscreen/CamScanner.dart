import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evernotes/Model/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CamScanner extends StatefulWidget {
  const CamScanner({Key? key}) : super(key: key);

  @override
  State<CamScanner> createState() => _CamScannerState();
}

class _CamScannerState extends State<CamScanner> {
  File? images;
  String _scanBarcode = 'Unknown';
  FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  @override
  void initState() {
// data!=user1;
    super.initState();
    getname();
  }
  String? name;
  String? id;
getname() async {
    final shared= await SharedPreferences.getInstance();
    setState(() {
      name=shared.getString('name');
      id=shared.getString('id');
    });}
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      firebaseFirestore.collection('Receipt').add(
        {
         'qrcode':_scanBarcode,
         'date':DateTime.now(),
         'type':'QR Code',
          'id':currentUser.id,
        }
      );
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      firebaseFirestore.collection('Receipt').add(
          {
            'qrcode':_scanBarcode,
            'date':DateTime.now(),
            'type':'Bar Code',
          'id':currentUser.id,
          }
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              onPressed: () {
                scanQR();
                setState(() {});
              },
              child: Text(_scanBarcode))
        ],
      ),
    );
  }
}
