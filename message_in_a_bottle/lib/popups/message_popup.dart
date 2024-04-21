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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(bottle.user,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18.0, fontFamily: 'BebasNeue')),
          Text(
            textAlign: TextAlign.center,
            "from " + bottle.city + " says:\n ",
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: 'Nunito-VariableFont',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            "\"" + bottle.text + "\"",
            style: const TextStyle(
              fontSize: 15.0,
              fontFamily: 'Nunito-VariableFont',
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 200.0,
            child: ElevatedButton(
              onPressed: () {
                // Close the message view
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: const TextStyle(
                  fontFamily: 'Nunito-VariableFont',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            width: 200.0,
            child: ElevatedButton(
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
              child: const Text(
                'Leave a Bottle',
                style: const TextStyle(
                  fontFamily: 'Nunito-VariableFont',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
