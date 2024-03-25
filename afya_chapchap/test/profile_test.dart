import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:afya_chapchap/Screens/profile.dart';
import 'package:mockito/mockito.dart';

class MockProfileCollection extends Mock {
  Future<String?> getCurrentUserId() async {
    return 'mockUserId';
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    return {
      'fullName': 'Mary Akinyi',
      'age': 35,
      'location': 'Nairobi',
      'medicalConditions': 'None',
      'profileImageUrl': 'https://example.com/profile.jpg',
    };
  }

  Future<String> uploadImage(File image) async {
    return 'https://example.com/uploaded-image.jpg';
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
  }) async {}
}

void main() {
  testWidgets('ProfilePage should display UI elements correctly', (WidgetTester tester) async {
    // ignore: unused_local_variable
    final mockProfileCollection = MockProfileCollection();

    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage(
          onUpdateProfile: (profileImageUrl, fullName) {},
          updateProfile: (String profileImageUrl, String fullName) {},
        ),
      ),
    );

    // Verify the presence of the AppBar
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify the presence of the profile picture circle avatar
    expect(find.byType(CircleAvatar), findsOneWidget);

    // Verify the presence of the text fields
    expect(find.byType(TextField), findsNWidgets(5));
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Your Existing Medical Conditions'), findsOneWidget);
    expect(find.text('Update Password'), findsOneWidget);

    // Verify the presence of the update button
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Update Profile'), findsOneWidget);
  });

  testWidgets('ProfilePage should enable update button when form is filled', (WidgetTester tester) async {
    // ignore: unused_local_variable
    final mockProfileCollection = MockProfileCollection();

    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage(
          onUpdateProfile: (profileImageUrl, fullName) {},
          updateProfile: (String profileImageUrl, String fullName) {},
        ),
      ),
    );

    // Find the text fields
    final fullNameField = find.byType(TextField).first;
    final ageField = find.byType(TextField).at(1);
    final locationField = find.byType(TextField).at(2);
    final medicalConditionsField = find.byType(TextField).at(3);
    final passwordField = find.byType(TextField).last;

    // Enter text into the text fields
    await tester.enterText(fullNameField, 'Mary Akinyi');
    await tester.enterText(ageField, '35');
    await tester.enterText(locationField, 'Nairobi');
    await tester.enterText(medicalConditionsField, 'None');
    await tester.enterText(passwordField, 'password');

    // Verify that the 'Update Profile' button is enabled
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
      isTrue,
    );
  });
}