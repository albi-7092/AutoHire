import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/Account.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password_verification.dart';

class change_password extends StatefulWidget {
  @override
  State<change_password> createState() => _change_passwordState();
}

class _change_passwordState extends State<change_password> {
  String user_password = '';
  String doc_id = '';
  String email = '';

  TextEditingController currentpassword = TextEditingController();

  TextEditingController newpassword = TextEditingController();

  TextEditingController new_password = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
            Navigator.of(context).pop(MaterialPageRoute(builder: (ctx) {
              return account();
            }));
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Color(0xFF17203A),
        title: Text('Change Password'),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Change Password",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "You'll be logged out of all sessions except this one to protect your account if anyone is try to gain access.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 20),
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
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (ctx) {
                                  return forgot_password_verification();
                                }));
                              },
                              child: Text(
                                'Forgot your password ?',
                                style: TextStyle(color: Colors.red),
                              )),
                        ),
                      ],
                    ),
                  ],
                )),
          )
        ],
      )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shape: CircularNotchedRectangle(),
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
                  backgroundColor: Color(0xFF17203A),
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
                              title: Center(child: Text('Auto Hire')),
                              content: Text(
                                'Wrong password',
                                // style: TextStyle(color: Colors.red),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Text('OK'))
                              ],
                            );
                          });
                    }
                  }
                },
                child: Text('Submit'),
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
                // style: TextStyle(color: Colors.red),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('OK'))
              ],
            );
          });
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
              title: Center(child: Text('Auto Hire')),
              content: Text(
                'password updated sucessfully',
                // style: TextStyle(color: Colors.red),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(ctx).pop();
                    },
                    child: Text('OK'))
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Center(child: Text('Auto Hire')),
              content: Text(
                '$e',
                // style: TextStyle(color: Colors.red),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('OK'))
              ],
            );
          });
    }
  }
}
