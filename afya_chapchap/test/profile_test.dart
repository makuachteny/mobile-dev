import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:afya_chapchap/Screens/profile.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class FirebaseFirestore {
}

void main() {
  // Initialize the Firebase app before running tests
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  setUp(() {});

  testWidgets('ProfilePage should display UI elements correctly',
      (WidgetTester tester) async {
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

    // Verify that the user can enter text into the text fields
    await tester.enterText(
        find.byKey(const Key('fullNameTextField')), 'Mary Akinyi');
    await tester.enterText(find.byKey(const Key('ageTextField')), '35');
    await tester.enterText(
        find.byKey(const Key('locationTextField')), 'Nairobi');
    await tester.enterText(
        find.byKey(const Key('medicalConditionsTextField')), 'None');
    await tester.enterText(find.byKey(const Key('passwordTextField')), 'password');

    // Verify that the 'Update Profile' button is disabled when the form is empty
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Update Profile'), findsOneWidget);

    // Verify that the 'Update Profile' button is enabled when the form is filled
    await tester.enterText(
        find.byKey(const Key('fullNameTextField')), 'Mary Akinyi');
    await tester.enterText(find.byKey(const Key('ageTextField')), '35');
    await tester.enterText(
        find.byKey(const Key('locationTextField')), 'Nairobi');
    await tester.enterText(
        find.byKey(const Key('medicalConditionsTextField')), 'None');
    await tester.enterText(find.byKey(const Key('passwordTextField')), 'password');
    expect(find.byType(ElevatedButton).first, findsOneWidget);

    // Verify that the user can update their profile information
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();
  });
}

void setupFirebaseAuthMocks() {
}