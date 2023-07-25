import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class maps extends StatefulWidget {
  String lat, long, provider, phone_no;
  maps(this.lat, this.long, this.provider, this.phone_no);

  @override
  State<maps> createState() => _mapsState();
}

class _mapsState extends State<maps> {
  double x = 0;
  double x1 = 0;
  double y1 = 0;
  double y = 0;
  String Name = '';
  String Phone_no = '';
  Position? CurrentPosition;
  bool status = false;

  @override
  void initState() {
    x = double.parse(widget.lat);
    y = double.parse(widget.long);
    Name = widget.provider;
    Phone_no = widget.phone_no;
    // getLocationFromAddress('kidangoor');
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
              Marker(
                markerId: MarkerId('position_1'),
                position: LatLng(x1, y1),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
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
                child: Icon(Icons.arrow_back),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Future<void> getLocationFromAddress(String address) async {
  //   try {
  //     List<Location> locations = await locationFromAddress(address);
  //     if (locations.isNotEmpty) {
  //       setState(() {
  //         x1 = locations[0].latitude;
  //         y1 = locations[0].longitude;
  //       });
  //     }
  //   } catch (e) {
  //     print("Error while fetching coordinates: $e");
  //   }
  // }
}
