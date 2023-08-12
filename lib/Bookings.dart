// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map.dart';

class Bookings extends StatefulWidget {
  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String car_book_id = '';
  String model_no = "";
  String image_url = "";
  String fuel = '';
  String provider = '';
  String seat_capacity = '';
  String engine_cc = '';
  String pucc = '';
  String insurance = '';
  String status = '';
  String vehicle_Number = '';
  String Lang = '';
  String long = '';
  String phone_no = '';

  @override
  void initState() {
    booked();
    super.initState();
  }

  Future<void> booked() async {
    final sh = await SharedPreferences.getInstance();
    final sv = sh.getString('doc_id');
    String doc_id = sv.toString();
    print(doc_id);
    firestore
        .collection('USER')
        .doc(doc_id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        car_book_id = documentSnapshot.get('car_book_id');
        print('CAR:$car_book_id');
        if (car_book_id == '') {
          print('NULL');
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Center(child: Text('Auto Hire')),
                  content: const Text(
                    'NO Bookings Found',
                    // style: TextStyle(color: Colors.red),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('OK'))
                  ],
                );
              }); //SHOWD
        } else {
          load(car_book_id, doc_id);
        }
      });
    });
  }

  Future<void> load(String car_id, String user_id) async {
    firestore
        .collection('PROVIDER')
        .doc(car_id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        image_url = documentSnapshot.get('image_url');
        model_no = documentSnapshot.get('model_no');
        fuel = documentSnapshot.get('fuel');
        provider = documentSnapshot.get('prov_name');
        seat_capacity = documentSnapshot.get('seat_capacity');
        engine_cc = documentSnapshot.get('engine_cc');
        pucc = documentSnapshot.get('pucc');
        insurance = documentSnapshot.get('insurance');
        vehicle_Number = documentSnapshot.get('vehicle_Number');
        Lang = documentSnapshot.get('lang');
        long = documentSnapshot.get('long');
        phone_no = documentSnapshot.get('phone_no');
      });
      firestore
          .collection('USER')
          .doc(user_id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        setState(() {
          status = documentSnapshot.get('status');
        });
      });
    });
  }

  Future<void> cancel() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('Auto Hire')),
            content: const Text(
              'Cacellation sucessfully completed',
              // style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        }); //SHOW
    final sh = await SharedPreferences.getInstance();
    final sv = sh.getString('doc_id');
    String doc_id = sv.toString();
    final DocumentReference documentReference =
        firestore.collection('USER').doc(doc_id);
    final DocumentReference document = firestore.collection('USER').doc(doc_id);
    document.update({
      'car_book_id': '',
      'status': '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Bookings'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(builder: (ctx) {
                return HOME();
              }));
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return Maps(Lang, long, provider, phone_no);
                }));
              },
              icon: const Icon(Icons.map))
        ],
        backgroundColor: const Color(0xFF17203A),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: phone_no.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                ))
              : SingleChildScrollView(
                  child: Column(
                  children: [
                    image_url.isEmpty
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
                                      image: NetworkImage(image_url))),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            model_no,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: [
                          Text(
                            'About the Car',
                            style: TextStyle(
                                fontFamily: 'babilon',
                                fontSize: 25,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Provider name :',
                          ),
                          Text(
                            provider,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'fuel type',
                          ),
                          Text(
                            fuel,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Seat capacity :'),
                          Text(seat_capacity)
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const Text('Engine CC :'), Text(engine_cc)],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('vehicle_Number :'),
                          Text(vehicle_Number)
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [const Text('pucc valid upto :'), Text(pucc)],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('insurance valid upto :'),
                          Text(insurance)
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Payment Status :\t',
                            style: TextStyle(
                                fontFamily: 'babilon',
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            status,
                            style: const TextStyle(
                                fontFamily: 'babilon',
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
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
                  cancel();
                },
                child: const Text('Ready to Cancel'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
