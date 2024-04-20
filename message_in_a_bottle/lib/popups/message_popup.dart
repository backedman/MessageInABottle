import 'package:flutter/material.dart';
import 'package:message_in_a_bottle/global_objects.dart';

class message_popup extends StatelessWidget {
  final Bottle bottle;

  // Constructor to receive the message
  message_popup({required this.bottle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display the message
            Text(
              bottle.text,
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            // Button to close the message view
            ElevatedButton(
              onPressed: () {
                // Close the message view
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}

