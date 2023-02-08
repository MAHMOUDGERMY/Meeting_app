import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zoom_clone_tutorial/screens/chat.dart';
import 'package:zoom_clone_tutorial/screens/rating.dart';

import '../resources/auth_methods.dart';
import 'post.dart';

class UserProfile extends StatefulWidget {
  final userData;
  const UserProfile({Key? key, required this.userData}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  final AuthMethods _authMethods = AuthMethods();

  List posts = [];
  Map user = {};
  void getAdmin() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: _authMethods.user.uid)
        .get()
        .then((value) {
      user = value.docs[0].data();
      setState(() {});
    });
  }

  void getPosts() async {
    print(widget.userData["uid"]);
    await FirebaseFirestore.instance
        .collection("posts")
        .where("uid", isEqualTo: widget.userData["uid"])
        .get()
        .then((value) {
      posts = value.docs;
      setState(() {});
    });
  }

  void initState() {
    getAdmin();
    getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employe profile"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat(
                              userData: widget.userData,
                            )));
              },
              icon: const Icon(Icons.send)),
          user["isAdmin"] == true
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Rating(
                              userData: widget.userData,
                            )));
                  },
                  icon: const Icon(Icons.rate_review_outlined))
              : SizedBox()
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              backgroundImage:
                  NetworkImage("${widget.userData["profilePhoto"]}"),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "${widget.userData["username"]}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "${widget.userData["job"] ?? "job title"} ",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              height: 20,
            ),
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
                      child: CachedNetworkImage(
                        imageUrl: posts[index]["img"],
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
