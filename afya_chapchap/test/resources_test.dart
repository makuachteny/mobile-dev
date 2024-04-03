import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:afya_chapchap/Screens/resources.dart';

void main() {
  group('AfyaChapChapResourcePage', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AfyaChapChapResourcePage()));
      expect(find.byType(AfyaChapChapResourcePage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Icon), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('renders close button correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AfyaChapChapResourcePage()));
      expect(find.byType(Stack), findsNWidgets(2));
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('builds resource sections correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AfyaChapChapResourcePage()));
      expect(find.text('Getting Started Guide'), findsOneWidget);
      expect(find.text('Booking Appointments'), findsOneWidget);
      expect(find.text('Teleconference Tools'), findsOneWidget);
      expect(find.text('Patient Management'), findsOneWidget);
      expect(find.text('Billing and Payments'), findsOneWidget);
      expect(find.text('Training and Support'), findsOneWidget);
      expect(find.text('Security and Compliance'), findsOneWidget);
      expect(find.text('Feedback and Improvement'), findsOneWidget);
      expect(find.text('Mobile Application Downloads'), findsOneWidget);
    });
  });

  group('_buildResourceSection', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AfyaChapChapResourcePage()));
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Text), findsWidgets);
    });
  });
}