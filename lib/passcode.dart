import 'package:flutter/material.dart';
import 'package:login/Menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Account.dart';
import 'Home.dart';

class passcode extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  TextEditingController passcode_1 = TextEditingController();
  TextEditingController passcode_2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passcode Lock'),
        backgroundColor: Color(0xFF17203A),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(MaterialPageRoute(builder: (ctx) {
              return account();
            }));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                width: 450,
                height: 250,
                child: Image.asset("images/passcode.jpeg")),
            Text(
              "Create a 6-digit passcode",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
              child: Text(
                "If you forget your passcode lock, you'll need to log out or re-install the App",
              ),
            ),
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: TextFormField(
                        controller: passcode_1,
                        validator: (value) {
                          if (value == "" || value!.length < 6) {
                            return 'field is required';
                          }
                        },
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.security_outlined),
                            labelText: '6-digit code',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40))),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: TextFormField(
                        controller: passcode_2,
                        validator: (value) {
                          if (value == "" || value!.length < 6) {
                            return 'field is required';
                          }
                        },
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.security_outlined),
                            labelText: 'Re-type 6-digit code',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40))),
                      ),
                    )
                  ],
                ))
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
                  if (_formkey.currentState!.validate()) {
                    passcode_one();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (ctx) => HOME()),
                        (route) => false);
                  }
                },
                child: Text('Enable'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> passcode_one() async {
    final sh = await SharedPreferences.getInstance();
    await sh.setString('passcode', passcode_1.text);
  }
}
