import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:message_in_a_bottle/pages/map_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  /* when called, will attempt to add the user to the authentication database, using the values found in the username, email, and password text controllers. returns the User object associated with the new user, or null if it could not be created */
  Future<User?> signUp() async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      final User? user = userCredential.user;
      user?.updateDisplayName(usernameController.text.trim());
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sign-Up Error'),
              content: const Text(
                  'Password must be 6 or more characters. Please try again.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      } else if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sign-Up Error'),
              content: const Text('Email is already in use. Please try again.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sign-Up Error'),
              content: const Text(
                  'There was an error signing up. Please try again.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      }
      return null;
    }
  }

  /* when called, will attempt to log in to the authentication server, using the values found in the username, email, and password text controllers. returns the User object associated with the user, or null if it could not be found */
  Future<User?> logIn() async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      final User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Log-In Error'),
              content: const Text('Email was not found. Please try again.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Log-In Error'),
              content: const Text('Password was incorrect. Please try again.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Log-In Error'),
              content: const Text(
                  'There was an error logging in. Please try again.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          },
        );
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: LayoutBuilder(builder: (context, constraint) => Container(
        height: constraint.maxHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/LoginBackGround.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Message In A Bottle",
              style: TextStyle(
                  color: Colors.white, fontSize: 80, fontFamily: 'BebasNeue'),
              textAlign: TextAlign.center,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 93, 30, 98),
                  width: 2.0,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 25, 3, 68),
                      fontSize: 15,
                      fontFamily: 'Nunito-VariableFont',
                      fontWeight: FontWeight.bold,
                    ),
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 25, 3, 68),
                        fontSize: 15,
                        fontFamily: 'Nunito-VariableFont',
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: 'Username',
                      hintText: 'Username (sign-up only)',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 25, 3, 68),
                      fontSize: 15,
                      fontFamily: 'Nunito-VariableFont',
                      fontWeight: FontWeight.bold,
                    ),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 25, 3, 68),
                        fontSize: 15,
                        fontFamily: 'Nunito-VariableFont',
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: 'Email',
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 25, 3, 68),
                      fontSize: 15,
                      fontFamily: 'Nunito-VariableFont',
                      fontWeight: FontWeight.bold,
                    ),
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 25, 3, 68),
                        fontSize: 15,
                        fontFamily: 'Nunito-VariableFont',
                        fontWeight: FontWeight.bold,
                      ),
                      labelText: 'Password',
                      hintText: 'Password (6 or more characters)',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
                width: 200.0,
                child: RawMaterialButton(
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      User? user = await signUp();
                      if (user != null && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Row(
                                  children: [
                                    Image.asset(
                                      'images/BottleIcon.png',
                                      height: 35.0,
                                    ),
                                    // SizedBox(width: 8.0),
                                    const Text(
                                      "Message In A Bottle",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: 'BebasNeue',
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                flexibleSpace: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 112, 218, 108),
                                        Color.fromARGB(255, 20, 135, 45),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                              ),
                              body: MapPage(
                                user: user,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Sign Up',
                        style: TextStyle(
                            color: Color.fromARGB(255, 40, 40, 40),
                            fontSize: 20.0,
                            fontFamily: 'Nunito-VariableFont',
                            fontWeight: FontWeight.bold)))),
            const SizedBox(height: 5.0),
            SizedBox(
              width: 200.0,
              child: RawMaterialButton(
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () async {
                  User? user = await logIn();
                  if (user != null && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: Row(
                              children: [
                                Image.asset(
                                  'images/BottleIcon.png',
                                  height: 35.0,
                                ),
                                // SizedBox(width: 8.0),
                                const Text(
                                  "Message In A Bottle",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'BebasNeue',
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            flexibleSpace: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 112, 218, 108),
                                    Color.fromARGB(255, 20, 135, 45),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          body: MapPage(
                            user: user,
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(
                      color: Color.fromARGB(255, 40, 40, 40),
                      fontSize: 20.0,
                      fontFamily: 'Nunito-VariableFont',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        )),
      )),
    ));
  }
}
