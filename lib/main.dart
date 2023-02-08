import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zoom_clone_tutorial/resources/auth_methods.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/video_call_screen.dart';
import 'utils/colors.dart';
import 'package:notification_permissions/notification_permissions.dart';
import '../resources/jitsi_meet_methods.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  Future<PermissionStatus> permissionStatus =
      NotificationPermissions.getNotificationPermissionStatus();



  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("token : $fcmToken");

  print("-=-=-==-=-=-=-");

  // if (_authMethod.user != null) {
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(_authMethod.user.uid)
  //       .update({"token": fcmToken});
  // }

  FirebaseMessaging.onMessage.listen(
    (event) {
      print(event.data.toString());
    },
  );

  FirebaseMessaging.onMessageOpenedApp.listen(
    (event) {
      print(event.data["room_name"]);
      AuthMethods  _authMethod = AuthMethods();
      JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();
      try{
        print(event.data.values.first);



        _jitsiMeetMethods.createMeeting(
          roomName: event.data.values.first,
          isAudioMuted: true,
          isVideoMuted: true,
          username:_authMethod.user.displayName! ,
        );
      }catch(on){
        print("error $on");
      }



    },
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'reunion',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/video-call': (context) => const VideoCallScreen(),
      },
      home: FirebaseAuth.instance.currentUser != null
          ? const HomeScreen()
          : const LoginScreen(),
      //  StreamBuilder(
      //   stream: AuthMethods().authChanges,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }

      //     if (snapshot.hasData) {
      //       return const HomeScreen();
      //     }

      //     return const LoginScreen();
      //   },
      // ),
    );
  }
}
