import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zoom_clone_tutorial/resources/auth_methods.dart';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  final userData;
  const Chat({Key? key, this.userData}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  AuthMethods _authMethods = AuthMethods();
  TextEditingController textCon = TextEditingController();
  bool text = false;
  void sendMessage(
      {required String text,
      required String reciverId,
      required Timestamp dateTime,
      String? image}) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(_authMethods.user.uid)
        .collection('chats')
        .doc(reciverId)
        .collection("messages")
        .add({
      "text": text,
      "senderId": _authMethods.user.uid,
      "reciverId": reciverId,
      "dateTime": Timestamp.now(),
    }).then((value) {
      setState(() {});
    }).catchError((error) {
      setState(() {});
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc(reciverId)
        .collection('chats')
        .doc(_authMethods.user.uid)
        .collection("messages")
        .add({
      "text": text,
      "senderId": _authMethods.user.uid,
      "reciverId": reciverId,
      "dateTime": dateTime,
    }).then((value) {
      setState(() {});
    }).catchError((error) {
      setState(() {});
    });

    scroll.animateTo(
      scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
    );
  }

  ScrollController scroll = ScrollController();
  Future<http.Response> sendNotificationToToken(
      {String? token, String? title, String? body}) async {
    const String FCM_ENDPOINT = 'https://fcm.googleapis.com/fcm/send';
    const String FCM_SERVER_KEY = 'AAAAiWvLF3g:APA91bG0Hsu5tqbIvpmBiEErwpENL3_zt8LZSpjYsz8uLPU3mECpcNZMLC-uanqy6JJJiYhZcDA9CNC7splJk9Wsc9ECQ-WpPqw2XeJfdbsK_gyJXH8dVVrVKfumupA0aP74V2HzjEEi';
    final data = {
      "to": "$token",
      "notification": {
        "title": title,
        "body": body,
        "mutable_content": true,
      },
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$FCM_SERVER_KEY',
    };

    return await http.post(Uri.parse(FCM_ENDPOINT), body: json.encode(data), headers: headers);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.userData["username"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(_authMethods.user.uid)
                      .collection("chats")
                      .doc(widget.userData["uid"])
                      .collection("messages")
                      .orderBy("dateTime")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        padding: EdgeInsets.only(bottom: 50),
                        controller: scroll,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var message = snapshot.data!.docs[index];

                          if (_authMethods.user.uid ==
                              snapshot.data!.docs[index]["senderId"])
                            return BuildMyMessage(context, message);

                          return BuildMessage(context, message);
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                        itemCount: snapshot.data!.docs.length,
                      );
                    }
                    if (!snapshot.hasData) {
                      print("Start chating...");
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text("Check your Internet"));
                    } else {
                      return const Text("data");
                    }
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(15)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: textCon,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              text = true;
                            });
                          } else {
                            setState(() {
                              text = false;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write your message herer...."),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 65,
                  //   child: MaterialButton(
                  //       color: Colors.white,
                  //       onPressed: () {
                  //         // SocialCubit.get(context).getChatImage(
                  //         //     date: DateTime.now().toString(),
                  //         //     resiverId: widget.model!.uId!);
                  //       },
                  //       minWidth: 1.0,
                  //       child: const Icon(
                  //         Icons.image,
                  //         size: 30,
                  //         color: Colors.blue,
                  //       )),
                  // ),
                   if (text == true)
                  SizedBox(
                    height: 65,
                    child: MaterialButton(
                        color: Colors.grey,
                        onPressed: () {
                          sendMessage(
                              text: textCon.text,
                              reciverId: widget.userData["uid"],
                              dateTime: Timestamp.now());
                          sendNotificationToToken(token:widget.userData["token"] , title: _authMethods.user.displayName , body: textCon.text );
                          textCon.clear();
                        },
                        minWidth: 1.0,
                        child: const Icon(
                          Icons.send,
                          size: 16,
                          color: Colors.blue,
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget BuildMessage(context, chatModel) {
    // if (chatModel["image"] == "null") {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10),
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
            )),
        child: Text(chatModel['text']),
      ),
    );
  }
  // else {
  //   return Align(
  //     alignment: AlignmentDirectional.centerStart,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  //       child: Image(
  //         image: NetworkImage(chatModel["image"]),
  //       ),
  //     ),
  //   );
  // }
}

Widget BuildMyMessage(context, chatModel) {
  print(chatModel);
  // if (chatModel["image"] == "null") {
  return Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),
          )),
      child: Text(chatModel['text']),
    ),
  );
} 
    // else {
    //   return Align(
    //     alignment: AlignmentDirectional.centerEnd,
    //     child: Container(
    //       width: MediaQuery.of(context).size.width / 1.5,
    //       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    //       child: Image(
    //         image: NetworkImage(chatModel["image"]),
    //       ),
    //     ),
    //   );
    // }


