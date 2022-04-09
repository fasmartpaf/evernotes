import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evernotes/Model/currentUser.dart';
import 'package:evernotes/SCREENS/Projectscreen/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class Profiles extends StatefulWidget {
  const Profiles({Key? key}) : super(key: key);

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {


  PickedFile? image;
  Future getImage() async {

      image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 100);

      setState(() {

      });

  }
  final Stream<QuerySnapshot> _userstream =
      FirebaseFirestore.instance.collection('Users').where('password',
          isEqualTo: currentUser.id).snapshots();
 User ? user=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _userstream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Padding(
                    padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
                    child: Center(child: Text('Something went wrong')));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                    padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.lightBlueAccent,
                      backgroundColor: Colors.red,
                    )));
              }

              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(children: [
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 70),
                        child: Column(
                          children: [
                            Text(
                              'Profile',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: (){
                                 getImage();
                              },
                              child: const Center(
                                child: CircleAvatar(

                                 child:ClipOval(
                                    // child:Image.file(File(image!.path), height: 130,
                                    //     width: 130, fit: BoxFit.cover, alignment: Alignment.center),
                                 ),
                                  radius: 40,
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(snapshot.data?.docs[index].get('firstname') + snapshot.data?.docs[index].get('lastname')),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        color: Colors.white,
                        child: Column(
                          children: const [
                            Divider(
                              height: 3,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ListTile(
                              title: Text(
                                'Profile',
                                textScaleFactor: 1.5,
                              ),
                            ),
                            Divider(
                              height: 0,
                            ),
                            ListTile(
                              title: Text('Change your details'),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                            Divider(
                              height: 0,
                            ),
                            ListTile(
                              title: Text('Summary'),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                            Divider(
                              height: 0,
                            ),
                            ListTile(
                              title: Text('Currency'),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                            Divider(
                              height: 0,
                            ),
                            ListTile(
                              title: Text('Setting'),
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'Sign Out/Change Account',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        trailing: IconButton(
                          onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInScreen()));
                            },

                          icon: Icon(Icons.logout),
                        ),
                        ),
                      ),
                    ]);
                  });
            }),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.home),
      //         label: 'Home',
      //         backgroundColor: Colors.green),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.qr_code_scanner),
      //         label: 'Scanner',
      //         backgroundColor: Colors.green),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.settings),
      //         label: 'Setting',
      //         backgroundColor: Colors.green),
      //   ],
      // ),
    ));
  }
}


