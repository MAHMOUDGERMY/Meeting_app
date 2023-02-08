import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:zoom_clone_tutorial/resources/auth_methods.dart';
import 'package:zoom_clone_tutorial/screens/chat_groub.dart';

import '../utils/colors.dart';
import '../utils/utils.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  List Groubs_data = [];
  void getGroubs() async {
    await FirebaseFirestore.instance.collection("groubs").get().then((value) {
      Groubs_data = value.docs;

      setState(() {});
    });
  }

  TextEditingController NameCont = TextEditingController();
  TextEditingController descCont = TextEditingController();

  AuthMethods _authMethods = AuthMethods();
  @override
  void initState() {
    getGroubs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
              itemCount: Groubs_data.length,
              separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                  ),
              itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat_Groub(
                                    group_data: Groubs_data[index],
                                  )));
                    },
                    title: Text(Groubs_data[index].data()["groub_name"]),
                    leading: const Icon(Icons.group),
                  )),
        ),
        InkWell(
          onTap: () {
            CreateNewGroub(context);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 20, left: 20),
            decoration: BoxDecoration(
              color: HexColor("3d405b"),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(10),
            child: const Center(
              child: Text("Create New Groub"),
            ),
          ),
        ),
      ],
    );
  }

  CreateNewGroub(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              child: Column(
                children: [
                  TextField(
                    controller: NameCont,
                    maxLines: 1,
                    onTap: () async {},
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      fillColor: secondaryBackgroundColor,
                      filled: true,
                      border: InputBorder.none,
                      hintText: 'Groub Name',
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: descCont,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        fillColor: secondaryBackgroundColor,
                        filled: true,
                        border: InputBorder.none,
                        hintText: 'description',
                        contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: InkWell(
                      onTap: () async {
                        if (NameCont.text.isNotEmpty) {
                          FirebaseFirestore.instance.collection("groubs").add({
                            "groub_name": NameCont.text,
                            "groub_desc": descCont.text,
                          }).then((value) {
                            getGroubs();
                            Navigator.pop(context);
                            showSnackBar(
                                context, "Groub created successfully", true);
                          });
                        } else {
                          Navigator.pop(context);
                          showSnackBar(
                              context, "please enter groub name.", false);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 40, left: 20),
                        decoration: BoxDecoration(
                          color: HexColor("3d405b"),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Center(
                          child: Text("Create"),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ));
  }
}
