import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();
  File? fileimage;
  XFile? image;
  TextEditingController name_field = TextEditingController();
  TextEditingController user_name_field = TextEditingController();
  TextEditingController email_id_field = TextEditingController();
  TextEditingController liscence_no_field = TextEditingController();
  TextEditingController age_field = TextEditingController();
  String name = '';
  String email = '';
  String user_name = '';
  String Dl_nos = '';
  String document_id = '';
  String age = '';
  String imgurl = '';
  String downloadurl = '';
  bool loading = false;

  final _formkey = GlobalKey<FormState>();

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
          user_name = documentSnapshot.get('user_name');
          name = documentSnapshot.get('name');
          email = documentSnapshot.get('email');
          Dl_nos = documentSnapshot.get('dl_no');
          age = documentSnapshot.get('age');
          imgurl = documentSnapshot.get('profile_img_url');
        });
        print('name :$user_name');
      }
    });
  }

  Future<void> pickImage() async {
    try {
      image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          fileimage = File(image!.path);
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> update() async {
    try {
      setState(() {
        loading = true;
      });
      final DocumentReference document =
          firestore.collection('USER').doc(document_id);

      if (name_field.text != '') {
        document.update({
          'name': name_field.text,
        });
      }
      if (user_name_field.text != '') {
        document.update({
          'user_name': user_name_field.text,
        });
      }
      if (liscence_no_field.text != '') {
        document.update({
          'dl_no': liscence_no_field.text,
        });
      }

      if (age_field.text != '') {
        document.update({
          'age': age_field.text,
        });
      }
      if (fileimage != null) {
        downloadurl = await uploadImage(fileimage!);
        print(downloadurl);
        if (downloadurl.isNotEmpty) {
          document.update({
            'profile_img_url': downloadurl,
          });
        }
      }
      setState(() {
        loading = false;
      });
      Navigator.of(context).pop();
    } on Exception catch (e) {
      print('failed $e');
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Center(child: Text('Auto Hire')),
            content: Text(
              '$e',
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

  Future<String> uploadImage(File imageFile) async {
    String name_loc = name;
    try {
      String fileName = name_loc.toString();
      Reference reference =
          storage.ref().child('profile_image/$name_loc/$fileName');
      await reference.putFile(imageFile);
      String downloaduRl = await reference.getDownloadURL();

      // Save image URL to Firestore
      //await imagesCollection.add({'url': downloadURL});
      return downloaduRl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
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
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: loading == true
            ? Padding(
                padding: const EdgeInsets.only(top: 150, left: 80),
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircularProgressIndicator(),
                        Text('uploading please wait for a momment')
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
                child: name.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4.0,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 25),
                              child: Stack(children: [
                                imgurl.isEmpty && fileimage == null
                                    ? const CircleAvatar(
                                        radius: 75,
                                        backgroundImage: AssetImage(
                                          'images/Unknown_person.jpg',
                                        ),
                                      )
                                    : fileimage == null
                                        ? CircleAvatar(
                                            radius: 75,
                                            backgroundImage: NetworkImage(
                                              imgurl,
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 75,
                                            backgroundImage: FileImage(
                                              fileimage!,
                                            ),
                                          ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 130, top: 120),
                                  child: IconButton(
                                      onPressed: () {
                                        pickImage();
                                      },
                                      icon: const Icon(Icons.edit)),
                                )
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 30),
                                    child: TextFormField(
                                      controller: user_name_field,
                                      decoration: InputDecoration(
                                          labelText: 'user name :',
                                          hintText: user_name,
                                          prefixIcon: const Icon(Icons.person)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 15),
                                    child: TextFormField(
                                      controller: name_field,
                                      decoration: InputDecoration(
                                          labelText: 'Name :',
                                          hintText: name,
                                          prefixIcon: const Icon(Icons.person)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 15),
                                    child: TextFormField(
                                      controller: liscence_no_field,
                                      decoration: InputDecoration(
                                          labelText: 'Liscence No :',
                                          hintText: Dl_nos,
                                          prefixIcon:
                                              const Icon(Icons.drive_eta)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 15),
                                    child: TextFormField(
                                      controller: age_field,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          labelText: 'age :',
                                          hintText: age,
                                          prefixIcon:
                                              const Icon(Icons.calendar_month)),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text('Powered by Auto Hire'),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
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
                  update();
                  print(document_id);
                },
                child: loading == false ? Text('Update') : Text('Updating'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
