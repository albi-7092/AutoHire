// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Password extends StatefulWidget {
  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController Password = TextEditingController();

  TextEditingController cnfPassword = TextEditingController();
  String doc_id = '';
  String user_password = '';
  String email = '';

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    Initial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 30),
            child: Text(
              'Change Password',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "You'll be logged out of all sessions except this one to protect your account if anyone is try to gain access.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(
                "Your password must be at least 6 characters and should include a combination of numbers, letters and special characters."),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 30, right: 10),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is madatory';
                        } else if (value.length < 8) {
                          return 'password should be greater than 8 letters';
                        } else {
                          return null;
                        }
                      },
                      controller: Password,
                      decoration: InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value != Password.text) {
                          return 'password should be same';
                        } else {
                          return null;
                        }
                      },
                      controller: cnfPassword,
                      decoration: InputDecoration(
                          labelText: 'Re-type New Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30))),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 360,
            height: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF17203A),
                ),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    if (user_password.isNotEmpty && email.isNotEmpty) {
                      Sighncnf();
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> Initial() async {
    final sh = await SharedPreferences.getInstance();
    final sv = sh.getString('doc_id');
    doc_id = sv.toString();
    try {
      firestore
          .collection('USER')
          .doc(doc_id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        setState(() {
          user_password = documentSnapshot.get('password');
          email = documentSnapshot.get('email');
        });
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> Sighncnf() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: user_password);
      changepasswords();
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('Auto Hire')),
            content: Text(
              '$e',
              // style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        },
      );
    }
  }

  Future<void> changepasswords() async {
    try {
      final User? user = auth.currentUser;
      await user!.updatePassword(cnfPassword.text);
      final DocumentReference document =
          firestore.collection('USER').doc(doc_id);
      document.update({'password': cnfPassword.text});
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('Auto Hire')),
            content: const Text(
              'password updated sucessfully',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(ctx).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('Auto Hire')),
            content: Text(
              '$e',
              // style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        },
      );
    }
  }
}
