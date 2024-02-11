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
