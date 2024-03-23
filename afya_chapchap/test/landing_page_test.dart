import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:afya_chapchap/Screens/landing_page.dart';
import 'package:afya_chapchap/Screens/appointment.dart';
import 'package:afya_chapchap/Screens/login.dart';
import 'package:afya_chapchap/Screens/profile.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  // Initialize Firebase
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  testWidgets('LandingPage should render correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LandingPage(),
      ),
    );

    // Verify that the app bar title is 'AfyaChapChap'
    expect(find.text('AfyaChapChap'), findsOneWidget);

    // Verify that the app bar background color is blue
    final appBar = find.byType(AppBar);
    expect(appBar, findsOneWidget);
    final appBarWidget = tester.widget<AppBar>(appBar);
    expect(appBarWidget.backgroundColor, Colors.blue);

    // Verify that the drawer contains the correct items
    final drawer = find.byType(Drawer);
    expect(drawer, findsOneWidget);
    final drawerWidget = tester.widget<Drawer>(drawer);
    expect(drawerWidget.child, isA<Column>());
    final drawerItems = find.byType(ListTile);
    expect(drawerItems, findsNWidgets(5));

    // Verify that the body contains the correct widgets
    final body = find.byType(Column);
    expect(body, findsOneWidget);
    final bodyWidget = tester.widget<Column>(body);
    expect(bodyWidget.children, hasLength(4));

    // Verify that the 'Book Appointment' button is present
    final bookAppointmentButton = find.byType(ElevatedButton);
    expect(bookAppointmentButton, findsOneWidget);
    final bookAppointmentButtonText = find.text('Book Appointment');
    expect(bookAppointmentButtonText, findsOneWidget);
  });

  testWidgets(
      'LandingPage should navigate to AppointmentPage when button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LandingPage(),
        routes: {
          '/appointment': (context) => const AppointmentPage(),
        },
      ),
    );

    // Tap the 'Book Appointment' button
    await tester.tap(find.text('Book Appointment'));
    await tester.pumpAndSettle();

    // Verify that the navigation occurred correctly
    expect(find.byType(AppointmentPage), findsOneWidget);
  });

  testWidgets(
      'LandingPage should navigate to ProfilePage when Profile item is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LandingPage(),
        routes: {
          '/profile': (context) => ProfilePage(
                updateProfile: (String profileImageUrl, String fullName) {}, onUpdateProfile: (String profileImageUrl, String fullName) {  },
              ),
        },
      ),
    );

    // Tap the 'Profile' item in the drawer
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Verify that the navigation occurred correctly
    expect(find.byType(ProfilePage), findsOneWidget);
  });

  testWidgets(
      'LandingPage should sign out and navigate to LoginPage when Log Out item is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LandingPage(),
        routes: {
          '/login': (context) => const LoginPage(),
        },
      ),
    );

    // Tap the 'Log Out' item in the drawer
    await tester.tap(find.byIcon(Icons.exit_to_app));
    await tester.pumpAndSettle();

    // Verify that the sign out and navigation occurred correctly
    expect(FirebaseAuth.instance.currentUser, isNull);
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
