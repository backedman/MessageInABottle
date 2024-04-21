import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:message_in_a_bottle/utils/global_objects.dart';
import 'dart:math';


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

    String _message = "none";

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
            style: TextStyle(fontSize: 18.0),
          ),
                    // Text input box for the bottle message
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Enter your message',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
              onChanged: (value) {
              // Update the _message variable when the text changes
                _message = value;
            }, // Adjust the number of lines as needed
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              writeBottle(user, _message, "College Park", bottle.location); //TODO: add the ability to get the city of the user.
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
                    const SizedBox(height: 20.0),
        ],
      ),
    );
  }


  void writeBottle(user, message, city, location) {

    var collection = firestore.collection("bottles");

    var doc = {
      'user' : user,
      'message': message,
      'location': location,
      'city': city
    };

    collection.add(doc).then((value) {
      print("Bottle added with ID: ${value.id}");
    })
    .catchError((error) {
      print("Failed to add bottle: $error");
    });
  }

  void readData() {
    firestore.collection('bottles').get()
    .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print('${doc.id}: ${doc.data()}');
      });
    })
    .catchError((error) {
      print("Failed to retrieve bottles: $error");
    });
  }
}
