import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'appointment.dart';
import 'message_screen.dart';
import 'login.dart';
import 'resources.dart';
import 'profile.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'AfyaChapChap',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      // Replace with your profile picture
                      backgroundImage: AssetImage('assets/imgs/profile_pic.png'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Your Name', // Assuming 'Your Name' is a valid constant string
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                             ProfilePage(updateProfile: (String profileImageUrl, String fullName) { },),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Appointments'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const MessageScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.library_books),
                  title: const Text('Resources'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const AfyaChapChapResourcePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Spacer(), // Added Spacer to push the "Log Out" button to the bottom
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ), // Added bottom padding for "Log Out" button
              child: ListTile(
                // Added ListTile for "Log Out" functionality
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Log Out'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/imgs/doctor_animation.png',
            height: 400,
            width: 700,
          ),
          const SizedBox(height: 30),
          const Text(
            'Welcome to AfyaChapChap',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const AppointmentPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Book Appointment'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
