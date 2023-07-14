import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/Search.dart';
import 'package:login/profile.dart';
import 'package:login/ratings.dart';
import 'package:login/tandc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './Menu.dart';
import 'About.dart';
import 'Account.dart';
import 'Bookings.dart';
import 'home_main_booking.dart';
import 'login.dart';

class HOME extends StatefulWidget {
  @override
  State<HOME> createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {
  final CollectionReference provider =
      FirebaseFirestore.instance.collection('PROVIDER');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  //
  String document_id = '';
  String image_url = '';
  String car_document_id = '';
  String car_name = '';
  String avg_km = '';

  String name = '';

  @override
  void initState() {
    loaddata();
    super.initState();
  }

  Future<void> logout() async {
    await auth.signOut();
    final sh = await SharedPreferences.getInstance();
    await sh.clear();
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
        appBar: AppBar(
          backgroundColor: Color(0xFF17203A),
          title: const Text(
            'Auto Hire',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return search();
                  }));
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ))
          ],
        ),
        drawer: Drawer(
          backgroundColor: Color(0xFF17203A),
          child: Column(
            children: [
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, top: 60),
                child: Text(
                  'Powered by Auto Hire',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: StreamBuilder(
              stream: provider.snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot providersnap =
                          snapshot.data.docs[index];
                      document_id = providersnap['doc_id'];
                      image_url = providersnap['image_url'];
                      car_name = providersnap['model_no'];
                      avg_km = providersnap['km'];
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: image_url.isEmpty
                              ? CircularProgressIndicator(
                                  strokeWidth: 4.0,
                                )
                              : Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 200,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(image_url))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            car_name,
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            avg_km,
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                        ),
                        onTap: () {
                          print(providersnap['doc_id']);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return main_screen(
                              providersnap['doc_id'],
                            );
                          }));
                        },
                      );
                    },
                  );
                } else {
                  return Container();
                }
              }),
        ));
  }
}
