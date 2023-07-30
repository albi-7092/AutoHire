// ignore_for_file: use_build_context_synchronously,, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'UPI.dart';

class Confirm_booking extends StatefulWidget {
  String car_id = '';
  Confirm_booking(this.car_id);
  @override
  State<Confirm_booking> createState() => _Confirm_bookingState();
}

class _Confirm_bookingState extends State<Confirm_booking> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String car_doc_id = '';
  //UPI;
  String rate = '';
  String name = '';
  String upi_id = '';

  @override
  void initState() {
    car_doc_id = widget.car_id;
    loaddata();
    // TODO: implement initState
    super.initState();
  }

  void loaddata() {
    firestore.collection('PROVIDER').doc(car_doc_id).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            rate = documentSnapshot.get('rate');
            name = documentSnapshot.get('prov_name');
            upi_id = documentSnapshot.get('prov_upi_id');
          });
          print(name);
        }
      },
    );
  }

  Future<void> cnfbooking() async {
    try {
      final sh = await SharedPreferences.getInstance();
      final sv = sh.getString('doc_id');
      String userDocId = '';
      userDocId = sv.toString();
      final DocumentReference document =
          firestore.collection('USER').doc(userDocId);
      document.update({'car_book_id': car_doc_id, 'status': 'pending'});
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('Auto Hire')),
            content: const Text(
              'Booking confirmed',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (ctx) => HOME()),
                        (route) => false);
                  },
                  child: const Text('OK'))
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('Auto Hire')),
            content: Text(
              'ERROR :$e',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF17203A),
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
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Select a payment method',
                  style: TextStyle(
                      fontFamily: 'babilon',
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 30),
                child: ListTile(
                  subtitle: const Text(
                      'rent charges will be applicable for 24 hours'),
                  iconColor: Colors.black,
                  leading: const Icon(Icons.delivery_dining),
                  title: const Text(
                    'Cash on Delivery',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    cnfbooking();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  subtitle: const Text(
                      'rent charges will be applicable for 24 hours'),
                  iconColor: Colors.black,
                  leading: const Icon(Icons.paypal),
                  title: const Text(
                    'UPI/NetBanking',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return UPIpayment(name, rate, upi_id);
                    }));
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        elevation: 0,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(left: 130, right: 50, bottom: 10),
          child: Text('Powered by Auto Hire'),
        ),
      ),
    );
  }
}
