import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Login to your account',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle login logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0E12FF),
              ),
              child: Text('LOGIN'),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Handle forgot password logic here
                _handleForgotPassword();
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF0E12FF),
              ),
              child: Text('FORGOT YOUR PASSWORD?'),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    // Handle sign-up logic here
                    _handleSignUp();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFF0E12FF),
                  ),
                  child: Text('SIGN UP'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _handleForgotPassword() {
    // Handle forgot password logic here
    debugPrint('Forgot Your Password?');
  }


  void _handleSignUp() {
    // Handle sign-up logic here
    debugPrint('SIGN UP');
  }
}
