import 'package:flutter/material.dart';
import 'package:message_in_a_bottle/global_objects.dart';

class BottleCreationPopup extends StatelessWidget {
  final Bottle bottle;

  // Constructor to receive the message
  BottleCreationPopup({required this.bottle});

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
            "Leave a message\n",
            style: const TextStyle(fontSize: 18.0),
          ),
                    // Text input box for the bottle message
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Enter your message',
              border: OutlineInputBorder(),
            ),
            maxLines: 3, // Adjust the number of lines as needed
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Close the message view
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
                    const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
