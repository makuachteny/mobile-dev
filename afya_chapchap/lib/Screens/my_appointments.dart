import 'package:flutter/material.dart';
import 'meeting_screen.dart';

class EventHistory extends StatefulWidget {
  const EventHistory({super.key});

  @override
  EventHistoryState createState() => EventHistoryState();
}

class EventHistoryState extends State<EventHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Appointments',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView.builder(
        itemCount: eventList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(eventList[index].title),
            subtitle: Text(eventList[index].date),
            onTap: () {
              // Handle the tap for each event
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => const MainScreen()));
            },
          );
        },
      ),
    );
  }
}

class Event {
  final String title;
  final String date;

  Event({required this.title, required this.date});
}

// Sample data for eventList
List<Event> eventList = [
  Event(title: 'Eye check-up', date: '2023-04-25'),
  Event(title: 'ENT', date: '2023-04-20'),
  Event(title: 'Beard exam', date: '2023-04-15'),
  // Add more events here if needed
];