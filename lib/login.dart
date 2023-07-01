import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './register.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String dox = '';

  Future<void> SighnIn(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text);

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('USER')
          .where('email', isEqualTo: email.text)
          .get();
      if (snapshot.size > 0) {
        dox = snapshot.docs[0].id;
      }
      print('doc_id:$dox');
      if (dox != '' || dox != null) {
        login_Save();

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
          return HOME();
        }));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('user not found');
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Center(child: Text('Auto Hire')),
                content: Text(
                  'user not found',
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
      } else if (e.code == 'wrong-password') {
        print('wrong password');
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Center(child: Text('Auto Hire')),
                content: Text(
                  'wrong password',
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
            }); //SHOWd
      } else {
        print('invalid email id');
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Center(child: Text('Auto Hire')),
                content: Text(
                  'Invalid Email ID',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          //width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,

          width: double.infinity,
          height: double.infinity,
          //color: Color.fromARGB(255, 255, 61, 2),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: SizedBox(
                            width: 450,
                            height: 250,
                            child: Image.asset("images/logo.jpeg")),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: "Email id"),
                        validator: (value) {
                          if (value == '') {
                            return 'Enter a valid email id';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.security),
                            hintText: "password"),
                        validator: (value) {
                          if (value == '') {
                            return 'Enter a valid password';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: SizedBox(
                        width: 360,
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF17203A)),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                SighnIn(context);
                              }
                            },
                            child: Text("Login")),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Column(
                        children: [
                          Text("Forgot your login details?"),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Get help",
                                style: TextStyle(color: Color(0xFF17203A)),
                              ))
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 10),
                    //   child: Text("or",
                    //       style: TextStyle(color: Color(0xFF17203A))),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   child: TextButton(
                    //       onPressed: () {},
                    //       child: Text(
                    //         'Click Here',
                    //         style: TextStyle(color: Color(0xFF17203A)),
                    //       )),
                    // )
                  ],
                  // ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 95),
          child: Row(
            children: [
              Text("Don't have an account ?"),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return register();
                    }));
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Color(0xFF17203A)),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login_Save() async {
    final sh = await SharedPreferences.getInstance();
    await sh.setString(
      'doc_id',
      dox,
    );
  }
}
