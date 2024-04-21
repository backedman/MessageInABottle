import 'package:flutter/material.dart';
import 'package:message_in_a_bottle/models/bottle.dart';
import 'package:message_in_a_bottle/popups/bottle_creation_popup.dart';

class MessagePopup extends StatelessWidget {
  final Bottle bottle;
  final String user;

  // Constructor to receive the message
  const MessagePopup({super.key, required this.bottle, required this.user});

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
            Text(
              bottle.user + " from " + bottle.city + " says\n\n " + bottle.text,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Close the message view
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              
              Navigator.of(context).pop();
              
              // Show the bottle creation popup
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: BottleCreationPopup(bottle: bottle, user: user),
                    ),
                  );
                },
              );
            },
            child: const Text('Leave a Bottle'),
          )
        ],
      ),
    );
  }
}
