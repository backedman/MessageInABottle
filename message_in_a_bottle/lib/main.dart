import 'package:flutter/material.dart';
import 'package:message_in_a_bottle/curr_user_location.dart';
import 'package:message_in_a_bottle/login.dart';
import 'package:message_in_a_bottle/map_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  

  Widget homePage = const LoginPage();

  FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) { 
    if (user == null) {
      print('User is currently signed out!');
      // homePage = const LoginPage();
    } else {
      print('User is signed in!');
      homePage = MapPage(user: user);
    }
  }
  );

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
