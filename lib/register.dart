// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_import
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool load = false;
  bool stat = true;
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
    setState(() {
      load = true;
    });
    final data = {
      'name': Name.text,
      'user_name': user_Name.text,
      'password': passwordconfirm.text,
      'email': email.text,
      'dl_no': DL_No.text,
      'age': age.text,
      'doc_id': '',
      'car_book_id': '',
      'profile_img_url': '',
      'status': '',
    };
    try {
      await auth.createUserWithEmailAndPassword(
          email: email.text, password: passwordconfirm.text);

      await user01.add(data).then(
        (value) {
          doc = value.id;
          print(doc);
        },
      );
      final DocumentReference document = firestore.collection('USER').doc(doc);
      document.update({'doc_id': doc});
      register_save();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => HOME()), (route) => false);
      setState(() {
        load = false;
      });
    } on Exception catch (e) {
      setState(() {
        load = false;
      });
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
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 20),
                    child: Row(
                      children: [
                        Column(
                          children: [
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
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 25, right: 10),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
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
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
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
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'email id',
                              suffixIcon: Icon(Icons.email)),
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
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
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.info), hintText: 'Age *'),
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
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: TextFormField(
                          obscureText: false,
                          validator: (value) {
                            if (value == '') {
                              return 'password * is mandatory';
                            } else if (value!.length < 8) {
                              return 'password should be greater than 8 letters';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.security),
                              labelText: 'password'),
                          controller: password,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: TextFormField(
                          obscureText: stat,
                          decoration: InputDecoration(
                              suffixIcon: stat == true
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          stat = false;
                                        });
                                      },
                                      icon: const Icon(Icons.visibility_off))
                                  : IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            stat = true;
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.visibility),
                                    ),
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
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: TextFormField(
                          validator: (value) {
                            if (value == '') {
                              return 'Field is required';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.drive_eta),
                              hintText: 'Lisense.No '),
                          controller: DL_No,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: SizedBox(
                          width: 360,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF17203A)),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                if (load == false) {
                                  add_user(context);
                                }
                              }
                            },
                            child: load == false
                                ? Text('Register')
                                : CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 35, bottom: 10),
                child: Text('Already Registered ?'),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (ctx) {
                  return Login();
                },
              ),
            );
          },
          child: const Text(
            "Sign In",
            style: TextStyle(color: Color(0xFF17203A)),
          ),
        ),
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
