import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:text_scroll/text_scroll.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  Future<Map> getPlayerData() async {
    Map x = {};
    Map y = {};
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
    return OfflineBuilder(connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
        ){
      return FirebaseAuth.instance.currentUser != null
          ? FutureBuilder(
        future: getPlayerData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData? Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 20.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: "Card",
                          child: FutureBuilder(
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
                                            color: Colors.transparent,
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
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Level",
                              style: TextStyle(fontSize: 28.sp),
                            ),
                            Text(
                              "${snapshot.data["Level"]}",
                              style: TextStyle(fontSize: 48.sp),
                            ),
                            Text(
                              "Streak HS",
                              style: TextStyle(fontSize: 28.sp),
                            ),
                            Text(
                              "${snapshot.data["StreakHigh"]}",
                              style: TextStyle(fontSize: 48.sp),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.tune,
                    color: Colors.black,
                  ),
                  trailing: Text(
                    "Customize",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/customize", arguments: {
                      "CardDesign": snapshot.data["Card design"].toString()
                    });
                  },
                ),
                // ListTile(
                //   leading: Icon(
                //     Icons.settings,
                //     color: Colors.black,
                //   ),
                //   trailing: Text(
                //     "Settings",
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   onTap: () {
                //     Navigator.pushNamed(context, "/settings");
                //   },
                // ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                  trailing: Text(
                    "Log out",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
                              height: 200.h,
                              width: 300.w,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Are you sure?"),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onLongPress: () async {
                                            Navigator.pop(context);
                                            log("Logged out");
                                            await FirebaseAuth.instance
                                                .signOut();
                                            Navigator.pushReplacementNamed(
                                                context, "/");
                                          },
                                          child: Text(
                                            "Yes (Hold to log out)",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () {},
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          ):Scaffold(
            backgroundColor: Colors.white,
            body: Align(
              alignment: Alignment.bottomRight,
              child: SpinKitRotatingPlain(
                color: Colors.black,
              ),
            ),
          );
        },
      )
          : Scaffold(
        body: Container(
            width: 430.w,
            height: 932.h,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/pexels-antoni-shkraba-4398881.jpg"),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextScroll("B E C O M E  U N S T O P P A B L E",
                    mode: TextScrollMode.endless,
                    velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                    style: TextStyle(color: Colors.red, fontSize: 40.sp),
                    textDirection: TextDirection.rtl),
                TextScroll(
                  "B E C O M E  U N S T O P P A B L E",
                  mode: TextScrollMode.endless,
                  velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                  style: TextStyle(color: Colors.red, fontSize: 40.sp),
                ),
                TextScroll("B E C O M E  U N S T O P P A B L E",
                    mode: TextScrollMode.endless,
                    velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                    style: TextStyle(color: Colors.red, fontSize: 40.sp),
                    textDirection: TextDirection.rtl),
                TextScroll(
                  "B E C O M E  U N S T O P P A B L E",
                  mode: TextScrollMode.endless,
                  velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                  style: TextStyle(color: Colors.red, fontSize: 40.sp),
                ),
                TextScroll("B E C O M E  U N S T O P P A B L E",
                    mode: TextScrollMode.endless,
                    velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                    style: TextStyle(color: Colors.red, fontSize: 40.sp),
                    textDirection: TextDirection.rtl),
                TextScroll(
                  "B E C O M E  U N S T O P P A B L E",
                  mode: TextScrollMode.endless,
                  velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                  style: TextStyle(color: Colors.red, fontSize: 40.sp),
                )
              ],
            )),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
              left: 34.sp,
              bottom: 70.sp
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 430.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Bounce(
                    duration: Duration(milliseconds: 50),
                    onPressed: (){Navigator.pushNamed(context, "/login");},
                    child: Container(
                      height: 53.h,
                      width: 170.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text("Log in", style: TextStyle(fontSize: 16.sp)),
                      ),
                    ),
                  ),
                  Bounce(
                    duration: Duration(milliseconds: 50),
                    onPressed: (){Navigator.pushNamed(context, "/signup");},
                    child: Container(
                      height: 53.h,
                      width: 170.w,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text("Join for free", style: TextStyle(fontSize: 16.sp)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    child: SizedBox(),);
  }
}
