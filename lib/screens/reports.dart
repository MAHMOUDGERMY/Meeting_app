import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import 'User_profile.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  List Reports = [];
  void getReports() {
    FirebaseFirestore.instance.collection("reports").get().then((value) {
      Reports = value.docs;
      setState(() {});
    });
  }

  @override
  void initState() {
    getReports();
    super.initState();
  }

  AuthMethods _authMethods = AuthMethods();

  TextEditingController controller = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          scaffoldKey.currentState!.showBottomSheet((context) => Container(
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        maxLines: 100,
                        onTap: () {},
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          fillColor: secondaryBackgroundColor,
                          filled: true,
                          border: InputBorder.none,
                          hintText: 'Write report here ....',
                          contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection("reports")
                                .add({
                              "name": _authMethods.user.displayName,
                              "uid": _authMethods.user.uid,
                              "date": DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()),
                              "content": controller.text,
                              "image": _authMethods.user.photoURL,
                            }).then((value) {
                              getReports();
                              Navigator.pop(context);
                              showSnackBar(
                                  context, "report added successfully", true);
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.post_add_outlined,
                          size: 50,
                        )),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(),
      body: ListView.separated(
          itemCount: Reports.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(Reports[index].data()["image"]),
                        radius: 20,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(Reports[index].data()["name"])
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    Reports[index].data()["date"],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(Reports[index].data()["content"]),
                ],
              ),
            );
          }),
    );
  }
}
