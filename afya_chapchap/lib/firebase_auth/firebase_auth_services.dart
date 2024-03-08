// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!.uid; // Use ! to assert non-null user
    } catch (e) {
      print("There was an error signing up");
      rethrow; // Rethrow the error for better handling
    }
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user!.uid; // Use ! to assert non-null user
    } catch (e) {
      print("There was an error signing in");
      rethrow; // Rethrow the error for better handling
    }
  }

  Future<String> getCurrentUserId() async {
    final User user = _auth.currentUser!; // Use ! to assert non-null user
    return user.uid;
  }
}
