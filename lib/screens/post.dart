import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';
import '../utils/colors.dart';

class Post extends StatefulWidget {
  final post;
  final id;
  const Post({Key? key, this.post, this.id}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final AuthMethods _authMethods = AuthMethods();

  List comments = [];
  void getComments() async {
    print(widget.id);
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.id)
        .collection("comments")
        .get()
        .then((value) {
      comments = value.docs;
      setState(() {});
    });
  }

  void initState() {
    // TODO: implement initState
    getComments();
    super.initState();
  }

  TextEditingController cont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(children: [
          Expanded(
              child: SizedBox(
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.post["img"],
                    fit: BoxFit.cover,
                  )
                  //  Image.network(
                  //   widget.post["img"],
                  //   fit: BoxFit.cover,
                  // ),
                  )),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: cont,
            maxLines: 1,
            onSubmitted: (value) async {
              print(value);

              if (value.length > 0) {
                await FirebaseFirestore.instance
                    .collection("posts")
                    .doc(widget.id)
                    .collection("comments")
                    .add({
                  "comment": value,
                  "name": _authMethods.user.displayName,
                  "img": _authMethods.user.photoURL,
                }).then((value) {
                  getComments();
                  setState(() {
                    cont.clear();
                  });
                });
              }
            },
            textAlign: TextAlign.center,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              fillColor: secondaryBackgroundColor,
              filled: true,
              border: InputBorder.none,
              hintText: 'Write comment ....',
              contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
            ),
          ),
          Expanded(
              child: ListView.separated(
                  separatorBuilder: ((context, index) => Divider()),
                  itemCount: comments.length,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(comments[index]["img"]),
                                  radius: 20,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(comments[index]["name"])
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(comments[index]["comment"]),
                          ],
                        ),
                      )
                  // Container(
                  //       padding:
                  //           EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               Column(
                  //                 children: [
                  //                   CircleAvatar(
                  //                       radius: 30,
                  //                       backgroundColor: Colors.white,
                  //                       backgroundImage: NetworkImage(
                  //                           comments[index]["img"])),
                  //                   Text(
                  //                     comments[index]["name"],
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         fontSize: 15),
                  //                   )
                  //                 ],
                  //               ),
                  //               const SizedBox(
                  //                 width: 15,
                  //               ),
                  //               Expanded(
                  //                 child: Text(
                  //                   comments[index]["comment"],
                  //                   overflow: TextOverflow.ellipsis,
                  //                   maxLines: 4,
                  //                   softWrap: true,
                  //                   style: TextStyle(
                  //                       color: Colors.grey,
                  //                       fontWeight: FontWeight.w700),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     )))
                  ))
        ]),
      ),
    );
  }
}
