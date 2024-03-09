import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  // Sign up with email and password
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? fullname, // Optional fullname for signup
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Collect user data (including optional fullname)
      final userData = {
        'uid': credential.user!.uid,
        'email': email,
        'fullname': fullname ?? "", // Use empty string if fullname not provided
        'photoURL':
            credential.user!.photoURL, // Use default photoURL if available
      };

      // Add user data to Firestore
      await _addUserToFirestore(userData);

      return credential.user!.uid;
    } catch (e) {
      _logger.log(Level.info, "There was an error signing up: $e");
      rethrow; // Rethrow for better handling
    }
  }

  // Sign in with email and password
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Optionally collect additional user data (if available)
      final String displayName = credential.user!.displayName ?? "";
      final String photoURL = credential.user!.photoURL ?? "";

      // Prepare user data map (including potential additional data)
      final userData = {
        'uid': credential.user!.uid,
        'email': email,
        'fullname': displayName, // Add retrieved display name
        'photoURL': photoURL, // Add retrieved photoURL
      };

      // Add user data to Firestore (optional for sign-in)
      await _addUserToFirestore(userData); // Call to store on sign-in

      return credential.user!.uid;
    } catch (e) {
      _logger.log(Level.info, "There was an error signing in: $e");
      rethrow; // Rethrow for better handling
    }
  }

  // Get current user ID
  Future<String> getCurrentUserId() async {
    final User user = _auth.currentUser!;
    return user.uid;
  }

  // Helper function to add user data to Firestore
  Future<void> _addUserToFirestore(Map<String, dynamic> userData) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData['uid'])
          .set(userData);
      _logger.log(Level.info, 'User added to collection!');
    } catch (e) {
      _logger.e('Error adding user to collection: $e');
    }
  }
}
