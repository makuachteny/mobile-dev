import 'package:flutter/material.dart';

class AfyaChapChapResourcePage extends StatelessWidget {
  const AfyaChapChapResourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.waving_hand,
                          color: Color(0xFFE6CF2E),
                          size: 48.0,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Afya',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Chapchap',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Guide',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildResourceSection(
                    title: 'Getting Started Guide',
                    content:
                        'Learn how to sign up as a doctor on AfyaChapChap. Step-by-step instructions on setting up your profile and availability. Guidance on booking appointments and managing your schedule.',
                  ),
                  _buildResourceSection(
                    title: 'Booking Appointments',
                    content:
                        'Access the appointment booking system to schedule consultations with patients. Specify your availability and preferred communication method (video call, audio call, or chat). Reminder settings to keep track of upcoming appointments.',
                  ),
                  _buildResourceSection(
                    title: 'Teleconference Tools',
                    content:
                        'Explore the integrated teleconference feature for seamless doctor-patient communication. Guidelines on conducting successful virtual consultations. Troubleshooting tips for technical issues during calls.',
                  ),
                  _buildResourceSection(
                    title: 'Patient Management',
                    content:
                        'Manage patient records securely within the application. Keep track of patient histories, prescriptions, and follow-up appointments. Ensure compliance with data privacy regulations.',
                  ),
                  _buildResourceSection(
                    title: 'Billing and Payments',
                    content:
                        'Billing functionality to invoice patients for consultations. Secure payment gateways for hassle-free transactions. Resources on managing billing records and financial reports.',
                  ),
                  _buildResourceSection(
                    title: 'Training and Support',
                    content:
                        'Access comprehensive training materials and tutorials. Dedicated support channels for resolving queries and technical issues. Community forums for networking and knowledge sharing among healthcare professionals.',
                  ),
                  _buildResourceSection(
                    title: 'Security and Compliance',
                    content:
                        'Information on data encryption and security protocols. Compliance with healthcare regulations such as HIPAA (Health Insurance Portability and Accountability Act). Regular updates on system enhancements and security patches.',
                  ),
                  _buildResourceSection(
                    title: 'Feedback and Improvement',
                    content:
                        'Share your feedback to help us improve our telehealth platform. Participate in surveys and user research activities. Stay informed about upcoming features and updates based on user suggestions.',
                  ),
                  _buildResourceSection(
                    title: 'Mobile Application Downloads',
                    content:
                        'Links to download the AfyaChapChap mobile application for iOS and Android devices. Compatibility requirements and installation instructions.',
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16.0,
              right: 16.0,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
