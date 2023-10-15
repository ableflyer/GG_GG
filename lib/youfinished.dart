import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class finish extends StatefulWidget {
  const finish({Key? key}) : super(key: key);

  @override
  State<finish> createState() => _finishState();
}

class _finishState extends State<finish> {
  Map arg = {};
  int num = 0;
  bool lvlup = false;
  Future<Map> getPlayerData() async {
    arg = ModalRoute.of(context)!.settings.arguments as Map;
    Map x = {};
    Map y = {};
    List challenges = [];
    String key = "";
    await FirebaseFirestore.instance
        .collection("Users")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("GG.GG")
        .where("Card design")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        x = element.data();
        key = element.id;
      });
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("GG.GG")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        y = element.data();
      });
    });
    await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(key).update({
      "XP": x["XP"] + arg["xp"],
    });
    if((DateTime.now().millisecondsSinceEpoch/(3600000))-(x["Last Exercised"].seconds/3600) > 24){
    await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(key).update(
        {
          "Streaks": x["Streaks"] + 1,
          "Last Exercised": DateTime.now(),
          "StreakCap": x["Streaks"]+1 > x["StreakCap"]? x["StreakCap"]+7:x["StreakCap"],
          "StreakHigh": x["Streaks"]+1 > x["StreakHigh"]? x["Streaks"]+1:x["StreakHigh"]
        });
    }
    if((x["XP"] + arg["xp"] >= ((x["Level"]/0.3)*1.5)) && lvlup == false){
      lvlup = true;
      await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(key).update({
        "Level": x["Level"] + 1
      });
    }
    await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(key).collection("Challenges").get().then((value) {
      value.docs.forEach((element) async{
        challenges.add([element.data()["goal"], element.data()["current"], element.data()["type"]]);
        for(int i = 0; i < arg["list"].length; i++){
          if(element.data()["type"] == arg["list"][i]["exercise"] && element.data()["goal"] > element.data()["current"]){
            await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(key).collection("Challenges").doc("Do ${element.data()["goal"]} ${element.data()["type"]} in total").update(
              {
                "current": element.data()["current"]+1
              }
            );
          }
        }
      });
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .collection("GG.GG")
        .where("Card design")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        x = element.data();
        key = element.id;
      });
    });
    log("y = ${y}");
    log("key = $key");
    log("x = ${x}");
    return x;
  }

  Future<String> getImage(String cardString) async {
    String x = "";
    String url = await FirebaseStorage.instance
        .ref()
        .child("calling_cards/")
        .child(cardString)
        .getDownloadURL();
    x = url;
    return x;
  }


  @override
  Widget build(BuildContext context) {
    arg = ModalRoute.of(context)!.settings.arguments as Map;
    return FutureBuilder(
      future: getPlayerData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: Text(
                  "Exercise finished",
                  style: TextStyle(color: Colors.white, fontSize: 32.sp),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
              ),
              body: Stack(
                children: [
                  Container(
                    width: 430.w,
                    height: 932.h,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xFFFF1100),
                          Colors.orange,
                          Colors.yellow
                        ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                  ),
                  Container(
                    width: 430.w,
                    height: 932.h,
                    color: Colors.black.withOpacity(0.52),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 80.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FutureBuilder(
                              future: getImage(
                                  snapshot.data["Card design"].toString()),
                              builder:
                                  (BuildContext context, AsyncSnapshot snap) {
                                if (snap.hasData) {
                                  return Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 300.h,
                                          width: 150.w,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      snap.data.toString()),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                      Center(
                                          child: SizedBox(
                                              height: 300.h,
                                              width: 150.w,
                                              child: Image.asset(
                                                "assets/card_holder.png",
                                                fit: BoxFit.cover,
                                              )))
                                    ],
                                  );
                                }
                                return Container(
                                  height: 300.h,
                                  width: 150.w,
                                  decoration: BoxDecoration(color: Colors.red),
                                );
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Time exercised",
                                  style: TextStyle(
                                      fontSize: 28.sp, color: Colors.white),
                                ),
                                Text(
                                  "${(arg["time"]).toStringAsFixed(2)} mins",
                                  style: TextStyle(
                                      fontSize: 48.sp, color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          lvlup ? "L  E  V  E  L  U  P" : "",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48.sp,
                              fontFeatures: [FontFeature.tabularFigures()]),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.h),
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${snapshot.data["Level"]}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30.sp),),
                              Container(
                                height: 30.h,
                                width: 310.w,
                                color: Colors.black,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 30.h,
                                    width: (310 * (snapshot.data["XP"] /
                                        ((snapshot.data["Level"] / 0.3) * 1.5)))
                                        .w,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFFF1100),
                                              Colors.orange,
                                              Colors.yellow
                                            ]
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              Text("${snapshot.data["Level"] + 1}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30.sp),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 60.h),
                      Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                        colors: [
                                          Color(0xFFFF1100),
                                          Colors.orange,
                                          Colors.yellow
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter
                                    ).createShader(bounds);
                                  },
                                  child: Icon(
                                    Icons.local_fire_department_outlined,
                                    color: Colors.red,
                                    size: 40.sp,
                                  ),
                                ),
                                Text("Current streak: ${snapshot.data["Streaks"]
                                    .toString()}", style: TextStyle(
                                    color: Colors.white, fontSize: 30.sp),)
                              ],
                            ),
                            Center(
                              child: SizedBox(
                                width: 400.w,
                                height: 100.h,
                                child: Center(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 7,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      num = int.parse(snapshot.data["StreakCap"]
                                          .toString()) - int.parse(
                                          snapshot.data["Streaks"].toString());
                                      if (7 - num >= index + 1) {
                                        return Icon(
                                          Icons.check_circle, size: 50.sp,
                                          color: Colors.orange,);
                                      }
                                      return Icon(Icons.circle, size: 50.sp,);
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Press anywhere to advance", style: TextStyle(
                                color: Colors.white, fontSize: 26.sp),)
                        ),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/home");
                    },
                    child: SizedBox(
                      width: 430.w,
                      height: 932.h,
                    ),
                  ),
                ],
              )
          );
        }
        else if(FirebaseAuth.instance.currentUser?.uid != null){
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: Text(
                  "Exercise finished",
                  style: TextStyle(color: Colors.white, fontSize: 32.sp),
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
              ),
              body: Stack(
                children: [
                  Container(
                    width: 430.w,
                    height: 932.h,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xFFFF1100),
                          Colors.orange,
                          Colors.yellow
                        ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                  ),
                  Container(
                    width: 430.w,
                    height: 932.h,
                    color: Colors.black.withOpacity(0.52),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 80.h,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time exercised",
                            style: TextStyle(
                                fontSize: 28.sp, color: Colors.white),
                          ),
                          Text(
                            "${(arg["time"]).toStringAsFixed(2)} mins",
                            style: TextStyle(
                                fontSize: 48.sp, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h,),
                      Text(
                        "Sign up or log in to save your progress",
                        style: TextStyle(
                            fontSize: 28.sp, color: Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Press anywhere to advance", style: TextStyle(
                                color: Colors.white, fontSize: 26.sp),)
                        ),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/home");
                    },
                    child: SizedBox(
                      width: 430.w,
                      height: 932.h,
                    ),
                  ),
                ],
              )
          );
        }
        return Center(
          child: SpinKitRotatingPlain(
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class TaskItem extends StatelessWidget {
  final String task;
  final double progress;

  TaskItem({required this.task, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 10.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
          Icon(
            progress < 1? Icons.check_box_outline_blank: Icons.check_box,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}
