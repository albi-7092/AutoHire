import 'package:flutter/material.dart';
import 'package:login/change_password.dart';
import 'package:login/passcode.dart';
import 'package:login/passcode_set.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Change_mobile_number.dart';
import 'Delete_account.dart';
import 'Menu.dart';

class account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF17203A),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(MaterialPageRoute(builder: (ctx) {
              return menu();
            }));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Account'),
      ),
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            children: [
              ListTile(
                iconColor: Colors.black,
                leading: Icon(Icons.lock),
                title: Text(
                  'Encrypt App',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  navigator(context);
                },
              ),
              ListTile(
                iconColor: Colors.black,
                leading: Icon(Icons.android),
                title: Text(
                  'update number',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return Change_mobile_number();
                  }));
                },
              ),
              ListTile(
                iconColor: Colors.black,
                leading: Icon(Icons.delete),
                title: Text(
                  'Delete my account',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return delete();
                  }));
                },
              ),
              // ListTile(
              //   iconColor: Colors.black,
              //   leading: Icon(Icons.message),
              //   title: Text(
              //     'Two-step verification',
              //     style: TextStyle(
              //       color: Colors.black,
              //     ),
              //   ),
              //   onTap: () {},
              // ),
              ListTile(
                iconColor: Colors.black,
                leading: Icon(Icons.password),
                title: Text(
                  'Change password',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return change_password();
                  }));
                },
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.only(left: 130, right: 50, bottom: 10),
            child: Text('Powered by Auto Hire')),
      ),
    );
  }

  Future<void> navigator(BuildContext context) async {
    final sh = await SharedPreferences.getInstance();
    final sv = sh.getString('passcode');
    if (sv == null || sv == '') {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return passcode();
      }));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return passcode_set(sv.toString());
      }));
    }
  }
}
