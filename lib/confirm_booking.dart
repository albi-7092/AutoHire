import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'UPI.dart';

class confirm_booking extends StatefulWidget {
  String car_id = '';
  confirm_booking(this.car_id);
  @override
  State<confirm_booking> createState() => _confirm_bookingState();
}

class _confirm_bookingState extends State<confirm_booking> {
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
    firestore
        .collection('PROVIDER')
        .doc(car_doc_id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          this.rate = documentSnapshot.get('rate');
          this.name = documentSnapshot.get('prov_name');
          this.upi_id = documentSnapshot.get('prov_upi_id');
        });
        print(name);
      }
    });
  }

  Future<void> cnfbooking() async {
    try {
      final sh = await SharedPreferences.getInstance();
      final sv = sh.getString('doc_id');
      String user_doc_id = '';
      user_doc_id = sv.toString();
      final DocumentReference document =
          firestore.collection('USER').doc(user_doc_id);
      document.update({'car_book_id': car_doc_id, 'status': 'pending'});
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Center(child: Text('Auto Hire')),
              content: Text(
                'Booking confirmed',
                // style: TextStyle(color: Colors.red),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (ctx) => HOME()),
                          (route) => false);
                    },
                    child: Text('OK'))
              ],
            );
          });
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Center(child: Text('Auto Hire')),
              content: Text(
                'ERROR :$e',
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
                return HOME();
              }));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
          child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
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
                subtitle: Text('rent charges will be applicable for 24 hours'),
                iconColor: Colors.black,
                leading: Icon(Icons.delivery_dining),
                title: Text(
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
                subtitle: Text('rent charges will be applicable for 24 hours'),
                iconColor: Colors.black,
                leading: Icon(Icons.paypal),
                title: Text(
                  'UPI/NetBanking',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return UPIpayment(name, rate, upi_id);
                  }));
                },
              ),
            )
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.only(left: 130, right: 50, bottom: 10),
            child: Text('Powered by Auto Hire')),
      ),
    );
  }
}
