import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/Menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class bookings extends StatefulWidget {
  @override
  State<bookings> createState() => _bookingsState();
}

class _bookingsState extends State<bookings> {
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
        this.car_book_id = documentSnapshot.get('car_book_id');
        print('CAR:$car_book_id');
        if (car_book_id == '') {
          print('NULL');
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Center(child: Text('Auto Hire')),
                  content: Text(
                    'NO Bookings Found',
                    // style: TextStyle(color: Colors.red),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(ctx).pop();
                        },
                        child: Text('OK'))
                  ],
                );
              }); //SHOWd
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
        this.image_url = documentSnapshot.get('image_url');
        this.model_no = documentSnapshot.get('model_no');
        this.fuel = documentSnapshot.get('fuel');
        this.provider = documentSnapshot.get('prov_name');
        this.seat_capacity = documentSnapshot.get('seat_capacity');
        this.engine_cc = documentSnapshot.get('engine_cc');
        this.pucc = documentSnapshot.get('pucc');
        this.insurance = documentSnapshot.get('insurance');
      });
      firestore
          .collection('USER')
          .doc(user_id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        setState(() {
          this.status = documentSnapshot.get('status');
        });
      });
    });
  }

  Future<void> cancel() async {
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

    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Center(child: Text('Auto Hire')),
            content: Text(
              'Cacellation sucessfully completed',
              // style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                  },
                  child: Text('OK'))
            ],
          );
        }); //SHOWd
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Bookings'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(builder: (ctx) {
                return menu();
              }));
            },
            icon: Icon(Icons.arrow_back)),
        backgroundColor: Color(0xFF17203A),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: image_url.isEmpty
                  ? SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4.0,
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 260,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(this.image_url))),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model_no,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
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
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Provider name :',
                  ),
                  Text(
                    provider,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'fuel type',
                    // style: TextStyle(
                    //     fontFamily: 'Montserrat',
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold),
                  ),
                  Text(
                    fuel,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Seat capacity :'), Text(seat_capacity)],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Engine CC :'), Text(engine_cc)],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('pucc valid upto :'), Text(pucc)],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('insurance valid upto :'), Text(insurance)],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Status :\t',
                    style: TextStyle(
                        fontFamily: 'babilon',
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                        fontFamily: 'babilon',
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        )),
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
                  cancel();
                },
                child: Text('Ready to Cancel'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
