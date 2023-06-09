import 'package:flutter/material.dart';

class Change_mobile_number extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF17203A),
        title: Text('Update mobile number'),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Update Mobile Phone Number',
              style: TextStyle(
                  fontFamily: 'babilon',
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 450,
              height: 250,
              child: Image.asset("images/mobile_number_updation.png"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'You can add your mobile number here. Your account and all your cloud data - messages, media, contacts, etc. will be moved to the new number.',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
                key: _formkey,
                child: TextField(
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefix: Text('+91 '),
                      suffixIcon: Icon(Icons.phone_iphone),
                      suffixIconColor: Color(0xFF17203A)),
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
                  backgroundColor: Color(0xFF17203A),
                ),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {}
                },
                child: Text('submit'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
