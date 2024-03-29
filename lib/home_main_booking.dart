// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/Home.dart';
import 'package:login/confirm_booking.dart';

class Main_screen extends StatefulWidget {
  String car_id = '';
  Main_screen(this.car_id);
  @override
  State<Main_screen> createState() => _Main_screenState();
}

class _Main_screenState extends State<Main_screen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String Model_no = '';
  String car_doc_id = '';
  String seat_capacity = '';
  String engine_cc = '';
  String pucc = '';
  String insurance = '';
  String rate = '';
  String image_url = '';
  String fuel = '';
  String vehicle_Number = '';
  @override
  void initState() {
    car_doc_id = widget.car_id;
    loaddata();
    super.initState();
  }

  Future<void> loaddata() async {
    try {
      firestore.collection('PROVIDER').doc(car_doc_id).get().then(
        (DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            setState(
              () {
                image_url = documentSnapshot.get('image_url');
                Model_no = documentSnapshot.get('model_no');
                engine_cc = documentSnapshot.get('engine_cc');
                pucc = documentSnapshot.get('pucc');
                insurance = documentSnapshot.get('insurance');
                rate = documentSnapshot.get('rate');
                seat_capacity = documentSnapshot.get('seat_capacity');
                fuel = documentSnapshot.get('fuel');
                vehicle_Number = documentSnapshot.get('vehicle_Number');
              },
            );
          }
        },
      );
    } catch (e) {
      print('Error :$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF17203A),
        title: Text(Model_no),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (ctx) {
                  return HOME();
                },
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: vehicle_Number.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: double.infinity,
                        height: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: image_url.isEmpty
                            ? const SizedBox(
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4.0,
                                  ),
                                ),
                              )
                            : Card(
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 260,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(image_url),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        Model_no,
                        style: const TextStyle(
                            fontFamily: 'babilon',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 05),
                      child: Text(
                        'About the Car',
                        style: TextStyle(
                            fontFamily: 'babilon',
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: [
                          const Text('Seat capacity :'),
                          Text(seat_capacity)
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: [const Text('Engine CC :'), Text(engine_cc)],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: [
                          const Text('Fuel type :\t'),
                          Text(fuel),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: [
                          const Text('vehicle_Number :\t'),
                          Text(vehicle_Number),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: [const Text('pucc valid upto :'), Text(pucc)],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: [
                          const Text('Insurance valid upto :'),
                          Text(insurance)
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 25),
                      child: Row(
                        children: [
                          const Text(
                            'Rate : ',
                            style: TextStyle(
                                fontFamily: 'babilon',
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            rate,
                            style: const TextStyle(
                                fontFamily: 'babilon',
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  ],
                ),
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return Confirm_booking(car_doc_id);
                  }));
                },
                child: const Text('Ready to Book'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
