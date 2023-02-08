import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../resources/auth_methods.dart';

class Chat_Groub extends StatefulWidget {
  final group_data;
  const Chat_Groub({Key? key, this.group_data}) : super(key: key);

  @override
  State<Chat_Groub> createState() => _Chat_GroubState();
}

class _Chat_GroubState extends State<Chat_Groub> {
  AuthMethods _authMethods = AuthMethods();
  TextEditingController textCon = TextEditingController();

  bool text = false;
  void sendMessage(
      {required String text,
      required String groub_id,
      required Timestamp dateTime,
      String? image}) {
    FirebaseFirestore.instance
        .collection("groubs")
        .doc(groub_id)
        .collection('messages')
        .add({
      "text": text,
      "senderId": _authMethods.user.uid,
      "dateTime": dateTime,
      "user_name": _authMethods.user.displayName,
      "user_image": _authMethods.user.photoURL,
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
  void topicSub() async {
    await FirebaseMessaging.instance.subscribeToTopic(widget.group_data.id);
  }

  @override
  void initState() {
    print(widget.group_data.id);
    topicSub();
    super.initState();
  }

  Future<http.Response> sendNotificationToTopic(
      {String? topic, String? title, String? body}) async {
    const String FCM_ENDPOINT = 'https://fcm.googleapis.com/fcm/send';
    const String FCM_SERVER_KEY = 'AAAAiWvLF3g:APA91bG0Hsu5tqbIvpmBiEErwpENL3_zt8LZSpjYsz8uLPU3mECpcNZMLC-uanqy6JJJiYhZcDA9CNC7splJk9Wsc9ECQ-WpPqw2XeJfdbsK_gyJXH8dVVrVKfumupA0aP74V2HzjEEi';
    final data = {
      "to": "/topics/$topic",
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
        titleSpacing: 20,


        title:
            Text(widget.group_data["groub_name"]),



      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(

              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("groubs")
                      .doc(widget.group_data.id)
                      .collection("messages")
                      .orderBy("dateTime")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return  ListView.separated(
                        padding: EdgeInsets.only(bottom: 50),
                          controller: scroll,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {

                            var message = snapshot.data!.docs[index];

                            if (_authMethods.user.uid ==
                                snapshot.data!.docs[index]["senderId"])
                              return BuildMyMessage(context, message);

                            return BuildMessage(context, message , scroll);

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
                  // if (text == true)
                  text
                      ? SizedBox(
                    height: 65,
                    child: MaterialButton(
                        color: Colors.grey,
                        onPressed: () {
                          if (textCon.text.isNotEmpty) {
                            sendMessage(
                                text: textCon.text,
                                groub_id: widget.group_data.id,
                                dateTime: Timestamp.now());

                          }
                          text = false;
                          sendNotificationToTopic(
                              topic:widget.group_data.id,
                              title:widget.group_data["groub_name"] ,
                              body: " ${_authMethods.user.displayName} : ${textCon.text}"   );
                          textCon.clear();

                        },
                        minWidth: 1.0,
                        child: const Icon(
                          Icons.send,
                          size: 16,
                          color: Colors.white,
                        )),
                  )
                      : const SizedBox()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget BuildMessage(context, chatModel , scroll) {
  // if (chatModel["image"] == "null") {
  // scroll.animateTo(
  //   scroll.position.maxScrollExtent,
  //   duration: const Duration(milliseconds: 600),
  //   curve: Curves.fastOutSlowIn,
  // );
  return Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10),
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chatModel["user_name"],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(chatModel['text']),
        ],
      ),
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

Widget BuildMyMessage(context, chatModel) {
  print(chatModel);
  // if (chatModel["image"] == "null") {
  return Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
            topStart: Radius.circular(10),
            topEnd: Radius.circular(10),
          )),
      child: Text(chatModel['text']),
    ),
  );
}
