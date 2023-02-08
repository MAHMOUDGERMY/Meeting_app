import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';
import 'User_profile.dart';

class Employes extends StatefulWidget {
  const Employes({Key? key}) : super(key: key);

  @override
  State<Employes> createState() => _EmployesState();
}

class _EmployesState extends State<Employes> {
  @override
  final AuthMethods _authMethods = AuthMethods();
  var data = [];
  void getData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isNotEqualTo: _authMethods.user.uid)
        .get()
        .then((value) {
      data = value.docs;
      setState(() {});
      value.docs.forEach((element) {
        print(element.data());
      });
    });
  }

  void initState() {
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: data.isNotEmpty ? true : false,
        replacement: Center(
          child: Text("MOTHING TO SHOW!"),
        ),
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (contetx, index) => InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfile(
                                  userData: data[index],
                                )));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage("${data[index]["profilePhoto"]}")),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${data[index]["username"]}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${data[index]["job"] ?? "job title"}",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserProfile(
                                            userData: data[index],
                                          )));
                            },
                            icon: Icon(Icons.arrow_forward_ios_sharp))
                      ],
                    ),
                  ),
                )),
      ),
    );
  }
}
