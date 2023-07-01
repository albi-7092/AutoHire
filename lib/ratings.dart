import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class rating extends StatelessWidget {
  double status = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Color(0xFF17203A),
        title: const Text('rate our product'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text('Tap the stars below to rate your experience '),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 25,
            ),
            child: Center(
              child: RatingBar.builder(
                initialRating: status,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  status = rating;
                  print(rating);
                },
              ),
            ),
          )
        ],
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
                child: Center(child: Text('powered by Auto Hire'))),
          ),
        ),
      ),
    );
  }
}
