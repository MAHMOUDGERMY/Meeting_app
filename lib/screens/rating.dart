// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:zoom_clone_tutorial/utils/utils.dart';

class Rating extends StatefulWidget {
  final userData;
  const Rating({Key? key, this.userData}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  String? overall_performance;
  String? the_audience;
  String? Productivity;
  String? Workmanship;
  String? stress_management;
  String? time_management;
  String? Task_Management;
  String? Adaptation_and_self_awareness;
  String? communication_skills;
  @override
  void initState() {
    getUserRating();
    super.initState();
  }

  void getUserRating() async {
    try {
      await FirebaseFirestore.instance
          .collection("Ratings")
          .where("uid", isEqualTo: widget.userData["uid"])
          .get()
          .then((value) {
        Map data = value.docs[0].data();
        overall_performance = data["overall_performance"];
        the_audience = data["the_audience"];
        Productivity = data["Productivity"];
        Workmanship = data["Workmanship"];
        stress_management = data["stress_management"];
        time_management = data["time_management"];
        Task_Management = data["Task_Management"];
        Adaptation_and_self_awareness = data["Adaptation_and_self_awareness"];
        communication_skills = data["communication_skills"];

        setState(() {});
      }).catchError(() {
        print("object");
      });
    } catch (on) {
      print("object");
    }
  }

  void addRating() async {
    if (overall_performance != null &&
        the_audience != null &&
        Productivity != null &&
        Workmanship != null &&
        stress_management != null &&
        time_management != null &&
        Task_Management != null &&
        Adaptation_and_self_awareness != null &&
        communication_skills != null) {
      await FirebaseFirestore.instance
          .collection("Ratings")
          .doc(widget.userData["uid"])
          .set({
        "uid": widget.userData["uid"],
        "overall_performance": overall_performance,
        "the_audience": the_audience,
        "Productivity": Productivity,
        "Workmanship": Workmanship,
        "stress_management": stress_management,
        "time_management": time_management,
        "Task_Management": Task_Management,
        "Adaptation_and_self_awareness": Adaptation_and_self_awareness,
        "communication_skills": communication_skills
      }).then((value) {
        showSnackBar(context, "Rating successfully", true);
      });
    } else {
      showSnackBar(context, "please rate all form", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userData["username"]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              overall_performance_bar("overall performance"),
              const Divider(
                color: Colors.grey,
              ),
              the_audience_bar("the audience"),
              const Divider(
                color: Colors.grey,
              ),
              Productivity_bar("Productivity"),
              const Divider(
                color: Colors.grey,
              ),
              Workmanship_bar("Workmanship"),
              const Divider(
                color: Colors.grey,
              ),
              stress_management_bar("stress management"),
              const Divider(
                color: Colors.grey,
              ),
              time_management_bar("Task Management"),
              const Divider(
                color: Colors.grey,
              ),
              Task_Management_bar("time management"),
              const Divider(
                color: Colors.grey,
              ),
              Adaptation_and_self_awareness_bar(
                "Adaptation and self-awareness",
              ),
              const Divider(
                color: Colors.grey,
              ),
              communication_skills_bar("communication skills"),
              const Divider(
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {
                  addRating();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: HexColor("3d405b"),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Center(
                    child: Text("Rate"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column overall_performance_bar(String Title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Title),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "not good",
                        groupValue: overall_performance,
                        onChanged: (value) {
                          print(value.toString());

                          setState(() {
                            overall_performance = value.toString();
                            print(overall_performance);
                            print(overall_performance);
                          });
                        }),
                    const Text(
                      "not good",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "acceptable",
                        groupValue: overall_performance,
                        onChanged: (value) {
                          setState(() {
                            overall_performance = value.toString();
                            print(overall_performance);
                          });
                        }),
                    const Text(
                      "acceptable",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "good",
                        groupValue: overall_performance,
                        onChanged: (value) {
                          setState(() {
                            overall_performance = value.toString();
                            print(overall_performance);
                          });
                        }),
                    const Text(
                      "good",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "excellent",
                        groupValue: overall_performance,
                        onChanged: (value) {
                          setState(() {
                            overall_performance = value.toString();
                            print(overall_performance);
                          });
                        }),
                    const Text(
                      "excellent",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Column the_audience_bar(String Title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Title),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "not good",
                        groupValue: the_audience,
                        onChanged: (value) {
                          setState(() {
                            the_audience = value.toString();
                            print(the_audience);
                          });
                        }),
                    const Text(
                      "not good",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "acceptable",
                        groupValue: the_audience,
                        onChanged: (value) {
                          setState(() {
                            the_audience = value.toString();
                            print(the_audience);
                          });
                        }),
                    const Text(
                      "acceptable",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "good",
                        groupValue: the_audience,
                        onChanged: (value) {
                          setState(() {
                            the_audience = value.toString();
                            print(the_audience);
                          });
                        }),
                    const Text(
                      "good",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "excellent",
                        groupValue: the_audience,
                        onChanged: (value) {
                          setState(() {
                            the_audience = value.toString();
                            print(the_audience);
                          });
                        }),
                    const Text(
                      "excellent",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Column Productivity_bar(String Title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Title),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "not good",
                        groupValue: Productivity,
                        onChanged: (value) {
                          setState(() {
                            Productivity = value.toString();
                            print(Productivity);
                          });
                        }),
                    const Text(
                      "not good",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "acceptable",
                        groupValue: Productivity,
                        onChanged: (value) {
                          setState(() {
                            Productivity = value.toString();
                            print(Productivity);
                          });
                        }),
                    const Text(
                      "acceptable",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "good",
                        groupValue: Productivity,
                        onChanged: (value) {
                          setState(() {
                            Productivity = value.toString();
                            print(Productivity);
                          });
                        }),
                    const Text(
                      "good",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "excellent",
                        groupValue: Productivity,
                        onChanged: (value) {
                          setState(() {
                            Productivity = value.toString();
                            print(Productivity);
                          });
                        }),
                    const Text(
                      "excellent",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Column Workmanship_bar(String Title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Title),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "not good",
                        groupValue: Workmanship,
                        onChanged: (value) {
                          setState(() {
                            Workmanship = value.toString();
                            print(Workmanship);
                          });
                        }),
                    const Text(
                      "not good",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "acceptable",
                        groupValue: Workmanship,
                        onChanged: (value) {
                          setState(() {
                            Workmanship = value.toString();
                            print(Workmanship);
                          });
                        }),
                    const Text(
                      "acceptable",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "good",
                        groupValue: Workmanship,
                        onChanged: (value) {
                          setState(() {
                            Workmanship = value.toString();
                            print(Workmanship);
                          });
                        }),
                    const Text(
                      "good",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "excellent",
                        groupValue: Workmanship,
                        onChanged: (value) {
                          setState(() {
                            Workmanship = value.toString();
                            print(Workmanship);
                          });
                        }),
                    const Text(
                      "excellent",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Column stress_management_bar(String Title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Title),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "not good",
                        groupValue: stress_management,
                        onChanged: (value) {
                          print(value.toString());

                          setState(() {
                            stress_management = value.toString();
                            print(stress_management);
                            print(communication_skills);
                          });
                        }),
                    const Text(
                      "not good",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "acceptable",
                        groupValue: stress_management,
                        onChanged: (value) {
                          setState(() {
                            stress_management = value.toString();
                          });
                        }),
                    const Text(
                      "acceptable",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "good",
                        groupValue: stress_management,
                        onChanged: (value) {
                          setState(() {
                            stress_management = value.toString();
                          });
                        }),
                    const Text(
                      "good",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "excellent",
                        groupValue: stress_management,
                        onChanged: (value) {
                          setState(() {
                            stress_management = value.toString();
                          });
                        }),
                    const Text(
                      "excellent",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Column time_management_bar(String Title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Title),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "not good",
                        groupValue: time_management,
                        onChanged: (value) {
                          print(value.toString());

                          setState(() {
                            time_management = value.toString();
                            print(time_management);
                            print(communication_skills);
                          });
                        }),
                    const Text(
                      "not good",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "acceptable",
                        groupValue: time_management,
                        onChanged: (value) {
                          setState(() {
                            time_management = value.toString();
                          });
                        }),
                    const Text(
                      "acceptable",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "good",
                        groupValue: time_management,
                        onChanged: (value) {
                          setState(() {
                            time_management = value.toString();
                          });
                        }),
                    const Text(
                      "good",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "excellent",
                        groupValue: time_management,
                        onChanged: (value) {
                          setState(() {
                            time_management = value.toString();
                          });
                        }),
                    const Text(
                      "excellent",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Column Task_Management_bar(String Title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Title),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "not good",
                        groupValue: Task_Management,
                        onChanged: (value) {
                          print(value.toString());

                          setState(() {
                            Task_Management = value.toString();
                            print(Task_Management);
                            print(communication_skills);
                          });
                        }),
                    const Text(
                      "not good",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "acceptable",
                        groupValue: Task_Management,
                        onChanged: (value) {
                          setState(() {
                            Task_Management = value.toString();
                          });
                        }),
                    const Text(
                      "acceptable",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "good",
                        groupValue: Task_Management,
                        onChanged: (value) {
                          setState(() {
                            Task_Management = value.toString();
                          });
                        }),
                    const Text(
                      "good",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "excellent",
                        groupValue: Task_Management,
                        onChanged: (value) {
                          setState(() {
                            Task_Management = value.toString();
                          });
                        }),
                    const Text(
                      "excellent",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Column Adaptation_and_self_awareness_bar(String Title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Title),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "not good",
                        groupValue: Adaptation_and_self_awareness,
                        onChanged: (value) {
                          print(value.toString());

                          setState(() {
                            Adaptation_and_self_awareness = value.toString();
                            print(Adaptation_and_self_awareness);
                            print(communication_skills);
                          });
                        }),
                    const Text(
                      "not good",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "acceptable",
                        groupValue: Adaptation_and_self_awareness,
                        onChanged: (value) {
                          setState(() {
                            Adaptation_and_self_awareness = value.toString();
                          });
                        }),
                    const Text(
                      "acceptable",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "good",
                        groupValue: Adaptation_and_self_awareness,
                        onChanged: (value) {
                          setState(() {
                            Adaptation_and_self_awareness = value.toString();
                          });
                        }),
                    const Text(
                      "good",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "excellent",
                        groupValue: Adaptation_and_self_awareness,
                        onChanged: (value) {
                          setState(() {
                            Adaptation_and_self_awareness = value.toString();
                          });
                        }),
                    const Text(
                      "excellent",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Column communication_skills_bar(String Title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Title),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "not good",
                        groupValue: communication_skills,
                        onChanged: (value) {
                          print(value.toString());

                          setState(() {
                            communication_skills = value.toString();
                            print(communication_skills);
                          });
                        }),
                    const Text(
                      "not good",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "acceptable",
                        groupValue: communication_skills,
                        onChanged: (value) {
                          setState(() {
                            communication_skills = value.toString();
                          });
                        }),
                    const Text(
                      "acceptable",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "good",
                        groupValue: communication_skills,
                        onChanged: (value) {
                          setState(() {
                            communication_skills = value.toString();
                          });
                        }),
                    const Text(
                      "good",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Radio(
                        toggleable: true,
                        value: "excellent",
                        groupValue: communication_skills,
                        onChanged: (value) {
                          setState(() {
                            communication_skills = value.toString();
                          });
                        }),
                    const Text(
                      "excellent",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
