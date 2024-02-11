import 'package:flutter/material.dart';

class AfyaChapChapResourcePage extends StatelessWidget {
  const AfyaChapChapResourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AfyaChapChap Resource Page'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResourceCard(
              title: 'Getting Started Guide',
              description:
                  'Learn how to sign up as a doctor on AfyaChapChap. Step-by-step instructions on setting up your profile and availability. Guidance on booking appointments and managing your schedule.',
            ),
            SizedBox(height: 20.0),
            ResourceCard(
              title: 'Booking Appointments',
              description:
                  'Access the appointment booking system to schedule consultations with patients. Specify your availability and preferred communication method (video call, audio call, or chat). Reminder settings to keep track of upcoming appointments.',
            ),
            SizedBox(height: 20.0),
            ResourceCard(
              title: 'Teleconference Tools',
              description:
                  'Explore the integrated teleconference feature for seamless doctor-patient communication. Guidelines on conducting successful virtual consultations. Troubleshooting tips for technical issues during calls.',
            ),
            SizedBox(height: 20.0),
            ResourceCard(
              title: 'Patient Management',
              description:
                  'Manage patient records securely within the application. Keep track of patient histories, prescriptions, and follow-up appointments. Ensure compliance with data privacy regulations.',
            ),
            SizedBox(height: 20.0),
            ResourceCard(
              title: 'Billing and Payments',
              description:
                  'Billing functionality to invoice patients for consultations. Secure payment gateways for hassle-free transactions. Resources on managing billing records and financial reports.',
            ),
            SizedBox(height: 20.0),
            ResourceCard(
              title: 'Training and Support',
              description:
                  'Access comprehensive training materials and tutorials. Dedicated support channels for resolving queries and technical issues. Community forums for networking and knowledge sharing among healthcare professionals.',
            ),
            SizedBox(height: 20.0),
            ResourceCard(
              title: 'Security and Compliance',
              description:
                  'Information on data encryption and security protocols. Compliance with healthcare regulations such as HIPAA (Health Insurance Portability and Accountability Act). Regular updates on system enhancements and security patches.',
            ),
            SizedBox(height: 20.0),
            ResourceCard(
              title: 'Feedback and Improvement',
              description:
                  'Share your feedback to help us improve our telehealth platform. Participate in surveys and user research activities. Stay informed about upcoming features and updates based on user suggestions.',
            ),
            SizedBox(height: 20.0),
            ResourceCard(
              title: 'Mobile Application Downloads',
              description:
                  'Links to download the AfyaChapChap mobile application for iOS and Android devices. Compatibility requirements and installation instructions.',
            ),
            SizedBox(height: 20.0),
            ResourceCard(
              title: 'Community Resources',
              description:
                  'Join our online community of healthcare professionals. Engage in discussions, share insights, and collaborate on patient care. Access educational resources and industry news updates.',
            ),
          ],
        ),
      ),
    );
  }
}

class ResourceCard extends StatelessWidget {
  final String title;
  final String description;

  const ResourceCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Add functionality here to handle card click
        print('Clicked on: $title');
      },
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'AfyaChapChap Resource Page',
    home: AfyaChapChapResourcePage(),
  ));
}
