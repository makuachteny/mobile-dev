import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileCollection {
  final CollectionReference _profiles =
      FirebaseFirestore.instance.collection('profiles');

  Future<String> uploadImage(String userId, File imageFile) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profiles')
          .child(userId)
          .child('profile_image.jpg');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error uploading image: $e');
      return ''; // or throw an exception here based on your error handling strategy
    }
  }

  Future<void> createProfile(
    String userId,
    String fullName,
    int age,
    String location,
    String medicalConditions,
    String password,
    String imagePath,
  ) async {
    try {
      await _profiles.doc(userId).set({
        'fullName': fullName,
        'age': age,
        'location': location,
        'medicalConditions': medicalConditions,
        'password': password,
        'imagePath': imagePath,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error creating profile: $e');
      // Throw an error or handle it in your UI as needed
    }
  }

  Stream<DocumentSnapshot> getProfileStream(String userId) {
    return _profiles.doc(userId).snapshots();
  }

  Future<void> updateProfile(
    String userId,
    String fullName,
    int age,
    String location,
    String medicalConditions,
    String password,
    String imagePath,
  ) async {
    try {
      await _profiles.doc(userId).update({
        'fullName': fullName,
        'age': age,
        'location': location,
        'medicalConditions': medicalConditions,
        'password': password,
        'imagePath': imagePath,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error updating profile: $e');
      // Throw an error or handle it in your UI as needed
    }
  }

  Future<void> deleteProfile(String userId) async {
    try {
      await _profiles.doc(userId).delete();
    } catch (e) {
      print('Error deleting profile: $e');
      // Throw an error or handle it in your UI as needed
    }
  }
}
