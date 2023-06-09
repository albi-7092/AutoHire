import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/Splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(app());
}

class app extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login",
      home: splash(),
      theme: ThemeData(
        primaryColor: Color(0xFF17203A),
      ),
      //color: Color(0xFF17203A),
      //theme: ThemeData(primaryColor: Color(0xFF17203A)),
    );
  }
}
