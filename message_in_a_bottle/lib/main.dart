import 'package:flutter/material.dart';
import 'package:message_in_a_bottle/pages/login.dart';
import 'package:message_in_a_bottle/providers/curr_user_location.dart';
import 'package:message_in_a_bottle/pages/map_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initializes Firebase connection
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Widget homePage = const LoginPage();

  // checks if the user is logged in; if not, they are sent to the login page
  FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    print(user.toString());
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
        home: homePage,
      ),
    ),
  );
}
