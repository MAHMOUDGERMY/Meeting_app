import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoom_clone_tutorial/screens/groubs.dart';

import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import 'Employes.dart';
import 'history_meeting_screen.dart';
import 'meeting_screen.dart';
import 'profile_screen.dart';
import 'reports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  List<Widget> pages = [
    MeetingScreen(),
    const HistoryMeetingScreen(),
    const Employes(),
    const Groups(),
  ];
  Map<String, dynamic> user = {};
  final _authMethod = AuthMethods();
  void getUserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: _authMethod.user.uid)
        .get()
        .then((value) {
      user = value.docs[0].data();
      print(user);
      setState(() {});
    });
  }

  List MyOrders = [];
  void getMyOrders() async {
    await FirebaseFirestore.instance
        .collection("orders")
        .where("uid", isEqualTo: _authMethod.user.uid)
        .get()
        .then((value) {
      MyOrders = value.docs;
      setState(() {});
    });
  }

  List AllOrders = [];
  void getAllOrders() async {
    await FirebaseFirestore.instance
        .collection("orders")
        .where("wait", isEqualTo: true)
        .get()
        .then((value) {
      AllOrders = value.docs;
      setState(() {});
    });
  }

  @override
  void initState() {
    getUserData();
    getMyOrders();
    getAllOrders();
    super.initState();
  }

  TextEditingController dateCont = TextEditingController();
  TextEditingController endDateCont = TextEditingController();

  TextEditingController reasonCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getMyOrders();
        getAllOrders();
      },
      child: Scaffold(
        endDrawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                ListTile(
                    leading: const Icon(Icons.request_page_outlined),
                    title: const Text("time off work"),
                    onTap: () {
                      order(context);
                    }),
                user["isAdmin"] == true
                    ? ListTile(
                        leading: const Icon(Icons.request_page_outlined),
                        title: const Text("time off work orders"),
                        onTap: () {
                          allOrders(context);
                        },
                      )
                    : const SizedBox(),
                ListTile(
                  leading: const Icon(Icons.list_alt_outlined),
                  title: const Text("my orders"),
                  onTap: () {
                    myOrders(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.report),
                  title: const Text("reports"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const Reports())));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text("Sign Out"),
                  onTap: () {
                    _authMethod.signOut(context);
                  },
                )
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (){},
        //   child: Icon( Icons.add,),
        // ),
        appBar: AppBar(
          leadingWidth: 45,
          leading: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            child: CircleAvatar(
              radius: 10,
              backgroundImage:
                  CachedNetworkImageProvider("${_authMethod.user.photoURL}"),
            ),
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
          title: const Text('Meeting'),
          centerTitle: true,
        ),
        body: pages[_page],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: footerColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: onPageChanged,
          currentIndex: _page,
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 14,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.comment_bank,
              ),
              label: 'Meet',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.lock_clock,
              ),
              label: 'Meetings',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.featured_play_list_outlined,
              ),
              label: 'Employes',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.group,
              ),
              label: 'Chats',
            ),
          ],
        ),
      ),
    );
  }

  allOrders(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) => AllOrders.isEmpty
            ? const Center(
                child: Text("Nothing To show ..."),
              )
            : Container(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                          color: Colors.grey,
                        ),
                    itemCount: AllOrders.length,
                    itemBuilder: (context, index) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                      AllOrders[index].data()["image"]),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(AllOrders[index].data()["name"]),
                                const Spacer(),
                                IconButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection("orders")
                                          .doc(AllOrders[index].id)
                                          .update({
                                        "wait": false,
                                        "approve": true
                                      }).then((value) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        getAllOrders();

                                        showSnackBar(context, "success", true);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.check_rounded,
                                      color: Colors.green,
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection("orders")
                                          .doc(AllOrders[index].id)
                                          .update({
                                        "wait": false,
                                        "approve": false
                                      }).then((value) {
                                        getAllOrders();

                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        showSnackBar(context, "success", true);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                            Text(
                              AllOrders[index].data()["reason"],
                              style: const TextStyle(color: Colors.grey),
                            )
                          ]);
                    }),
              ));
  }

  order(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              child: Column(
                children: [
                  TextField(
                    controller: dateCont,
                    maxLines: 1,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(), //get today's date
                          firstDate: DateTime(
                              2023), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      print(pickedDate);
                      pickedDate != null
                          ? dateCont.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate)
                          : null;
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      fillColor: secondaryBackgroundColor,
                      filled: true,
                      border: InputBorder.none,
                      hintText: 'Choose date ....',
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: endDateCont,
                    maxLines: 1,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(), //get today's date
                          firstDate: DateTime(
                              2023), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      print(pickedDate);
                      endDateCont.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate!);
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      fillColor: secondaryBackgroundColor,
                      filled: true,
                      border: InputBorder.none,
                      hintText: 'Choose end Date ....',
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: reasonCont,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        fillColor: secondaryBackgroundColor,
                        filled: true,
                        border: InputBorder.none,
                        hintText: 'reason ....',
                        contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                      ),
                    ),
                  ),
                  IconButton(
                      iconSize: 40,
                      onPressed: () async {
                        if (dateCont.text.isNotEmpty &&
                            endDateCont.text.isNotEmpty &&
                            reasonCont.text.isNotEmpty) {
                          await FirebaseFirestore.instance
                              .collection("orders")
                              .add({
                            "name": _authMethod.user.displayName,
                            "uid": _authMethod.user.uid,
                            "image": _authMethod.user.photoURL,
                            "date": dateCont.text,
                            "endDate": endDateCont.text,
                            "reason": reasonCont.text,
                            "approve": false,
                            "wait": true
                          }).then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            getAllOrders();
                            showSnackBar(
                                context, "order sent successfully", true);
                          });
                        } else {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          showSnackBar(
                              context, "there is no data entered", false);
                        }
                      },
                      color: Colors.green,
                      icon: const Icon(Icons.send_rounded)),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ));
  }

  Future<dynamic> myOrders(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                      ),
                  itemCount: MyOrders.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage:
                                  NetworkImage(MyOrders[index].data()["image"]),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(MyOrders[index].data()["name"]),
                            const Spacer(),
                            MyOrders[index].data()["wait"] == true
                                ? const Text(
                                    "waiting...",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 181, 34)),
                                  )
                                : MyOrders[index].data()["approve"] == true
                                    ? const Text("approval",
                                        style: TextStyle(color: Colors.green))
                                    : const Text("refused",
                                        style: TextStyle(color: Colors.red))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "start : ${MyOrders[index].data()["date"]}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "end : ${MyOrders[index].data()["endDate"]}",
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    );
                  }),
            ));
  }
}
