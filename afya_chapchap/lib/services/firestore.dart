import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

  Future<void> addAppointment(
    String name,
    String description,
    String date,
    String time,
  ) {
    return appointments.add({
      'name': name,
      'description': description,
      'date': date,
      'time': time,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getAppointmentsStream() {
    final appointmentsStream =
        appointments.orderBy('timestamp', descending: true).snapshots();

    return appointmentsStream;
  }

  Future<void> updateAppointment(
    String docID,
    String name,
    String description,
    String date,
    String time,
  ) {
    return appointments.doc(docID).update({
      'name': name,
      'description': description,
      'date': date,
      'time': time,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteAppointment(String docID) {
    return appointments.doc(docID).delete();
  }
}
