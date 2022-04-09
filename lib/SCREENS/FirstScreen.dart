import 'package:evernotes/SCREENS/Projectscreen/Register_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Projectscreen/LoginScreen.dart';
class Screeen1 extends StatefulWidget {
  const Screeen1({Key? key}) : super(key: key);

  @override
  State<Screeen1> createState() => _Screeen1State();
}

class _Screeen1State extends State<Screeen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff84ED84),
      body: Column(

        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(70, 50, 50, 60),
            child: CircleAvatar(
              backgroundColor: Color(0xff64CF64),
              radius: 150,
              child: ClipOval(
                child: Image.asset('asset/LOGO.png'),

              ),
            ),
          ),
          const Center(
            child: Text('Making Receipts Esier!',
              style: TextStyle(fontSize: 20,color: Colors.white),),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            height: 60,
            width: 200,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),

              ),
              color: Colors.black,
              child:FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  Register()
                  ));
                },
                child: Text('Create an account',style: const TextStyle(color: Colors.white,fontSize: 18),),
              ),
            ),
          ),
          const Text('or',style: TextStyle(fontSize:30,color: Colors.white),),
          FlatButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                LogInScreen()
            ));
          }, child: const Text('Sign In',style: TextStyle(fontSize: 30,color: Colors.white)))


        ],
      ),
    );
  }
}
