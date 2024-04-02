import 'package:afya_chapchap/Screens/meeting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:afya_chapchap/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class AppointmentPage extends StatefulWidget {
  String meetingLink = '';
  AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => AppointmentPageState();
}

class AppointmentPageState extends State<AppointmentPage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book an Appointment',
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAppointmentBox(),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 4.0),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getUserAppointmentsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List appointmentsList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: appointmentsList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = appointmentsList[index];
                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String name = data['name'];
                String description = data['description'];
                String date = data['date'];
                String time = data['time'];

                return InkWell(
                  // Wrapped the appointment item with InkWell for tap handling
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        contentPadding: const EdgeInsets.all(40),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text(name),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$date at $time',
                              style: const TextStyle(
                              fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              description,
                              style: const TextStyle(
                              fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (data['meetingLink'] != null &&
                                data['meetingLink'].isNotEmpty)
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MeetingScreen(
                                          meetingLink: data['meetingLink']),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Meeting Link: ${data['meetingLink']}",
                                  style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(date),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => openAppointmentBox(
                            docID: docID,
                            // Pass a callback function to update the main UI after saving the appointment
                            updateCallback: () {
                              setState(() {
                                // No need to do anything here, just trigger a rebuild
                              });
                            },
                          ),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () =>
                              firestoreService.deleteAppointment(docID),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text("No appointments...");
          }
        },
      ),
    );
  }

  void openAppointmentBox({String? docID, Function? updateCallback}) {
    String newMeetingLink = '';

    nameController.clear();
    descriptionController.clear();
    dateController.clear();
    timeController.clear();

    if (docID == null) {
      // Generate a new meeting link for a new appointment
      var uuid = const Uuid();
      newMeetingLink = 'https://afyachapchap/meeting/${uuid.v4()}';
    }

     // ignore: unused_local_variable
     String? existingMeetingLink;
    if (docID != null) {
  // Pre-fill the text fields with the existing appointment data
  Future<DocumentSnapshot<Object?>> futureDocument =
      firestoreService.getAppointmentDocument(docID);

  futureDocument.then((document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    nameController.text = data['name'];
    descriptionController.text = data['description'];
    dateController.text = data['date'];
    timeController.text = data['time'];
    existingMeetingLink = data['meetingLink'];
  });
}

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _showDatePicker(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          dateController.text.isNotEmpty
                              ? dateController.text
                              : '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: InkWell(
                    onTap: () => _showTimePicker(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Time',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          timeController.text.isNotEmpty
                              ? timeController.text
                              : selectedTime.format(context),
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                String userUID = FirebaseAuth.instance.currentUser?.uid ?? '';
                firestoreService.addAppointment(
                  nameController.text,
                  descriptionController.text,
                  dateController.text,
                  timeController.text,
                  userUID,
                  meetingLink: newMeetingLink,
                );
              } else {
                firestoreService.updateAppointment(
                  docID,
                  nameController.text,
                  descriptionController.text,
                  dateController.text,
                  timeController.text,
                  existingMeetingLink ?? '',
                );
              }
              nameController.clear();
              descriptionController.clear();
              dateController.clear();
              timeController.clear();
              Navigator.pop(context);
              if (updateCallback != null) {
              updateCallback();
            }
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  void _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        timeController.text = pickedTime.format(context);
      });
    }
  }
}
