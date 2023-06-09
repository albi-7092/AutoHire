import 'package:flutter/material.dart';
import 'package:login/Home.dart';
import 'package:login/login.dart';
import 'package:login/passcode_verification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash extends StatefulWidget {
  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    goto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(
          child: Image.asset("images/logo.jpeg"),
        ),
      )),
    );
  }

  Future<void> goto() async {
    await Future.delayed(Duration(seconds: 2));
    final sh = await SharedPreferences.getInstance();
    final sv = sh.getString('doc_id');
    final ps = sh.getString('passcode');
    if (sv == null || sv.isEmpty) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
        return login();
      }));
    } else {
      if (ps == null || ps.isEmpty) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
          return HOME();
        }));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
          return passcode_verification(ps.toString());
        }));
      }
      //print(sv);
    }
  }
}
