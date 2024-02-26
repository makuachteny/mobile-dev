import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileCollection {
  final CollectionReference profiles =
      FirebaseFirestore.instance.collection('profiles');

  Future<void> createProfile(
    String userId,
    String fullName,
    int age,
    String location,
    String medicalConditions,
    String password,
    String imagePath,
  ) {
    return profiles.doc(userId).set({
      'fullName': fullName,
      'age': age,
      'location': location,
      'medicalConditions': medicalConditions,
      'password': password,
      'imagePath': imagePath,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<DocumentSnapshot> getProfileStream(String userId) {
    return profiles.doc(userId).snapshots();
  }

  Future<void> updateProfile(
    String userId,
    String fullName,
    int age,
    String location,
    String medicalConditions,
    String password,
    String imagePath,
  ) {
    return profiles.doc(userId).update({
      'fullName': fullName,
      'age': age,
      'location': location,
      'medicalConditions': medicalConditions,
      'password': password,
      'imagePath': imagePath,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteProfile(String userId) {
    return profiles.doc(userId).delete();
  }
}
