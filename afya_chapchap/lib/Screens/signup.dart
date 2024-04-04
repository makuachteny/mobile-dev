// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print

import 'package:afya_chapchap/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:afya_chapchap/Screens/landing_page.dart';
import 'package:afya_chapchap/Screens/login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../firebase_auth/google_auth_services.dart';

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFirebase(); // Call _initializeFirebase here in initState
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    try {
      // Perform user registration with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Handle successful registration, e.g., navigate to the home page.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      // Handle registration failure (e.g., display an error message).
      print('Error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Afya Chapchap",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Say goodbye to geographical barriers and schedule your online appointment today!",
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
                const SizedBox(height: 50.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Full Name'),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _fullnameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter full name...',
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    border: OutlineInputBorder(
                       borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email'),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter email...',
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password'),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity, // Make the button width match the text field width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 76, 255, 0.921),
                      foregroundColor: Colors.white,
                      elevation: 5.0,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: _signUp,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text(
                        " LOG IN",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color.fromRGBO(0, 76, 255, 0.921),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Google Sign In Button
                SignInButton(
                  Buttons.Google,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: () async {
                    try {
                      // Perform Google Sign-Up
                      await AuthService().signInWithGoogle();
                      // Navigate to the landing page after successful sign-up
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LandingPage(),
                        ),
                      );
                    } catch (e) {
                      // Handle sign-up errors here
                      print('Error signing up with Google: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to sign up with Google.'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
