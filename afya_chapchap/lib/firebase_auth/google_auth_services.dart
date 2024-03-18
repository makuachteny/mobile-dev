// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Google sign in
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Begin interactive sign-in process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase
        final user = await FirebaseAuth.instance.signInWithCredential(credential);

        // ignore: unnecessary_null_comparison
        if (user != null) {
          // Collect user information
          final userData = {
            'uid': user.user!.uid,
            'email': user.user!.email,
            'displayName': user.user!.displayName,
            'photoURL': user.user!.photoURL,
          };

          // Add user data to Firestore
          try {
            await FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set(userData);

            print('User data added to Firestore');
          } catch (e) {
            print('Error adding user data to Firestore: $e');
          }
        }
        return user;
      } else {
        print('Google sign-in failed');
        return null;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }
  }
// Remove the incomplete code block
