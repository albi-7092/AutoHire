import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/About.dart';
import 'package:login/Bookings.dart';
import 'package:login/profile.dart';
import 'package:login/ratings.dart';
import './tandc.dart';
import 'package:login/Account.dart';
import 'package:login/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class menu extends StatefulWidget {
  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String name = '';
  late final String document_id;
  @override
  void initState() {
    loaddata();
    super.initState();
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
          this.name = documentSnapshot.get('name');
        });
        print('name :$name');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          //color: Color(0xFF17203A),
          width: 255,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF17203A),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 180),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(MaterialPageRoute(builder: (ctx) {
                            return HOME();
                          }));
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: CircleAvatar(
                          backgroundImage:
                              AssetImage('images/Unknown_person.jpg'),
                          radius: 80),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: ListTile(
                  iconColor: Colors.white,
                  leading: Icon(Icons.person),
                  title: Text(
                    'Account',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return account();
                    }));
                  },
                ),
              ),
              ListTile(
                iconColor: Colors.white,
                leading: Icon(Icons.car_crash_outlined),
                title: Text(
                  'Bookings',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return bookings();
                  }));
                },
              ),
              ListTile(
                iconColor: Colors.white,
                leading: Icon(Icons.star),
                title: Text(
                  'Ratings',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return rating();
                  }));
                },
              ),
              ListTile(
                iconColor: Colors.white,
                leading: Icon(Icons.sell),
                title: Text(
                  'Terms & Conditions',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return tandc();
                  }));
                },
              ),
              ListTile(
                iconColor: Colors.white,
                leading: Icon(Icons.person),
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return profile();
                  }));
                },
              ),
              ListTile(
                iconColor: Colors.white,
                leading: Icon(Icons.info_outline_rounded),
                title: Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return about();
                  }));
                },
              ),
              ListTile(
                iconColor: Colors.white,
                leading: Icon(Icons.logout),
                title: Text(
                  'Log out',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  logout();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => login()),
                      (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    await auth.signOut();
    final sh = await SharedPreferences.getInstance();
    await sh.clear();
  }
}
