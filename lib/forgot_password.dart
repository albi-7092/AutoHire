import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'forgot_password_updation.dart';

class forgot_password extends StatefulWidget {
  @override
  State<forgot_password> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  EmailAuth emailAuth = new EmailAuth(sessionName: "Sample session");

  @override
  void initState() {
    // TODO: implement initStatealb

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
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Forgot',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Password \t?',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Don't worry! it happens. Please enter the email id associated with your account.",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: email,
                        validator: (value) {
                          if (value == '') {
                            return 'Enter a valid mail id';
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          suffix: TextButton(
                            onPressed: () {
                              sendotp();
                            },
                            child: Text('Send otp'),
                          ),
                          prefixIconColor: Color(0xFF17203A),
                          hintText: 'Email ID',
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "To verify that this is your account, enter the verification code send to the email id, and then click 'Submit' to update your password.",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: otp,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == '') {
                            return 'this field is required';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "otp",
                          prefixIcon: Icon(Icons.verified),
                          prefixIconColor: Color(0xFF17203A),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
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
                  backgroundColor: Color(0xFF17203A),
                ),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    verifyotp();
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendotp() async {
    //EmailAuth(sessionName: 'Auto Hire');
    var res = await emailAuth.sendOtp(recipientMail: email.text, otpLength: 5);
    if (res) {}
  }

  Future<void> verifyotp() async {
    var res =
        emailAuth.validateOtp(recipientMail: email.text, userOtp: otp.text);
    if (res) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return password();
      }));
    }
  }
}
