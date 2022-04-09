import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evernotes/Model/currentUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'LoginScreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _scanBarcode = 'Unknown';
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  void initState() {
// data!=user1;
    super.initState();
    getname();
    getAllUsers('');
  }

  String? name;
  String? id;
  getname() async {
    final shared = await SharedPreferences.getInstance();
    setState(() {
      name = shared.getString('name');
      id = shared.getString('id');
    });
  }

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
      firebaseFirestore.collection('Receipt').add({
        'qrcode': _scanBarcode,
        'date': DateTime.now(),
        'type': 'QR Code',
        'id': currentUser.id,
      });
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
      firebaseFirestore.collection('Receipt').add({
        'qrcode': _scanBarcode,
        'date': DateTime.now(),
        'type': 'Bar Code',
        'id': currentUser.id,
      });
    });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.scanner),
                  title: const Text('Bar Code'),
                  onTap: () => {scanBarcodeNormal()}),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('Qr Code'),
                onTap: () => {scanQR()},
              ),
            ],
          );
        });
  }
  late QuerySnapshot<Map<String, dynamic>> firebaseUsersResult;
  void getAllUsers(String val) async {
    firebaseUsersResult = await FirebaseFirestore.instance
        .collection('Receipt')
        .orderBy('date')
        .startAt([val.capitalize]).endAt([val.capitalize! + '\uf8ff']).get();


  }

  final Stream<QuerySnapshot> _userstream = FirebaseFirestore.instance
      .collection('Receipt')
      .where('id', isEqualTo: currentUser.id)
      .snapshots();
  User? user = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Receipt').snapshots();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.green,
                    floating: true,
                    pinned: true,
                    snap: false,
                    centerTitle: true,
                    title: Text('Receipts/Transactions'),
                    leading: Image.asset('asset/LOGO.png'),
                    actions: [

                      IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () {
                          FirebaseAuth user =
                              FirebaseAuth.instance.signOut() as FirebaseAuth;
                          if (user.signOut() !=
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LogInScreen()))) ;
                        },
                      ),
                    ],
                    bottom: AppBar(
                      backgroundColor: Colors.green,
                      title: Container(
                        width: double.infinity,
                        height: 40,
                        color: Colors.white,
                        child:  Center(
                          child: TextField(
                            onChanged: (val) {
                              print(val);
                              getAllUsers(val);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search for something',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Other Sliver Widgets
                  SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(
                          height: 500,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _usersStream,
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }

                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text("Loading");
                              }

                              return ListView(
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                  return Container(
                                    margin: const EdgeInsets.only(left: 30.0,right: 30),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: myBoxDecoration(),
                                    height: 130,
                                    child: Card(
                                      child: Column(
                                        children: [

                                          Text(data['qrcode']),
                                          SizedBox(height: 10,),
                                          Text(data['type']),
                                          SizedBox(height: 10,),

                                          Text(data['date'].toDate().toString().substring(0,16))
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          )
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              height: 50,
              child: FlatButton(
                color: Colors.green,
                child: Text(
                  'Add a new receipt',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  _settingModalBottomSheet(context);
                },
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }
}
