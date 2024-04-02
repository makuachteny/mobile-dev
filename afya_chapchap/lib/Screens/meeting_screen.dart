import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class MeetingScreen extends StatefulWidget {
  final String meetingLink;

  const MeetingScreen({super.key, required this.meetingLink});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  late final String _userId;
  late final String _userName;

  @override
  void initState() {
    super.initState();
    _userId = const Uuid().v4();
    _userName = 'user_${_userId.substring(0, 7)}';
  }

  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Video Conference'),
    ),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ZegoUIKitPrebuiltVideoConference(
              appID: 1389884693, // Replace with your AppID
              appSign: '1d465e2aaaea1b1d6be5fd75c162717f2261209ad48439cae948979f9f518040', // Replace with your AppSign
              userID: _userId,
              userName: _userName,
              conferenceID: widget.meetingLink, // Use the meeting link as the conference ID
              config: ZegoUIKitPrebuiltVideoConferenceConfig(),
            ),
          ),
        ],
      ),
    ),
  );
}

}
