import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google sign in
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Begin interactive sign-in process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        // Obtain auth details
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        // Handle sign-in cancellation
        print('Google sign-in canceled.');
        return null;
      }
    } catch (e) {
      // Handle sign-in errors
      print('Error signing in with Google: $e');
      return null;
    }
  }
}