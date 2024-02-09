import 'package:flutter/material.dart';

GlobalKey<EventHistoryState> eventHistoryKey = GlobalKey<EventHistoryState>();


void main() => runApp(MaterialApp(
      home: EventHistory(bookedEvent: Event(title: '', date: '', description: ''),
      ),
    ));
    
class EventHistory extends StatefulWidget {
  final Event bookedEvent;
  const EventHistory({super.key, required this.bookedEvent});

  @override
  EventHistoryState createState() => EventHistoryState();
}

class EventHistoryState extends State<EventHistory> {
  List<Event> bookedEvents = [];

  void addBookedEvent(Event event) {
    setState(() {
      bookedEvents.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Displaying the booked event received from the BookMeetingPage
    addBookedEvent(widget.bookedEvent);
  
    return Scaffold(
      key: eventHistoryKey,
      appBar: AppBar(
        title: const Text('Event History'),
      ),
      body: ListView.builder(
        itemCount: bookedEvents.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(bookedEvents[index].title),
            subtitle: Text(bookedEvents[index].date),
          );
        },
      ),
    );
  }
}

class Event {
  final String title;
  final String date;
  final String description;

  Event({required this.title, required this.date, required this.description});
}
// Sample data for eventList
List<Event> eventList = [
  Event(title: 'Event 1', date: '2023-04-25', description: ''),
  Event(title: 'Event 2', date: '2023-04-20', description: ''),
  Event(title: 'Event 3', date: '2023-04-15', description: ''),
  // Add more events here if needed
];