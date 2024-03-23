// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/profilecollection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final void Function(String profileImageUrl, String fullName) onUpdateProfile;
  const ProfilePage({super.key, required this.onUpdateProfile, required Null Function(String profileImageUrl, String fullName) updateProfile});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _medicalConditionsController =
      TextEditingController();
  File? _image;
  late ProfileCollection _profileCollection;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _profileCollection = ProfileCollection();
    _fetchUserProfile();
  }

    Future<void> _fetchUserProfile() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString('fullName');
    String? profileImageUrl = prefs.getString('profileImageUrl');

  
    // fetch image from the database
    if (profileImageUrl == null) {
      String? userId = await _profileCollection.getCurrentUserId();
      Map<String, dynamic>? userProfile =
          await _profileCollection.getUserProfile(userId!);

      // fetch profile details from database
      if (userProfile != null) {
        setState(() {
          _fullNameController.text = userProfile['fullName'] ?? '';
          _ageController.text =
              userProfile['age'] != null ? userProfile['age'].toString() : '';
          _locationController.text = userProfile['location'] ?? '';
          _medicalConditionsController.text =
              userProfile['medicalConditions'] ?? '';
          _passwordController.text = ''; // Clear password field
          _profileImageUrl = userProfile['profileImageUrl'];

          // Store fetched profile details in SharedPreferences
          prefs.setString('fullName', fullName!);
          prefs.setString('profileImageUrl', _profileImageUrl!);
          prefs.setString('age', _ageController.text);
          prefs.setString('location', _locationController.text);
          prefs.setString('medicalConditions', _medicalConditionsController.text);
        });
      }
    } else {
      // set the state with the fetched details
      setState(() {
        _fullNameController.text = fullName ?? '';
        _profileImageUrl = profileImageUrl;
        _ageController.text = prefs.getString('age') ?? '';
        _locationController.text = prefs.getString('location') ?? '';
        _medicalConditionsController.text = prefs.getString('medicalConditions') ?? '';
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching user profile: $e');
      // Handle error
    }
  }


  Future<void> _updateProfile() async {
    try {
      String fullName = _fullNameController.text;
      int age = int.tryParse(_ageController.text) ?? 0;
      String location = _locationController.text;
      String medicalConditions = _medicalConditionsController.text;
      String password = _passwordController.text;

      String imageUrl = '';
      if (_image != null) {
        imageUrl = await _profileCollection.uploadImage(_image!);
      }

      String? userId = await _profileCollection.getCurrentUserId();
      if (userId == null) {
        throw Exception('Current user ID is null');
      }

    await _profileCollection.updateProfile(
      fullName: fullName,
      age: age,
      location: location,
      medicalConditions: medicalConditions,
      password: password,
      imageUrl: imageUrl,
      userId: userId,
      updatedFullName: fullName,
      updatedAge: age,
      updatedLocation: location,
      updatedMedicalConditions: medicalConditions,
      updatedPassword: password,
      updatedImageUrl: imageUrl,
    );

    // After successfully updating the profile
      widget.onUpdateProfile(imageUrl, fullName);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fullName', fullName);
      prefs.setString('profileImageUrl', imageUrl);
      prefs.setString('age', age.toString());
      prefs.setString('location', location);
      prefs.setString('medicalConditions', medicalConditions);

      // After successfully updating the profile
    widget.onUpdateProfile(imageUrl, fullName);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
      // ignore: avoid_print
      print('Error updating profile: $e');
    }
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Photo Library'),
                            onTap: () {
                              getImage(ImageSource.gallery);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_camera),
                            title: const Text('Camera'),
                            onTap: () {
                              getImage(ImageSource.camera);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage: _image != null
                      ? FileImage(_image!)
                      : _profileImageUrl != null
                      ?NetworkImage(_profileImageUrl!)
                      :null as ImageProvider<Object>?,
                    ),
                  ),                

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Update Profile Details',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue[900],
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
                hintText: 'Your Existing Medical Conditions',
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
              onPressed: _updateProfile,
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}


// ignore: camel_case_types


