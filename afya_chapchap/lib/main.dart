import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './Screens/signup.dart';
import './Screens/login.dart'; // Import the login screen file.
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Fix the constructor declaration.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Merriweather',
      ),
      initialRoute: '/signup', // Set the initial route to '/signup'.
      debugShowCheckedModeBanner: false,
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/LoginPage': (context) => const LoginPage(),
      },
    );
  }
}
