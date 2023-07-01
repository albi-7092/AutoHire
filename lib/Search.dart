import 'package:flutter/material.dart';
import 'package:login/search_result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class search extends StatefulWidget {
  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController search = TextEditingController();
  String filter_value = 'model_no';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                iconSize: 33,
              ),
              Expanded(
                  child: Container(
                height: 50,
                child: TextField(
                  controller: search,
                  decoration: InputDecoration(
                      hintText:
                          filter_value == 'model_no' ? 'Search Cars' : check(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
              )),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'model_no',
                          child: Text('model_no'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'seat_capacity',
                          child: Text('seat_capacity'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'engine_cc',
                          child: Text('engine_cc'),
                        ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'model_no':
                            set_model_no();
                            break;
                          case 'seat_capacity':
                            set_seat_capacity();
                            break;
                          case 'engine_cc':
                            set_engine_cc();
                            break;
                          default:
                        }
                      },
                      child: Icon(FontAwesomeIcons.sliders),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendFun();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    iconSize: 33,
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  void set_model_no() {
    setState(() {
      filter_value = 'model_no';
    });
    print(filter_value);
  }

  void set_seat_capacity() {
    setState(() {
      filter_value = 'seat_capacity';
    });
  }

  void set_engine_cc() {
    setState(() {
      filter_value = 'engine_cc';
    });
  }

  String check() {
    if (filter_value == 'engine_cc') {
      return 'Search by engine cc';
    } else {
      return 'Search by seat_capacity';
    }
  }

  void sendFun() {
    if (search.text.isEmpty) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Center(child: Text('Auto Hire')),
              content: Text(
                'Field is required',
                // style: TextStyle(color: Colors.red),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('OK'))
              ],
            );
          });
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return search_result(search.text, filter_value);
      }));
    }
  }
}
