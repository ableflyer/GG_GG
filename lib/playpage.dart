import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class play extends StatefulWidget {
  const play({Key? key}) : super(key: key);

  @override
  State<play> createState() => _playState();
}

class _playState extends State<play> {

  Future<Map> getPlayerData() async{
    Map x = {};
    await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").where("Card design").get().then((value) {
      value.docs.forEach((element) { 
        x = element.data();
      });
    });
    log(x.toString());
    return x;
  }

  Future<String> getImage(String cardString) async{
    String x = "";
    String url = await FirebaseStorage.instance.ref().child("calling_cards/").child(cardString).getDownloadURL();
    x = url;
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPlayerData(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200.h,
                width: 430.w,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow]
                    ),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 75.sp, left: 20.sp, right: 20.sp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: FittedBox(
                              child: Text(
                                "Hello, ${FirebaseAuth.instance.currentUser?.displayName}!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "alexandria",
                                    fontSize: 30.sp
                                ),
                              ),
                              fit: BoxFit.fitWidth,
                            ),
                            width: 230.w,
                          ),
                          Text(
                            "Welcome to GG.GG",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "alexandria",
                                fontSize: 22.sp
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(onPressed: () {}, icon: Icon(Icons.notifications, size: 32.sp, color: Colors.white,)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.message, size: 32.sp, color: Colors.white,)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/friends");
                  },
                  child: Row(
                    children: [
                      Text(
                        "Friends",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.sp,
                          fontFamily: "alexandria",
                        ),
                      ),
                      Icon(Icons.arrow_forward)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 120.h,
                    width: 380.w,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index){
                        return Column(
                          children: [
                            Icon(Icons.account_circle, size: 75.sp,),
                            Text("Username"),
                            Row(
                              children: [
                                Icon(Icons.circle, size: 10.sp, color: Colors.grey,),
                                SizedBox(width: 2.h,),
                                Text("Offline", style: TextStyle(color: Colors.grey, fontSize: 12.sp),)
                              ],
                            )
                          ],
                        );
                      }, separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(width: 10.h,);
                    },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Text(
                  "Gamemodes",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.sp,
                    fontFamily: "alexandria",
                  ),
                ),
              ),
              SizedBox(height: 10.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 135.h,
                    width: 175.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                      gradient: const LinearGradient(
                          colors: [Colors.grey, Colors.black38, Colors.black12]
                      ),
                    ),
                    // child: Column(
                    //   children: [
                    //     SizedBox(height: 30.h,),
                    //     Icon(
                    //       Icons.sports_martial_arts,
                    //       size: 64.sp,
                    //       color: Colors.white,
                    //     ),
                    //     SizedBox(height: 10.h,),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 10.w),
                    //       child: Align(
                    //         alignment: Alignment.bottomLeft,
                    //         child: Text(
                    //             "Battle Royale",
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 14.sp,
                    //                 fontFamily: "alexandria"
                    //             )
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // )
                    // ,
                    child: Center(
                      child: Text(
                          "Coming soon",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          )
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/beforeoyo");
                    },
                    child: Container(
                      height: 135.h,
                      width: 175.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                        gradient: const LinearGradient(
                            colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow]
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 30.h,),
                          Icon(
                            Icons.fitness_center,
                            size: 64.sp,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10.h,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                  "On your own",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontFamily: "alexandria"
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Challenges",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.sp,
                        fontFamily: "alexandria",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/challenges");
                      },
                      child: Row(
                        children: [
                          Text(
                            "See all",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 18.sp,
                              fontFamily: "alexandria",
                            ),
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h,),
              Center(
                child: Container(
                  height: 200.h,
                  width: 380.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily",
                          style: TextStyle(
                            fontSize: 18.0.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h,),
                        Expanded(
                          child: ListView(
                            children: [
                              TaskItem(task: "Do 10 pushups", progress: 1),
                              TaskItem(task: "Burn 100 calories", progress: 0.75),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      );},
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
