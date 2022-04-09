import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evernotes/Model/currentUser.dart';
import 'package:evernotes/SCREENS/Projectscreen/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstnameController=TextEditingController();
  TextEditingController lastnamecontroller=TextEditingController();
  @override
  void initState() {
nameController.clear();
passwordController.clear();
firstnameController.clear();
lastnamecontroller.clear();
super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 0, 50, 0),
                child: CircleAvatar(
                  backgroundColor: Color(0xff64CF64),
                  radius: 80,
                  child: ClipOval(
                    child: Image.asset('asset/LOGO.png'),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Create an account',
                  style: TextStyle(fontSize: 20),
                ),
              ), ///first Name field
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: TextFormField(
                    controller: firstnameController,
                    onSaved: (value){
                      value=firstnameController.text;
                    },
                    onChanged: (value){
                      value=firstnameController.text;
                    },
                    validator: (value){
                      value=firstnameController.text;
                    },
                    decoration: InputDecoration(
                        fillColor: Color(0xffffBEF3BE),
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: "first name",
                        labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),///last Name field
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: TextFormField(
                    controller: lastnamecontroller,
                    onSaved: (value){
                      value=firstnameController.text;
                    },
                    onChanged: (value){
                      value=lastnamecontroller.text;
                    },
                    validator: (value){
                      value=lastnamecontroller.text;
                    },
                    decoration: InputDecoration(
                        fillColor: Color(0xffffBEF3BE),
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: "last name",
                        labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: TextFormField(
                  onChanged: (value) {
                    value = nameController.text;
                  },
                  validator: (value) {
                    value = nameController.text;
                  },
                  autocorrect: true,
                  enableSuggestions: true,
                  controller: nameController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.greenAccent,
                      ),
                      fillColor: Color(0xffBEF3BE),
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: ' EMAIL',
                      labelStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        inherit: true,
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),  ///password field
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: TextFormField(
                  onSaved: (value){
                    value=passwordController.text;
                  },
                  obscureText: true,
                  onChanged: (value) {
                    value = passwordController.text;


                  },
                  validator: (value) {
                    value = passwordController.text;
                  },
                  autocorrect: true,
                  enableSuggestions: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.greenAccent,
                      ),
                      fillColor: Color(0xffBEF3BE),
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: ' PASSWORD',
                      labelStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                        decorationColor: Colors.white60,
                        inherit: true,
                      )),
                ),
              ),
              SizedBox(
                height: 10,
              ),///confirmpassword
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: TextFormField(
                    decoration: InputDecoration(


                        fillColor: Color(0xffffBEF3BE),
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: "verify password",
                        prefixIcon: Icon(Icons.lock,
                          color: Colors.greenAccent,

                        ),

                        labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                        )),
                  ),
                ),
              ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(45, 10, 45, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Colors.green,
                                child: FlatButton(
                                  onPressed: () async {

                                    if (passwordController.text.length <= 5) {
                                      Fluttertoast.showToast(
                                          msg: 'Plaease Enter password with 6 character');
                                    }
                                    if (nameController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'Please Enter Valid Email');
                                    }
                                    try {



                                      var user =
                                      await _auth.createUserWithEmailAndPassword(
                                        email: nameController.text,
                                        password: passwordController.text,
                                      );
                                      final shared= await SharedPreferences.getInstance();
                                      if (user != null) {
                                            shared.setString('name',firstnameController.text);
                                            shared.setString('name',user.user!.uid);
                                        currentUser.id=user.user!.uid;
                                        currentUser.name=firstnameController.text;
                                        await _firestore.collection('Users').add({
                                          'firstname':firstnameController.text,
                                          'lastname':lastnamecontroller.text,
                                          'email':nameController.text,
                                           'password':user.user!.uid,
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (contex) => LogInScreen()));
                                      }
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                  child: Text(
                                    'Create an account',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),


    );
  }
}
