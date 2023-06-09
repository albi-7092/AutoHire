import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Account.dart';

class profile extends StatefulWidget {
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  TextEditingController name_field = TextEditingController();
  TextEditingController user_name_field = TextEditingController();
  TextEditingController email_id_field = TextEditingController();
  TextEditingController liscence_no_field = TextEditingController();
  TextEditingController age_field = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = '';
  String email = '';
  String user_name = '';
  String Dl_nos = '';
  String document_id = '';
  String age = '';

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    loaddata();
    super.initState();
  }

  void update() {
    try {
      final DocumentReference document =
          firestore.collection('USER').doc(document_id);

      if (name_field.text != '') {
        document.update({
          'name': name_field.text,
        });
      }
      if (user_name_field.text != '') {
        document.update({
          'user_name': user_name_field.text,
        });
      }
      if (liscence_no_field.text != '') {
        document.update({
          'dl_no': liscence_no_field.text,
        });
      }

      if (age_field.text != '') {
        document.update({
          'age': age_field.text,
        });
      }
    } on Exception catch (e) {
      print('failed $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF17203A),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(MaterialPageRoute(builder: (ctx) {
              return account();
            }));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Profile'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                CircleAvatar(
                    backgroundImage: AssetImage('images/Unknown_person.jpg'),
                    radius: 80),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 30),
                          child: TextFormField(
                            controller: user_name_field,
                            decoration: InputDecoration(
                                labelText: 'user name :',
                                hintText: user_name,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                prefixIcon: Icon(Icons.person)),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 15),
                          child: TextFormField(
                            controller: name_field,
                            decoration: InputDecoration(
                                labelText: 'Name :',
                                hintText: name,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                prefixIcon: Icon(Icons.person)),
                          ),
                        ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.only(left: 5, right: 5, top: 15),
                        //   child: TextFormField(
                        //     decoration: InputDecoration(
                        //         labelText: 'Email ID :',
                        //         hintText: email,
                        //         border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(30)),
                        //         prefixIcon: Icon(Icons.email)),
                        //   ),
                        // ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 15),
                          child: TextFormField(
                            controller: liscence_no_field,
                            decoration: InputDecoration(
                                labelText: 'Liscence No :',
                                hintText: Dl_nos,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                prefixIcon: Icon(Icons.drive_eta)),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 15),
                          child: TextFormField(
                            controller: age_field,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'age :',
                                hintText: age,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                prefixIcon: Icon(Icons.calendar_month)),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Powered by Auto Hire'),
                        )
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.only(left: 5, right: 5, top: 15),
                        //   child: TextFormField(
                        //     keyboardType: TextInputType.emailAddress,
                        //     decoration: InputDecoration(
                        //         labelText: 'Email id :',
                        //         hintText: 'Enter your email',
                        //         border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(30)),
                        //         prefixIcon: Icon(Icons.email)),
                        //   ),
                        // ),
                      ],
                    ))
              ],
            ),
          ),
        ),
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
                  update();
                  print(document_id);
                },
                child: Text('Update'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loaddata() async {
    final sp = await SharedPreferences.getInstance();
    document_id = sp.getString('doc_id')!;
    firestore
        .collection('USER')
        .doc(document_id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          this.user_name = documentSnapshot.get('user_name');
          this.name = documentSnapshot.get('name');
          this.email = documentSnapshot.get('email');
          this.Dl_nos = documentSnapshot.get('dl_no');
          this.age = documentSnapshot.get('age');
        });
        print('name :$user_name');
      }
    });
  }
}
