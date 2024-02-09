import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: const Color.fromARGB(255, 46, 146, 246),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(0xFF0EA9FF),
      ).copyWith(
        background: const Color(0xFFE0E0E0),
      ),
    ),
    home: const ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _medicalConditionsController =
      TextEditingController();
  File? _image;

  Future<void> getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: getImage,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: _image != null ? Colors.transparent : Theme.of(context).colorScheme.background,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Full Name',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Update Profile Details',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                hintText: 'Full Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                hintText: 'Age',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Location',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _medicalConditionsController,
              decoration: const InputDecoration(
                hintText: 'Existing Medical Conditions',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Update Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement profile update logic
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
