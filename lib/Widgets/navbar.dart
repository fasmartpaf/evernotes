
import 'package:evernotes/SCREENS/Projectscreen/Homepage.dart';
import 'package:evernotes/SCREENS/Projectscreen/Profile_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Home1 extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home1> {

  String _scanBarcode = 'Unknown';
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
    });
  }

final screen=[
  const Home(),
  const Profiles(),
];

int currentIndex=0;

void _settingModalBottomSheet(context){
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Wrap(
          children: <Widget>[
           ListTile(
                leading:  const Icon(Icons.scanner),
                title:  const Text('Bar Code'),
                onTap: () => {
                  scanBarcodeNormal()
                }
            ),
            ListTile(
              leading:  const Icon(Icons.qr_code_scanner),
              title:  const Text('Qr Code'),
              onTap: () => {

                scanQR()
              },
            ),
          ],
        );
      }
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.qr_code_scanner),

        onPressed: () {
          _settingModalBottomSheet(context);
        },


      ),
      extendBody: true,
      body: screen[currentIndex],
      bottomNavigationBar:BottomNavigationBar(
        elevation: 100,
        currentIndex: currentIndex,
        onTap: (index)=>setState(() {
          currentIndex=index;
        }),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),

          BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile'),
        ],
      )


    );
  }
}


