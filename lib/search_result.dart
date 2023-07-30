// ignore_for_file: use_build_context_synchronously, unused_local_variable, unnecessary_null_comparison, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/home_main_booking.dart';

class Search_result extends StatefulWidget {
  String search_key = '';
  String type = '';
  Search_result(this.search_key, this.type);

  @override
  State<Search_result> createState() => _Search_resultState();
}

class _Search_resultState extends State<Search_result> {
  List<String> document_id = [];
  String search_key = '';
  String type = '';

  String ModelNo = '';
  String km = '';
  String Image_url = '';
  bool status = false;

  @override
  void initState() {
    // TODO: implement initState
    search_key = widget.search_key;
    type = widget.type;
    search_car();
    super.initState();
  }

  Future<void> search_car() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('PROVIDER') // Replace with your collection name
        .where(type, isEqualTo: search_key)
        .get();
    snapshot.docs.forEach(
      (DocumentSnapshot document) {
        if (document.exists) {
          document_id.add(document.id);
        } else {
          //
        }
      },
    );
    if (document_id.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('Auto Hire')),
            content: const Text(
              'CAR not found',
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
        },
      ); //SHOW
    } else {
      print(document_id);
      setState(() {
        status = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('powered by Auto Hire'),
        backgroundColor: const Color(0xFF17203A),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: status == false
            ? const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('PROVIDER')
                        .doc(document_id[index])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          strokeWidth: 4.0,
                        ));
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('No data found');
                      }
                      final documentId = snapshot.data?.id;
                      final data =
                          snapshot.data?.data() as Map<String, dynamic>;
                      ModelNo = data != null ? data['model_no'] : 'N/A';
                      km = data != null ? data['km'] : 'N/A';
                      Image_url = data != null ? data['image_url'] : 'N/A';

                      return InkWell(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(Image_url),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ModelNo,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    km,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          print('Document_id :${document_id[index]}');
                          String doc = document_id[index];
                          print(doc);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) {
                                return Main_screen(doc);
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                itemCount: document_id.length,
              ),
      ),
    );
  }
}
