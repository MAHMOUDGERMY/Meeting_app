import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zoom_clone_tutorial/resources/auth_methods.dart';

import '../resources/jitsi_meet_methods.dart';
import '../widgets/home_meeting_button.dart';
import 'package:http/http.dart' as http;

class MeetingScreen extends StatelessWidget {
  MeetingScreen({Key? key}) : super(key: key);

  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();
  Future<http.Response> sendNotificationToTopic(
      {String? topic, String? title, String? body ,String? room_id}) async {
    const String FCM_ENDPOINT = 'https://fcm.googleapis.com/fcm/send';
    const String FCM_SERVER_KEY = 'AAAAiWvLF3g:APA91bG0Hsu5tqbIvpmBiEErwpENL3_zt8LZSpjYsz8uLPU3mECpcNZMLC-uanqy6JJJiYhZcDA9CNC7splJk9Wsc9ECQ-WpPqw2XeJfdbsK_gyJXH8dVVrVKfumupA0aP74V2HzjEEi';
    final data = {
      "to": "/topics/all",
      "notification": {
        "title": title,
        "body": body,
        "mutable_content": true,
      },
      "data":{
        "room_id" : room_id
      }
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$FCM_SERVER_KEY',
    };

    return await http.post(Uri.parse(FCM_ENDPOINT), body: json.encode(data), headers: headers);
  }
  AuthMethods _authMethods = AuthMethods();
  createNewMeeting() async {
    var random = Random();
    String roomName = (random.nextInt(10000000) + 10000000).toString();
    _jitsiMeetMethods.createMeeting(
        roomName: roomName, isAudioMuted: true, isVideoMuted: true);
    sendNotificationToTopic(title: "live now",
        body: "${_authMethods.user.displayName} create new meet click to join" , room_id:roomName );
  }

  joinMeeting(BuildContext context) {
    Navigator.pushNamed(context, '/video-call');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HomeMeetingButton(
              onPressed: createNewMeeting,
              text: 'New Meeting',
              icon: Icons.videocam,
            ),
            HomeMeetingButton(
              onPressed: () => joinMeeting(context),
              text: 'Join Meeting',
              icon: Icons.add_box_rounded,
            ),
          ],
        ),
      ],
    );
  }
}
