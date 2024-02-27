import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
    // get collection of appointments
  final CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

//CREATE: add a new appointment
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

 //READ: get appointments from the database
  Stream<QuerySnapshot> getAppointmentsStream() {
    final appointmentsStream =
        appointments.orderBy('timestamp', descending: true).snapshots();

    return appointmentsStream;
  }

  //UPDATE: update appointments given a doc id
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

  //DELETE: delete appointments given a doc id
  Future<void> deleteAppointment(String docID) {
    return appointments.doc(docID).delete();
  }
}
