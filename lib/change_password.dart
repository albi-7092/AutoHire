// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/Account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password_verification.dart';

class Change_password extends StatefulWidget {
  @override
  State<Change_password> createState() => _Change_passwordState();
}

class _Change_passwordState extends State<Change_password> {
  TextEditingController currentpassword = TextEditingController();

  TextEditingController newpassword = TextEditingController();

  TextEditingController new_password = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String user_password = '';
  String doc_id = '';
  String email = '';

  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    loaddatainitialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (ctx) {
                  return Account();
                },
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: const Color(0xFF17203A),
        title: const Text('Change Password'),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset("images/image_1.jpeg")),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Change Password",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "You'll be logged out of all sessions except this one to protect your account if anyone is try to gain access.",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 20),
              child: Text(
                  "Your password must be at least 6 characters and should include a combination of numbers, letters and special characters."),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 25, right: 10),
                      child: TextFormField(
                          validator: (value) {
                            if (value == '') {
                              return 'field is required';
                            } else {
                              return '';
                            }
                          },
                          controller: currentpassword,
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          )),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: TextFormField(
                          validator: (value) {
                            if (value == '') {
                              return 'field is required';
                            } else {
                              return null;
                            }
                          },
                          controller: newpassword,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          )),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: TextFormField(
                          validator: (value) {
                            if (value == '') {
                              return 'field is required';
                            } else if (value != newpassword.text) {
                              return 'password should be same*';
                            } else {
                              return null;
                            }
                          },
                          controller: new_password,
                          decoration: InputDecoration(
                            labelText: 'Re-type new Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          )),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) {
                                    return forgot_password_verification();
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot your password ?',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
                    if (currentpassword.text == user_password) {
                      sighnincnf();
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Center(child: Text('Auto Hire')),
                            content: const Text(
                              'Wrong password',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('OK'),
                              )
                            ],
                          );
                        },
                      );
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

  Future<void> loaddatainitialize() async {
    final sh = await SharedPreferences.getInstance();
    final sv = sh.getString('doc_id');
    doc_id = sv.toString();

    try {
      firestore.collection('USER').doc(doc_id).get().then(
        (DocumentSnapshot documentSnapshot) {
          setState(() {
            user_password = documentSnapshot.get('password');
            email = documentSnapshot.get('email');
          });
        },
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> sighnincnf() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email, password: currentpassword.text);
      changepasswords();
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Center(child: Text('Auto Hire')),
            content: Text(
              '$e',
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
      await user!.updatePassword(new_password.text);
      final DocumentReference document =
          firestore.collection('USER').doc(doc_id);
      document.update({'password': new_password.text});
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('Auto Hire')),
            content: const Text(
              'password updated sucessfully',
              // style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('OK'))
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
