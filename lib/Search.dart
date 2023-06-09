import 'package:flutter/material.dart';

import 'Home.dart';

class search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(MaterialPageRoute(builder: (ctx) {
              return HOME();
            }));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: TextField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            label: Text(
              'search cars',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.send,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
