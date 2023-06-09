import 'package:flutter/material.dart';
import 'package:login/Account.dart';

class delete extends StatefulWidget {
  @override
  State<delete> createState() => _deleteState();
}

class _deleteState extends State<delete> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF17203A),
        title: Text('Delete'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(MaterialPageRoute(builder: (ctx) {
                return account();
              }));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Delete Account ?',
                  style: TextStyle(
                      fontFamily: 'babilon',
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: CircleAvatar(
                    backgroundImage: AssetImage('images/Unknown_person.jpg'),
                    radius: 80),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                  'Anytime you can de-activate your account and Anytime you can activate your account ...'),
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
                          validator: (value) {
                            if (value == '') {
                              return 'Field is required';
                            }
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.email),
                              labelText: 'Email-id',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.security),
                              labelText: 'password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40))),
                        ),
                      )
                    ],
                  )),
            ),
            Text(
              'Powered by Auto Hire',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
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
                child: Text('Delete'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
