// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'login.dart';
import './Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    start(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Image.asset("images/logo.jpeg"),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10, left: 130),
          child: Text('Powered by Auto Hire'),
        ),
      ),
    );
  }

  Future<void> goto(BuildContext context) async {
    final sh = await SharedPreferences.getInstance();
    final sv = sh.getString('doc_id');
    final fg = sh.getString('finger_print');

    if (sv == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
        return Login();
      }));
    } else if (sv.isNotEmpty && fg != 'true') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
        return HOME();
      }));
    } else if (sv.isNotEmpty && fg == 'true') {
      try {
        final authenticated = await auth.authenticate(
          localizedReason: 'Auto Hire',
        );

        if (authenticated) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (ctx) {
            return HOME();
          }));
        }
      } catch (e) {
        print('Error during fingerprint authentication: $e');
      }
    }
  }

  void start(BuildContext context) {
    Future.delayed(const Duration(seconds: 1, microseconds: 5), () {
      goto(context);
    });
  }
}
