import 'package:evernotes/Widgets/navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'SCREENS/FirstScreen.dart';
import 'SCREENS/Projectscreen/CamScanner.dart';
import 'SCREENS/Projectscreen/LoginScreen.dart';
import 'SCREENS/Projectscreen/Profile_data.dart';

//main functions projects start executions here this staring point of the project
Future <void> main()async {
  
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: SplashScreenView(
      navigateRoute:Screeen1(),
    duration: 4000,
    imageSize: 130,
    imageSrc: "asset/LOGO.png",
    text: "RECEIPT EASIER ",
    textType: TextType.TyperAnimatedText,
    textStyle: TextStyle(
    fontSize: 30.0,
    ),
 backgroundColor: Color(0xff64CF64),
      ));
  }
}

