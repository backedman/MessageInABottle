import 'package:flutter/material.dart';
import 'package:message_in_a_bottle/curr_user_location.dart';
import 'package:message_in_a_bottle/map_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Widget homePage;

  homePage = const MapPage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentUserLocationProvider()),
      ],
      child: MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 153, 0, 0),
              centerTitle: true,
              title: const Text(
                "Message in a Bottle",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: homePage),
      ),
    ),
  );
}
