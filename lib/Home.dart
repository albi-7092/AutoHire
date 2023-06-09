import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/Search.dart';

import './Menu.dart';
import 'home_main_booking.dart';

class HOME extends StatefulWidget {
  @override
  State<HOME> createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {
  final CollectionReference provider =
      FirebaseFirestore.instance.collection('PROVIDER');
  //
  String document_id = '';
  String image_url = '';
  String car_document_id = '';
  String car_name = '';
  String avg_km = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF17203A),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return menu();
              }));
            },
            icon: Icon(Icons.menu),
          ),
          title: Text(
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
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
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
