// signup_test.dart

import 'package:afya_chapchap/Screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:afya_chapchap/firebase_auth/firebase_auth_services.dart';
import 'package:afya_chapchap/Screens/login.dart'; // Import LoginPage

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  group('FirebaseAuthServices', () {
    late FirebaseAuthServices authServices;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockFirebaseFirestore mockFirebaseFirestore;
    late MockUserCredential mockUserCredential;
    late MockUser mockUser;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirebaseFirestore = MockFirebaseFirestore();
      mockUserCredential = MockUserCredential();
      mockUser = MockUser();

      authServices = FirebaseAuthServices();
      authServices._auth = mockFirebaseAuth;
    });

    group('signUpWithEmailAndPassword', () {
      test('should sign up with email and password', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password';
        const fullname = 'Teny Makuach';
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('userId');
        when(mockUser.photoURL).thenReturn('photoURL');

        // Act
        final result = await authServices.signUpWithEmailAndPassword(
          email: email,
          password: password,
          fullname: fullname,
        );

        // Assert
        expect(result, 'userId');
        verify(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password));
        verify(mockFirebaseFirestore.collection('users').doc('userId').set({
          'uid': 'userId',
          'email': email,
          'fullname': fullname,
          'photoURL': 'photoURL',
        }));
      });

      test('should rethrow error on sign up failure', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password';
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .thenThrow(FirebaseAuthException(code: 'error-code'));

        // Act and assert
        expect(
          () => authServices.signUpWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('_SignUpPageState', () {
      testWidgets('renders sign up form correctly', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: SignUpPage()));

        // Verify that the sign up form elements are rendered
        expect(find.text('Afya Chapchap'), findsOneWidget);
        expect(find.text('Fullname'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.text('Sign Up'), findsOneWidget);
        expect(find.text('Already have an account?'), findsOneWidget);
        expect(find.text('LOG IN'), findsOneWidget);
      });

      testWidgets('navigates to LoginPage on successful sign up', (WidgetTester tester) async {
        // Set up mock for successful sign up
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: 'test@example.com', password: 'password'))
            .thenAnswer((_) async => mockUserCredential);

        await tester.pumpWidget(
          const MaterialApp(
            home: SignUpPage(),
          ),
        );

        // Enter sign up credentials
        await tester.enterText(find.byType(TextField).at(0), 'John Doe');
        await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
        await tester.enterText(find.byType(TextField).at(2), 'password');

        // Tap the sign up button
        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        // Verify that the app navigated to the LoginPage
        expect(find.byType(LoginPage), findsOneWidget);
      });

      test('shows error message on failed sign up', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password';
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .thenThrow(FirebaseAuthException(code: 'error-code'));

        // Act and assert
        expect(
          () => authServices.signUpWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });
  });
}