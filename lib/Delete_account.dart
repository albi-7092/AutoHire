import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/Account.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class delete extends StatefulWidget {
  @override
  State<delete> createState() => _deleteState();
}

class _deleteState extends State<delete> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String document_id = '';
  String user_email = '';
  String user_password = '';

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF17203A),
        title: Text('Delete'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(builder: (ctx) {
                return account();
              }));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Delete Account ?',
                  style: TextStyle(
                      fontFamily: 'babilon',
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: CircleAvatar(
                    backgroundImage: AssetImage('images/Unknown_person.jpg'),
                    radius: 80),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                  'Anytime you can de-activate your account and Anytime you can activate your account ...'),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: email,
                          validator: (value) {
                            if (value == '') {
                              return 'Field is required';
                            }
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.email),
                              labelText: 'Email-id',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: password,
                          obscureText: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.security),
                              labelText: 'password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40))),
                        ),
                      )
                    ],
                  )),
            ),
            Text(
              'Powered by Auto Hire',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
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
                    if (email.text == user_email &&
                        password.text == user_password) {
                      delete();
                    } else {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Center(child: Text('Auto Hire')),
                              content: Text(
                                'oops..Please check the mail id and password',
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
                    }
                  }
                },
                child: Text('Delete'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetch() async {
    final sp = await SharedPreferences.getInstance();
    document_id = sp.getString('doc_id')!;
    if (document_id.isNotEmpty) {
      load();
    }
  }

  Future<void> load() async {
    firestore
        .collection('USER')
        .doc(document_id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        user_email = documentSnapshot.get('email');
        user_password = documentSnapshot.get('password');
      }
    });
  }

  Future<void> delete() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user_email, password: user_password);
      User? user = auth.currentUser;
      if (user != null) {
        await user.delete();
      } else {
        print('user is empty');
      }
      firestore.collection('USER').doc(document_id).delete();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => login()), (route) => false);
      logout();
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    final sh = await SharedPreferences.getInstance();
    await sh.clear();
  }
}
