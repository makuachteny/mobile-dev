import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:afya_chapchap/Screens/profile.dart';

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
          onUpdateProfile: (profileImageUrl, fullName) {}, updateProfile: (String profileImageUrl, String fullName) {  }, 
        ),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Your Name'), findsOneWidget);
    expect(find.byKey(const Key('Full Name label')), findsOneWidget);
    expect(find.byKey(const Key('Age label')), findsOneWidget);
    expect(find.byKey(const Key('Location label')), findsOneWidget);
    expect(find.byKey(const Key('Existing Medical Conditions label')), findsOneWidget);
    expect(find.byKey(const Key('Password label')), findsOneWidget);
    expect(find.text('UPDATE PROFILE'), findsOneWidget);
  });

  testWidgets('ProfilePage should enable update button when form is filled', (WidgetTester tester) async {
    // ignore: unused_local_variable
    final mockProfileCollection = MockProfileCollection();

    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage(
          onUpdateProfile: (profileImageUrl, fullName) {}, updateProfile: (String profileImageUrl, String fullName) {  }, 
        ),
      ),
    );

    final fullNameField = find.byWidgetPredicate((widget) => textFieldMatcher(widget, 'Full Name'));
    final ageField = find.byWidgetPredicate((widget) => textFieldMatcher(widget, 'Age'));
    final locationField = find.byWidgetPredicate((widget) => textFieldMatcher(widget, 'Location'));
    final medicalConditionsField = find.byWidgetPredicate((widget) => textFieldMatcher(widget, 'Your Existing Medical Conditions'));
    final passwordField = find.byWidgetPredicate((widget) => textFieldMatcher(widget, 'Update Password'));
    final updateButton = find.text('UPDATE PROFILE');

    expect(updateButton, findsOneWidget); // Button should be initially present

    await tester.enterText(fullNameField, 'Mary Akinyi');
    await tester.enterText(ageField, '35');
    await tester.enterText(locationField, 'Nairobi');
    await tester.enterText(medicalConditionsField, 'None');
    await tester.enterText(passwordField, 'password');

    expect(updateButton, findsOneWidget); // Button should be present after filling all fields
  });
}

bool textFieldMatcher(Widget widget, String hintText) {
  if (widget is TextField) {
    final inputDecoration = widget.decoration;
    return inputDecoration != null && inputDecoration.hintText == hintText;
  }
  return false;
}
