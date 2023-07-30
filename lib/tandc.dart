import 'package:flutter/material.dart';

class Tandc extends StatelessWidget {
  const Tandc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    width: 230,
                    height: 230,
                    child: Image.asset("images/logo.jpeg")),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '1.Register and log in to the app to get started. Make sure to provide accurate information, including your name, email address, and payment details.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '2.Search for available cars by location, date, and time. You can filter your search by car type, features, and price range to find the perfect vehicle for your needs.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '3.Reserve your desired car by selecting the pickup and drop-off locations and times. You will be prompted to confirm your reservation and make a payment.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '4.Before picking up the car, review the rental agreement and make sure you understand the terms and conditions. Check the condition of the vehicle and report any damages or issues to the rental company.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '5.Drive safely and responsibly. Follow all traffic laws and regulations, and return the car on time and in the same condition as when you picked it up.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "6.If you have any questions or issues during the rental period, contact the rental company's customer service team for assistance.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "7.After returning the car, review your rental experience and leave feedback for the rental company. This helps improve the service for future customers.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "8.Remember to take all your personal belongings out of the car before returning it. The rental company is not responsible for any lost or stolen items.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
