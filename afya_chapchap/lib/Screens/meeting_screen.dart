import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video Conference',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // This is the ID of this conference. We'll use this harcoded value
  // for now, but you should use a custom ID managed by your system
  // in order to manage all conferences.
  final String _conferenceId = 'my_conference';

  late final String _userId;
  late final String _userName;

  @override
  void initState() {
    super.initState();

    // We will create a random ID for now. But you should
    // use the ID that you already use for your users,
    // and the username that each of them have.
    _userId = const Uuid().v4();
    _userName = 'user_${_userId.substring(0, 7)}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // You just need to add this widget in order to
      // add the functionality to your app.
      child: ZegoUIKitPrebuiltVideoConference(
        // Add the AppID and AppSign that you saw before in
        // the project configuration in the Dashboard
        appID: 1389884693,
        appSign: '1d465e2aaaea1b1d6be5fd75c162717f2261209ad48439cae948979f9f518040',
        userID: _userId,
        userName: _userName,
        conferenceID: _conferenceId,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'message_screen.dart';

// class Meeting extends StatelessWidget {
//   const Meeting({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       body: Stack(
//         children: [
//           Center(
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: const PlaceholderWidget(), // Placeholder widget for now
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.black,
//                   child: IconButton(
//                     icon: const Icon(Icons.mic),
//                     onPressed: () {
//                       // Handle audio button click
//                     },
//                     color: Colors.blue,
//                   ),
//                 ),
//                 CircleAvatar(
//                   backgroundColor: Colors.black,
//                   child: IconButton(
//                     icon: const Icon(Icons.videocam),
//                     onPressed: () {
//                       // Handle video button click
//                     },
//                     color: Colors.blue,
//                   ),
//                 ),
//                 CircleAvatar(
//                   backgroundColor: Colors.black,
//                   child: IconButton(
//                     onPressed: () {
//                       // Handle message button click
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const MessageScreen(),
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.message),
//                   ),
//                 ),
//                 CircleAvatar(
//                   backgroundColor: Colors.black,
//                   child: IconButton(
//                     icon: const Icon(Icons.call_end),
//                     onPressed: () {
//                       // Handle hang up button click
//                     },
//                     color: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             left: 10,
//             top: 10,
//             child: Draggable<bool>(
//               data: true,
//               childWhenDragging: Container(), // Display local video
//               feedback: Container(
//                 height: 200,
//                 width: 150,
//                 color: Colors.black,
//                 child: const Icon(
//                   Icons.videocam_off_rounded,
//                   color: Colors.white,
//                 ),
//               ),
//               child: const PlaceholderWidget(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PlaceholderWidget extends StatelessWidget {
//   const PlaceholderWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Waiting for remote video...',
//         style: TextStyle(fontSize: 16),
//       ),
//     );
//   }
// }
