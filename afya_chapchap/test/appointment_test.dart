// ignore_for_file: subtype_of_sealed_class

import 'package:afya_chapchap/services/firestore.dart';
import 'package:afya_chapchap/firebase_options.dart';
import 'package:afya_chapchap/Screens/appointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirestoreService extends Mock implements FirestoreService {}
class MockQuerySnapshot extends Mock implements QuerySnapshot {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}
class MockUser extends Mock implements User {}

Future<void> main() async {
  // Initialize Firebase
   TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  group('AppointmentPage', () {
    testWidgets('appointment screen displays and interacts correctly', (WidgetTester tester) async {
      // Arrange
      final mockFirestoreService = MockFirestoreService();
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();

      when(mockFirestoreService.getUserAppointmentsStream()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn({
        'name': 'Test Appointment',
        'description': 'Test Description',
        'date': '21/03/2024',
        'time': '10:00 AM',
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: AppointmentPage(),
        ),
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(StreamBuilder), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Test Appointment'), findsOneWidget);
      expect(find.text('21/03/2024 at 10:00 AM'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });
  });

  group('AppointmentPageState', () {
    late AppointmentPageState state;
    late MockFirestoreService mockFirestoreService;
    late MockUser mockUser;

    setUp(() {
      mockFirestoreService = MockFirestoreService();
      mockUser = MockUser();
      state = AppointmentPageState();
    });

    testWidgets('openAppointmentBox should show dialog with fields', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: AppointmentPage(),
        ),
      );

      // Act
      state.openAppointmentBox();
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.byType(InkWell), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('_showDatePicker should update date when a new date is selected', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: AppointmentPage(),
        ),
      );
      final selectedDate = DateTime(2023, 4, 15);

      // Act
      await tester.tap(find.byType(InkWell).first);
      await showDatePicker(
        context: tester.element(find.byType(AppointmentPage)),
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );

      // Assert
      expect(state.selectedDate, selectedDate);
      expect(state.dateController.text, '15/4/2023');
    });

    testWidgets('_showTimePicker should update time when a new time is selected', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: AppointmentPage(),
        ),
      );
      const selectedTime = TimeOfDay(hour: 10, minute: 30);

      // Act
      await tester.tap(find.byType(InkWell).last);
      await showTimePicker(
        context: tester.element(find.byType(AppointmentPage)),
        initialTime: TimeOfDay.now(),
      );

      // Assert
      expect(state.selectedTime, selectedTime);
      expect(state.timeController.text, '10:30 AM');
    });

    test('addAppointment should add an appointment to Firestore', () async {
      // Arrange
      when(mockUser.uid).thenReturn('testUserUID');
      when(FirebaseAuth.instance.currentUser).thenReturn(mockUser);

      // Act
      await state.firestoreService.addAppointment(
        'Test Appointment',
        'Test Description',
        '21/03/2024',
        '10:00 AM',
        'testUserUID',
      );

      // Assert
      verify(mockFirestoreService.addAppointment(
        'Test Appointment',
        'Test Description',
        '21/03/2024',
        '10:00 AM',
        'testUserUID',
      )).called(1);
    });

    test('updateAppointment should update an existing appointment in Firestore', () async {
      // Arrange
      const docID = 'testDocID';

      // Act
      await state.firestoreService.updateAppointment(
        docID,
        'Updated Appointment',
        'Updated Description',
        '22/03/2024',
        '11:00 AM',
      );

      // Assert
      verify(mockFirestoreService.updateAppointment(
        docID,
        'Updated Appointment',
        'Updated Description',
        '22/03/2024',
        '11:00 AM',
      )).called(1);
    });

    test('deleteAppointment should delete an appointment from Firestore', () async {
      // Arrange
      const docID = 'testDocID';

      // Act
      await state.firestoreService.deleteAppointment(docID);

      // Assert
      verify(mockFirestoreService.deleteAppointment(docID)).called(1);
    });
  });
}