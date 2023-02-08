import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';

import 'post.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthMethods _authMethods = AuthMethods();
  bool isUpload = false;
  final storageRef = FirebaseStorage.instance.ref();
  XFile? pickedFile;
  void pickImage() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      isUpload = true;
      setState(() {});
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("images/${Uri.file(pickedFile!.path).pathSegments.last}");
      UploadTask uploadTask = reference.putFile(File(pickedFile!.path));

      await uploadTask.whenComplete(() => {
            reference.getDownloadURL().then((value) async {
              await FirebaseFirestore.instance.collection("posts").add(
                  {"img": value, "uid": _authMethods.user.uid}).then((value) {
                getPosts();
              });
            })
          });

      setState(() {
        isUpload = false;
        showSnackBar(context, "image upload successfully", true);
      });
    }
  }

  var data = [];
  TextEditingController cont = TextEditingController();
  void getJob() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: _authMethods.user.uid)
        .get()
        .then((value) {
      data = value.docs;
      cont.text = data[0]["job"];
      setState(() {});
    });
  }

  List posts = [];
  void getPosts() async {
    await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: _authMethods.user.uid)
        .get()
        .then((value) {
      posts = value.docs;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getJob();
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            pickImage();
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            if (isUpload == true)
              const LinearProgressIndicator()
            else
              const SizedBox(),

            CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                backgroundImage: CachedNetworkImageProvider(
                  "${_authMethods.user.photoURL}",
                )
                //  NetworkImage("${_authMethods.user.photoURL}")
                ),
            const SizedBox(
              height: 20,
            ),

            Text(
              "${_authMethods.user.displayName}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),

            Text(
              "${_authMethods.user.email}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(
              height: 20,
            ),
            if (_authMethods.user.phoneNumber != null)
              Text("${_authMethods.user.phoneNumber}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),

            TextField(
              controller: cont,
              maxLines: 1,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                fillColor: secondaryBackgroundColor,
                filled: true,
                border: InputBorder.none,
                hintText: 'Job title',
                contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
              ),
            ),

            IconButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(_authMethods.user.uid)
                      .set({
                    'username': _authMethods.user.displayName,
                    'uid': _authMethods.user.uid,
                    'profilePhoto': _authMethods.user.photoURL,
                    "job": cont.text
                  }).then((value) {
                    print("updated successfully");
                  });
                },
                icon: const Icon(Icons.file_download_done)),

            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemCount: posts.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Post(
                                      post: posts[index],
                                      id: posts[index].id,
                                    )));
                      },
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: posts[index]["img"],
                          fit: BoxFit.cover,
                        ),
                        //  Image.network(
                        //   posts[index]["img"],
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    );
                  }),
            ),

            // CustomButton(text: 'Log Out', onPressed: () => AuthMethods().signOut()),
          ],
        ),
      ),
    );
  }
}
