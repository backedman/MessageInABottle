import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:message_in_a_bottle/models/bottle.dart';
import 'package:message_in_a_bottle/utils/database_operations.dart';

class BottleCreationPopup extends StatelessWidget {
  final Bottle bottle;
  final String user;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Constructor to receive the message
  BottleCreationPopup({super.key, required this.bottle, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    String message = "none";

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 10),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Leave a message\n",
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'Nunito-VariableFont',
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          // Text input box for the bottle message
          TextFormField(
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Nunito-VariableFont', fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              labelText: 'Enter your message',
              labelStyle: TextStyle(
                fontFamily: 'Nunito-VariableFont',
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 85, 85, 85),
                  width: 2.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0, // adjust the vertical padding as needed
                horizontal: 16.0, // adjust the horizontal padding as needed
              ),
            ),
            maxLines: 3,
            onChanged: (value) {
              // Update the _message variable when the text changes
              message = value;
            }, // Adjust the number of lines as needed
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              GeoPoint location =
                  GeoPoint(bottle.location.latitude, bottle.location.longitude);

              var address = await GeoCode().reverseGeocoding(
                  latitude: bottle.location.latitude,
                  longitude: bottle.location.longitude);

              var city = address.city;

              writeBottle(user, message, city,
                  location); //TODO: add the ability to get the city of the user.
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Nunito-VariableFont',
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
