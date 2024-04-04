// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/profilecollection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:afya_chapchap/firebase_options.dart';

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

class ProfilePage extends StatefulWidget {
  final void Function(String profileImageUrl, String fullName) onUpdateProfile;

  const ProfilePage({
    super.key,
    required this.onUpdateProfile, required Null Function(String profileImageUrl, String fullName) updateProfile,
  });

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
    _initializeFirebase().then((_) {
      _profileCollection = ProfileCollection();
      _fetchUserProfile();
    });
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
            _ageController.text = userProfile['age'] != null
                ? userProfile['age'].toString()
                : '';
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
            prefs.setString('medicalConditions',
                _medicalConditionsController.text);
          });
        }
      } else {
        setState(() {
          _fullNameController.text = fullName ?? '';
          _profileImageUrl = profileImageUrl;
          _ageController.text = prefs.getString('age') ?? '';
          _locationController.text = prefs.getString('location') ?? '';
          _medicalConditionsController.text =
              prefs.getString('medicalConditions') ?? '';
        });
      }
    } catch (e) {
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

      widget.onUpdateProfile(imageUrl, fullName);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fullName', fullName);
      prefs.setString('profileImageUrl', imageUrl);
      prefs.setString('age', age.toString());
      prefs.setString('location', location);
      prefs.setString('medicalConditions', medicalConditions);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : _profileImageUrl != null
                                  ? NetworkImage(_profileImageUrl!)
                                  : null as ImageProvider<Object>?,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _fullNameController.text.isNotEmpty
                              ? _fullNameController.text
                              : 'Your Name',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Update Profile Details',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF424242),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFieldWithLabel(
                    label: 'Full Name',
                    controller: _fullNameController,
                    placeholder: 'Full Name',
                  ),
                  _buildTextFieldWithLabel(
                    label: 'Age',
                    controller: _ageController,
                    placeholder: 'Age',
                  ),
                  _buildTextFieldWithLabel(
                    label: 'Location',
                    controller: _locationController,
                    placeholder: 'Location',
                  ),
                  _buildTextFieldWithLabel(
                    label: 'Existing Medical Conditions',
                    controller: _medicalConditionsController,
                    placeholder: 'Your Existing Medical Conditions',
                  ),
                  _buildTextFieldWithLabel(
                    label: 'Password',
                    controller: _passwordController,
                    placeholder: 'Update Password',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _updateProfile,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'UPDATE PROFILE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel({
    required String label,
    required TextEditingController controller,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          key: Key('$label label'), // Add key here
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF424242),
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: placeholder,
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
