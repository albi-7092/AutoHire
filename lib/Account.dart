// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:login/Home.dart';
import 'package:login/Change_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Delete_account.dart';
import 'package:local_auth/local_auth.dart';

class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final LocalAuthentication auth = LocalAuthentication();
  bool status = false;
  bool authenticated = false;
  bool enabled = false;

  @override
  void initState() {
    checkBiometricAvailability();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: const Text('Account'),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  iconColor: Colors.black,
                  leading: Icon(Icons.fingerprint),
                  title: const Text(
                    'Unlock with Fingerprint',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: const Text(
                      "When enabled, you'll need to use fingerprint to open AutoHire"),
                  trailing: Switch(
                    value: enabled,
                    onChanged: (bool val) {
                      setState(
                        () {
                          enabled = val;
                        },
                      );
                      if (enabled == false) {
                        print('fingerprint disable function enabled');
                        fingerprintdisable();
                      } else {
                        print('fingerprint activation function enabled');
                        fingerprintenable();
                      }
                    },
                  ),
                ),
                ListTile(
                  iconColor: Colors.black,
                  leading: Icon(Icons.delete),
                  title: const Text(
                    'Delete my account',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) {
                          return Delete();
                        },
                      ),
                    );
                  },
                ),
                ListTile(
                  iconColor: Colors.black,
                  leading: Icon(Icons.password),
                  title: const Text(
                    'Change password',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) {
                          return Change_password();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        elevation: 0,
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(left: 130, right: 50, bottom: 10),
          child: Text('Powered by Auto Hire'),
        ),
      ),
    );
  }

  Future<void> checkBiometricAvailability() async {
    bool isAvailable = await auth.canCheckBiometrics;
    if (isAvailable == true) {
      setState(
        () {
          status = true;
          print('Status = $status');
        },
      );
      if (status == true) {
        final sh = await SharedPreferences.getInstance();
        final sv = sh.getString('finger_print');
        if (sv == 'true') {
          setState(
            () {
              enabled = true;
            },
          );
        } else {
          setState(
            () {
              enabled = false;
            },
          );
        }
      }
    }
  }

  Future<void> fingerprintenable() async {
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Auto Hire',
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error during fingerprint authentication: $e');
    }
    if (authenticated) {
      // fingerprintenable();
      final sh = await SharedPreferences.getInstance();
      await sh.setString(
        'finger_print',
        'true',
      );
    }
  }

  Future<void> fingerprintdisable() async {
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Auto Hire',
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error during fingerprint authentication: $e');
    }
    if (authenticated) {
      //fingerprintdisable()
      final sh = await SharedPreferences.getInstance();
      await sh.setString(
        'finger_print',
        'false',
      );
    }
  }
}
