import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appointment.dart';
import 'login.dart';
import 'resources.dart';
import 'profile.dart';
import 'ml_learning.dart';

import '../firebase_options.dart';

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LandingPageStateful();
  }
}

class LandingPageStateful extends StatefulWidget {
  const LandingPageStateful({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPageStateful> {
  String _fullName = 'Your Name'; // Initialize with default value
  String? _profileImageUrl; // Initialize with null

  @override
  void initState() {
    
    super.initState();
    _initializeFirebase();
    _fetchProfileData(); // Fetch profile data when the widget initializes
  }

  // Define a method to retrieve profile data
  Future<void> _fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullName') ?? 'Your Name';
      _profileImageUrl = prefs.getString('profileImageUrl');
    });
  }

  // Define a method to update the profile
  void _updateProfile(String profileImageUrl, String fullName) {
    // Update the state with the new profile data
    setState(() {
      _profileImageUrl = profileImageUrl;
      _fullName = fullName;
    });

    // Store updated profile data persistently
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('fullName', fullName);
      prefs.setString('profileImageUrl', profileImageUrl);
    });
  }

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
        centerTitle: true,
      ),
      drawer: DrawerScreen(
        fullName: _fullName,
        profileImageUrl: _profileImageUrl,
        onUpdateProfile: _updateProfile,
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
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Merriweather',
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => AppointmentPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add,
                      color: Colors.black, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Book Appointment',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Merriweather',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerScreen extends StatelessWidget {
  final String fullName;
  final String? profileImageUrl;
  final Function(String, String) onUpdateProfile;

  const DrawerScreen({super.key, 
    required this.fullName,
    required this.profileImageUrl,
    required this.onUpdateProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.white, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : null,
                    child: profileImageUrl == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text(
                    'Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProfilePage(
                          onUpdateProfile: onUpdateProfile,
                          updateProfile:
                              (String profileImageUrl, String fullName) {},
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.calendar_today, color: Colors.white),
                  title: const Text(
                    'Appointments',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AppointmentPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.library_books, color: Colors.white),
                  title: const Text(
                    'Resources',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const AfyaChapChapResourcePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.code, color: Colors.white),
                  title: const Text(
                    'ML Model',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  const Model()),
                    );
                  },
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.white),
                title: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white),
                ),
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
    );
  }
}
