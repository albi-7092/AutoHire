import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'login.dart';

class passcode_verification extends StatelessWidget {
  String pass;

  passcode_verification(this.pass);
  TextEditingController txt = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      logout();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (ctx) => login()),
                          (route) => false);
                    },
                    icon: Icon(Icons.logout)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              child: SizedBox(
                  width: 450,
                  height: 250,
                  child: Image.asset("images/passcode_verification.png")),
            ),
            Center(child: Text('Protect your privacy - enter your passcode')),
            Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
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
                    suffixIcon: Icon(Icons.safety_check),
                    hintText: '\t6-digit code',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
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
                    if (pass == txt.text) {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (ctx) {
                        return HOME();
                      }));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Wrong passcode"),
                      ));
                    }
                  }
                },
                child: Text('Sign in with passcode'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    final sh = await SharedPreferences.getInstance();
    await sh.clear();
  }
}
