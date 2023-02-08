import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/login_screen.dart';
import '../utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  Stream<User?> get authChanges => _auth.authStateChanges();
  User get user => _auth.currentUser!;

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {

        // if (userCredential.additionalUserInfo!.isNewUser) {
          FirebaseMessaging.instance.getToken().then((value)async {
            String? token = value;
            print(token!);
            print("-------------------------------------------------");

            await _firestore.collection('users').doc(user.uid).set({
              'username': user.displayName,
              'uid': user.uid,
              'profilePhoto': user.photoURL,
              "job": "",
              "isAdmin": false,
              "token": token
            }).then((value) async{
              print("toooopics.............");
              FirebaseMessaging messaging = FirebaseMessaging.instance;
              await messaging.subscribeToTopic('all');
            });
          });

        // }
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, false);
      res = false;
    }
    return res;
  }

  void signOut(context) async {
    try {
      _auth.signOut();
      googleSignIn.signOut();
      FirebaseMessaging.instance.deleteToken();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginScreen()));
      await DefaultCacheManager().emptyCache();
    } catch (e) {
      print(e);
    }
  }
}
