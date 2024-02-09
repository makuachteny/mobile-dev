import 'package:flutter/material.dart';
import './landing_page.dart';
import './signup.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Login to your account',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LandingPage()),
                );
              },
              style: ElevatedButton.styleFrom(
<<<<<<< HEAD
                backgroundColor: const Color(0xFF0E12FF),
=======
                backgroundColor: const Color.fromARGB(255, 14, 143, 255),
>>>>>>> 6f1fb5934259c4f28e38aac9fd0b126ae33194e8
              ),
              child: const Text('LOGIN'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                _handleForgotPassword();
              },
              style: TextButton.styleFrom(
<<<<<<< HEAD
                foregroundColor: const Color(0xFF0E12FF),
=======
                foregroundColor: const Color.fromARGB(255, 14, 143, 255),
>>>>>>> 6f1fb5934259c4f28e38aac9fd0b126ae33194e8
              ),
              child: const Text('FORGOT YOUR PASSWORD?'),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
<<<<<<< HEAD
                const Text("Don't have an account? "),
=======
                // ignore: prefer_const_constructors
                Text("Don't have an account? "),
>>>>>>> 6f1fb5934259c4f28e38aac9fd0b126ae33194e8
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  style: TextButton.styleFrom(
<<<<<<< HEAD
                    foregroundColor: const Color(0xFF0E12FF),
=======
                    foregroundColor: const Color.fromARGB(255, 14, 143, 255),
>>>>>>> 6f1fb5934259c4f28e38aac9fd0b126ae33194e8
                  ),
                  child: const Text('SIGN UP'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleForgotPassword() {
    debugPrint('Forgot Your Password?');
  }
}