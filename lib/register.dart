import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Home.dart';

class register extends StatefulWidget {
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  TextEditingController Name = TextEditingController();

  TextEditingController user_Name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  TextEditingController passwordconfirm = TextEditingController();

  TextEditingController age = TextEditingController();
  String AGE = '';

  TextEditingController DL_No = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String doc = '';
  //
  CollectionReference user01 = FirebaseFirestore.instance.collection('USER');
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> add_user(BuildContext context) async {
    final data = {
      'name': Name.text,
      'user_name': user_Name.text,
      'password': passwordconfirm.text,
      'email': email.text,
      'dl_no': DL_No.text,
      'age': age.text,
      'doc_id': '',
      'car_book_id': '',
      'status': '',
    };
    try {
      await auth.createUserWithEmailAndPassword(
          email: email.text, password: passwordconfirm.text);

      await user01.add(data).then((value) {
        doc = value.id;
        print(doc);
      });
      final DocumentReference document = firestore.collection('USER').doc(doc);
      document.update({'doc_id': doc});
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => HOME()), (route) => false);
      register_save();
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

    // DocumentReference documentRef = user01.doc(doc);
    // documentRef.update({'doc_id': doc});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 10, top: 20),
                          child: Row(
                            children: [
                              Column(
                                children: const [
                                  Text(
                                    'Here to Get',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Welcomed !',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 25, right: 10),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.person),
                                  hintText: 'Name *'),
                              controller: Name,
                              validator: (value) {
                                if (value == '') {
                                  return 'This field is mandatory';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.person),
                                  hintText: 'User name*'),
                              controller: user_Name,
                              validator: (value) {
                                if (value == '') {
                                  return 'This field is mandatory';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'email id',
                                  suffixIcon: Icon(Icons.email)),
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == '') {
                                  return 'This field is mandatory';
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.info),
                                  hintText: 'Age *'),
                              controller: age,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                AGE = age.text;
                                if (value == '') {
                                  return 'This field is mandatory';
                                } else if (int.parse(AGE) < 17 ||
                                    int.parse(AGE) > 90) {
                                  return 'age is restricted';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                            child: TextFormField(
                              obscureText: true,
                              validator: (value) {
                                if (value == '') {
                                  return 'password * is mandatory';
                                } else if (value!.length < 8) {
                                  return 'password should be greater than 8 letters';
                                }
                              },
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.security),
                                  labelText: 'password'),
                              controller: password,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.security),
                                  labelText: 'Re-type password'),
                              controller: passwordconfirm,
                              validator: (value) {
                                if (value == '') {
                                  return 'password * is mandatory';
                                } else if (value!.length < 8) {
                                  return 'password should be greater than 8 letters';
                                } else {
                                  if (value != password.text) {
                                    return 'password * should be same';
                                  } else {
                                    return null;
                                  }
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                            child: TextFormField(
                              validator: (value) {
                                if (value == '') {
                                  return 'Field is required';
                                }
                              },
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.drive_eta),
                                  hintText: 'Lisense.No '),
                              controller: DL_No,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: SizedBox(
                              width: 360,
                              height: 40,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF17203A)),
                                  onPressed: () {
                                    if (_formkey.currentState!.validate()) {
                                      add_user(context);
                                    } else {
                                      //else
                                    }
                                  },
                                  child: Text('Register')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35, bottom: 10),
                    child: Text('Already Registered ?'),
                  ),
                ],
              ),
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: TextButton(
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(builder: (ctx) {
                return login();
              }));
            },
            child: Text(
              "Sign In",
              style: TextStyle(color: Color(0xFF17203A)),
            )),
      ),
    );
  }

  Future<void> register_save() async {
    final sh = await SharedPreferences.getInstance();
    await sh.setString(
      'doc_id',
      doc,
    );
  }
}
