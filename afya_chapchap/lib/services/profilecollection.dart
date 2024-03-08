import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../firebase_auth/firebase_auth_services.dart';

class ProfileCollection {
  final CollectionReference _profiles =
      FirebaseFirestore.instance.collection('profiles');
  final Reference _profilesStorage =
      FirebaseStorage.instance.ref().child('profiles');
  final FirebaseAuthServices _firebaseAuthService = FirebaseAuthServices();

  Future<String?> getCurrentUserId() async {
    return await _firebaseAuthService.getCurrentUserId();
  }

  Future<String> uploadImage(File imageFile) async {
    if (imageFile.path.isEmpty) {
      throw ArgumentError('Image file cannot be null or empty.');
    }

    String? userId = await getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('Failed to retrieve current user ID');
    }

    final ref = _profilesStorage.child(userId).child('profile_image.jpg');
    await ref.putFile(imageFile);
    final url = await ref.getDownloadURL();
    return url;
  }

  Future<void> updateProfile({
    required String fullName,
    required int age,
    required String location,
    required String medicalConditions,
    required String password,
    required String imageUrl,
    required String userId,
    required String updatedFullName,
    required int updatedAge,
    required String updatedLocation,
    required String updatedMedicalConditions,
    required String updatedPassword,
    required String updatedImageUrl,
  }) async {
    if (updatedAge < 0) {
      throw ArgumentError('Age must be a non-negative integer.');
    }

    if (updatedMedicalConditions.contains('sensitive_information')) {
      throw ArgumentError(
          'Medical conditions should not contain sensitive information.');
    }

    final profileData = {
      'fullName': updatedFullName,
      'age': updatedAge,
      'location': updatedLocation,
      'medicalConditions': updatedMedicalConditions,
      'password': updatedPassword,
      'imageUrl': updatedImageUrl,
      'timestamp': Timestamp.now(),
    };

    final profileDoc = _profiles.doc(userId);
    final docSnapshot = await profileDoc.get();

    if (docSnapshot.exists) {
      await profileDoc.update(profileData);
    } else {
      await profileDoc.set(profileData);
    }
  }
}
