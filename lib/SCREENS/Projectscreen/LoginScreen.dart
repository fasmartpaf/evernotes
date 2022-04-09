import 'package:evernotes/Model/currentUser.dart';
import 'package:evernotes/Widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

class LogInScreen extends StatefulWidget {
  @override
  State<LogInScreen> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<LogInScreen> {
  String email = '';
  String password = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    nameController.clear();
    passwordController.clear();
    super.initState();
  }

  @override
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
                  backgroundColor: Color(0xff73F073),
                  radius: 150,
                  child: ClipOval(
                    child: Image.asset('asset/LOGO.png'),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
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
                  prefixIcon: Icon(Icons.person,color: Colors.greenAccent,),
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
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
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
                      prefixIcon: Icon(Icons.lock,color: Colors.greenAccent,),

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
              Container(


                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),

                                )
                            )
                        ),
                        child: const Text(
                          'Sign In',
                          style:
                              TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                        ),
                        onPressed: () async {
                          if (passwordController.text.length <= 5) {
                            Fluttertoast.showToast(
                                msg: 'Plaease Enter password with 6 character');
                          }
                          if (nameController.text.isEmpty) {
                            Fluttertoast.showToast(msg: 'Please Enter Valid Email');
                          }
                          try {
                            var user = await _auth.signInWithEmailAndPassword(
                                email: nameController.text,
                                password: passwordController.text);
                            if (user != null) {
                              currentUser.name=user.user!.displayName;
                              currentUser.id=user.user!.uid;


                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (contex) =>
                                      Home1()));
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                      ),
                    ],
                  )),
            ],
          )),
    );
  }
}
