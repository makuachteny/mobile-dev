import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person),
            ),
            title: const Text('Dr. Smith'),
            subtitle: const Text('Hi, how can I assist you today?'),
            onTap: () {
              // Handle tapping on the message item
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person),
            ),
            title: const Text('Dr. Johnson'),
            subtitle: const Text('Your appointment has been scheduled for tomorrow.'),
            onTap: () {
              // Handle tapping on the message item
            },
          ),
          // Add more ListTile widgets for additional messages
        ],
      ),
    );
  }
}
