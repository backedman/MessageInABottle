import 'package:flutter/material.dart';
import 'package:message_in_a_bottle/map_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    }
  }

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Log-In/Sign-Up',
              style: TextStyle(fontWeight: FontWeight.bold))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Username (sign-up only)')),
            const SizedBox(height: 20.0),
            TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Email', hintText: 'Email')),
            const SizedBox(height: 20.0),
            TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password (6 or more characters)')),
            const SizedBox(height: 30.0),
            SizedBox(
                child: RawMaterialButton(
                    fillColor: Colors.blue,
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () async {
                      User? user = await signUp();
                      if (user != null && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                backgroundColor:
                                    const Color.fromARGB(255, 153, 0, 0),
                                centerTitle: true,
                                title: const Text(
                                  "Message in a Bottle",
                                  style: TextStyle(color: Colors.white),
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
                        style:
                            TextStyle(color: Colors.white, fontSize: 20.0)))),
            const SizedBox(height: 5.0),
            SizedBox(
              child: RawMaterialButton(
                fillColor: Colors.blue,
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () async {
                  User? user = await logIn();
                  if (user != null && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            backgroundColor:
                                const Color.fromARGB(255, 153, 0, 0),
                            centerTitle: true,
                            title: const Text(
                              "Message in a Bottle",
                              style: TextStyle(color: Colors.white),
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
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}