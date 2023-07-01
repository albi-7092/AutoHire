import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password_updation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:email_otp/email_otp.dart';

class forgot_password_verification extends StatefulWidget {
  @override
  State<forgot_password_verification> createState() =>
      _forgot_password_verificationState();
}

class _forgot_password_verificationState
    extends State<forgot_password_verification> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  EmailOTP myauth = EmailOTP();
  TextEditingController otp = TextEditingController();
  String document_id = '';
  String email_id = '';

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initStatealb
    initial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(38),
            child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset("images/image_1.jpeg")),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Forgot',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Password \t?',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Don't worry! it happens.",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text('Enter the 6-digit code we sent to the email address'),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                    onPressed: () async {
                      myauth.setConfig(
                          appEmail: "autohire895@gmail.com",
                          appName: "Auto Hire",
                          userEmail: email_id,
                          otpLength: 6,
                          otpType: OTPType.digitsOnly);
                      if (await myauth.sendOTP() == true) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("OTP has been sent"),
                        ));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Oops, OTP send failed"),
                        ));
                      }
                    },
                    child: Text('Send OTP')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Form(
                key: _formkey,
                child: TextFormField(
                  controller: otp,
                  decoration: InputDecoration(suffixIcon: Icon(Icons.key)),
                )),
          )
        ],
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
                        backgroundColor: Color(0xFF17203A)),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        if (await myauth.verifyOTP(otp: otp.text) == true) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (ctx) {
                            return password();
                          }));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Invalid OTP"),
                          ));
                        }
                      }
                    },
                    child: Text('Submit'))),
          ),
        ),
      ),
    );
  }

  Future<void> initial() async {
    final sp = await SharedPreferences.getInstance();
    document_id = sp.getString('doc_id')!;
    firestore
        .collection('USER')
        .doc(document_id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          this.email_id = documentSnapshot.get('email');
        });
      }
    });
  }
}
