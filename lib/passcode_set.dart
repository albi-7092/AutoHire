import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Account.dart';
import 'Home.dart';

class passcode_set extends StatelessWidget {
  String pass;

  passcode_set(this.pass);
  final _formkey = GlobalKey<FormState>();
  TextEditingController txt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SafeArea(
          child: ListView(
        children: [
          SizedBox(
              width: 450,
              height: 250,
              child: Image.asset("images/passcode.jpeg")),
          Center(child: Text('Protect your privacy - enter your passcode')),
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
              child: TextFormField(
                controller: txt,
                validator: (value) {
                  if (value == "" || value!.length < 6) {
                    return 'field is required';
                  }
                },
                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key_outlined),
                  hintText: '6-digit code',
                ),
              ),
            ),
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
                  backgroundColor: Color(0xFF17203A),
                ),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    if (txt.text == pass) {
                      passcode_off();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (ctx) => HOME()),
                          (route) => false);
                    }
                  }
                },
                child: Text('turn off'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void passcode_off() async {
    final sh = await SharedPreferences.getInstance();
    await sh.setString('passcode', '');
  }
}
