// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  String lat, long, provider, phone_no;
  Maps(this.lat, this.long, this.provider, this.phone_no);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  double x = 0;
  double x1 = 0;
  double y1 = 0;
  double y = 0;
  String Name = '';
  String Phone_no = '';
  bool status = false;

  @override
  void initState() {
    print('map ui getting ready');
    x = double.parse(widget.lat);
    y = double.parse(widget.long);
    Name = widget.provider;
    Phone_no = widget.phone_no;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: LatLng(x, y),
              zoom: 13,
            ),
            markers: {
              Marker(
                markerId: MarkerId('position_1'),
                position: LatLng(x, y),
                icon: BitmapDescriptor.defaultMarker,
                infoWindow: InfoWindow(
                  title: 'Name : $Name',
                  snippet: 'Phone no :$Phone_no',
                ),
              ),
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: FloatingActionButton(
                backgroundColor: Color(0xFF17203A),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.arrow_back),
              ),
            ),
          )
        ],
      ),
    );
  }
}
