import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/Home.dart';
import 'package:login/confirm_booking.dart';

class main_screen extends StatefulWidget {
  String car_id = '';
  main_screen(this.car_id);

  @override
  State<main_screen> createState() => _main_screenState();
}

class _main_screenState extends State<main_screen> {
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
  @override
  void initState() {
    this.car_doc_id = widget.car_id;
    loaddata();
    super.initState();
  }

  Future<void> loaddata() async {
    try {
      firestore
          .collection('PROVIDER')
          .doc(car_doc_id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            image_url = documentSnapshot.get('image_url');
            Model_no = documentSnapshot.get('model_no');
            engine_cc = documentSnapshot.get('engine_cc');
            pucc = documentSnapshot.get('pucc');
            insurance = documentSnapshot.get('insurance');
            rate = documentSnapshot.get('rate');
            seat_capacity = documentSnapshot.get('seat_capacity');
            fuel = documentSnapshot.get('fuel');
          });
        }
      });
    } catch (e) {
      print('Error :$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF17203A),
        title: Text(Model_no),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(MaterialPageRoute(builder: (ctx) {
              return HOME();
            }));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: image_url.isEmpty
              ? Center(
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
                                          image: NetworkImage(image_url))),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          Model_no,
                          style: TextStyle(
                              fontFamily: 'babilon',
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 05),
                        child: Text(
                          'About the Car',
                          style: TextStyle(
                              fontFamily: 'babilon',
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Row(
                          children: [
                            Text('Seat capacity :'),
                            Text(seat_capacity)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                        child: Row(
                          children: [Text('Engine CC :'), Text(engine_cc)],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 30),
                        child: Row(
                          children: [
                            Text('Fuel type :\t'),
                            Text(fuel),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                        child: Row(
                          children: [Text('pucc valid upto :'), Text(pucc)],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                        child: Row(
                          children: [
                            Text('Insurance valid upto :'),
                            Text(insurance)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 25),
                        child: Row(
                          children: [
                            Text(
                              'Rate : ',
                              style: TextStyle(
                                  fontFamily: 'babilon',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              rate,
                              style: TextStyle(
                                  fontFamily: 'babilon',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return confirm_booking(car_doc_id);
                  }));
                },
                child: Text('Ready to Book'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
