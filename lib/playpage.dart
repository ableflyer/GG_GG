import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class play extends StatefulWidget {
  const play({Key? key}) : super(key: key);

  @override
  State<play> createState() => _playState();
}

class _playState extends State<play> {

  int num = 0;
  late String? ggkey;
  List<String> exercises = [
    "pushups",
    "squats",
    "star jumps",
    "lunges",
    "squat jumps",
    "high knees"
  ];

  Future<List> getChallenges() async{
    List challenges = [];
    if(ggkey != null){
      await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(ggkey).collection("Challenges").get().then((value) {
        value.docs.forEach((element) {
          challenges.add([element.data()["goal"], element.data()["current"], element.data()["type"]]);
        });
      });
      print(challenges);
    }
    return challenges;
  }

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
        ggkey = element.id;
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
    if((DateTime.now().millisecondsSinceEpoch/(3600000))-(x["Last Exercised"].seconds/3600) > 48){
      await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(key).update(
          {
            "Streaks": 0,
          });
    }
    if((DateTime.now().millisecondsSinceEpoch/(3600000))-(x["LastReset"].seconds/3600) >= 24){
      await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(key).collection("Challenges").get().then((value){
        for(var i in value.docs){
          i.reference.delete();
        }
      });
      DateTime datenow = DateTime.now();
      await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(key).update({
        "LastReset": DateTime(datenow.year, datenow.month, datenow.day)
      });
    }
    await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(key).collection("Challenges").get().then((value) async{
      if(value.docs.isEmpty){
        int minutecount = Random().nextInt(20);
        await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(key).collection("Challenges").doc("Exercise for a combined total of $minutecount minutes").set({
          "goal": minutecount,
          "current": 0,
          "type": "time"
        });
        for(int i = 0; i<3; i++){
          int exerciseoptions = Random().nextInt(exercises.length);
          int count = Random().nextInt(20);
          await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").doc(key).collection("Challenges").doc("Do $count ${exercises[exerciseoptions]} in total").set({
            "goal": count,
            "current": 0,
            "type": exercises[exerciseoptions]
          });
        }
      }
    });
    dev.log("y = ${y}");
    dev.log("key = $key");
    dev.log("x = ${x}");
    dev.log("Last exercised = ${(DateTime.now().millisecondsSinceEpoch/(3600000))-(x["Last Exercised"].seconds/3600)}");
    return x;
  }

  Future<String> getImage(String cardString) async{
    String x = "";
    String url = await FirebaseStorage.instance.ref().child("calling_cards/").child(cardString).getDownloadURL();
    x = url;
    return x;
  }
  
  String Hello(bool connected){
    if(connected){
      return FirebaseAuth.instance.currentUser?.displayName != null? "Hello, ${FirebaseAuth.instance.currentUser?.displayName}!":"Hello, Anonymous!";
    }
    return "Hello, Offline user!";
  }

  void StreakDisplay(AsyncSnapshot snapshot){
    setState(() {
      num = int.parse(snapshot.data["StreakCap"].toString()) - int.parse(snapshot.data["Streaks"].toString());
    });
    print(num.toString());
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
          ){
        final bool connected = connectivity != ConnectivityResult.none;
        return FutureBuilder(
          future: getPlayerData(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    width: 430.w,
                    height: 932.h,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                    ),
                  ),
                  Container(
                    width: 430.w,
                    height: 932.h,
                    color: Colors.black.withOpacity(0.52),
                  ),
                  SingleChildScrollView(
                    child: FirebaseAuth.instance.currentUser?.uid != null? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150.h,
                          width: 430.w,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow]
                              ),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 40.sp, left: 20.sp, right: 20.sp),
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
                                          Hello(connected),
                                          style: TextStyle(
                                              color: Colors.white,

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

                                          fontSize: 22.sp
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(onPressed: () {}, icon: Icon(Icons.notifications, size: 32.sp, color: Colors.white,)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h,),
                        // connected? Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        //   child: TextButton(
                        //     onPressed: () {
                        //       Navigator.pushNamed(context, "/friends");
                        //     },
                        //     child: Row(
                        //       children: [
                        //         Text(
                        //           "Friends",
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 22.sp,
                        //
                        //           ),
                        //         ),
                        //         Icon(Icons.arrow_forward, color: Colors.yellow,)
                        //       ],
                        //     ),
                        //   ),
                        // ): SizedBox(),
                        // connected && FirebaseAuth.instance.currentUser?.displayName != null? Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                        //   child: SingleChildScrollView(
                        //     scrollDirection: Axis.horizontal,
                        //     child: SizedBox(
                        //       height: 120.h,
                        //       width: 380.w,
                        //       child: ListView.separated(
                        //         scrollDirection: Axis.horizontal,
                        //         itemCount: 10,
                        //         itemBuilder: (BuildContext context, int index){
                        //           return Column(
                        //             children: [
                        //               Icon(Icons.account_circle, size: 75.sp, color: Colors.white,),
                        //               Text("Username", style: TextStyle(fontSize: 14.sp, color: Colors.white),),
                        //               Row(
                        //                 children: [
                        //                   Icon(Icons.circle, size: 10.sp, color: Colors.grey,),
                        //                   SizedBox(width: 2.h,),
                        //                   Text("Offline", style: TextStyle(color: Colors.grey, fontSize: 12.sp),)
                        //                 ],
                        //               )
                        //             ],
                        //           );
                        //         }, separatorBuilder: (BuildContext context, int index) {
                        //         return SizedBox(width: 10.h,);
                        //       },
                        //       ),
                        //     ),
                        //   ),
                        // ): SizedBox(),
                        SizedBox(height: 10.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            "Streaks",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h,),
                        Center(
                          child: snapshot.hasData? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (Rect bounds){
                                      return LinearGradient(
                                          colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow],
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
                                  Text("Current streak: ${snapshot.data["Streaks"].toString()}", style: TextStyle(color: Colors.white, fontSize: 30.sp),)
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
                                      itemBuilder: (BuildContext context, int index) {
                                        num = int.parse(snapshot.data["StreakCap"].toString()) - int.parse(snapshot.data["Streaks"].toString());
                                        if(7-num >= index+1){
                                          return Icon(Icons.check_circle, size: 50.sp, color: Colors.orange,);
                                        }
                                        return Icon(Icons.circle, size: 50.sp,);
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ):SizedBox(
                            child: SpinKitRotatingPlain(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Daily challenges",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                ),
                              ),
                              // TextButton(
                              //   onPressed: () {
                              //     Navigator.pushNamed(context, "/challenges");
                              //   },
                              //   child: Row(
                              //     children: [
                              //       Text(
                              //         "See all",
                              //         style: TextStyle(
                              //           color: Colors.yellow,
                              //           fontSize: 18.sp,
                              //         ),
                              //       ),
                              //       Icon(Icons.arrow_forward, color: Colors.yellow,)
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),
                        Center(
                          child: Container(
                            height: 200.h,
                            width: 380.w,
                            decoration: const BoxDecoration(
                              color: Colors.black,
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
                                  SizedBox(height: 5.h,),
                                  Expanded(
                                    child: FutureBuilder(
                                      future: getChallenges(),
                                      builder: (BuildContext context, AsyncSnapshot s){
                                        return snapshot.hasData? ListView.builder(
                                          itemCount: 3,
                                          itemBuilder: (BuildContext c, int ind){
                                            return TaskItem(
                                                task: s.data[ind][2] == "time"? "Exercise for a total of ${s.data[ind][0]} minutes":"Do ${s.data[ind][0]} ${s.data[ind][2]}",
                                                progress: (s.data[ind][1]/s.data[ind][0])
                                            );
                                          },
                                        ): Text("No more challenges left, come back tommorow");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ):Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150.h,
                          width: 430.w,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow]
                              ),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 40.sp, left: 20.sp, right: 20.sp),
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
                                          Hello(connected),
                                          style: TextStyle(
                                              color: Colors.white,

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

                                          fontSize: 22.sp
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(onPressed: () {}, icon: Icon(Icons.notifications, size: 32.sp, color: Colors.white,)),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Icon(Icons.wifi_off, color: Colors.white, size: 64.sp,),
                            Text("sign up or login to complete challenges, keep up with exercise, and check on some friends", style: TextStyle(color: Colors.white, fontSize: 24.sp,),textAlign: TextAlign.center,),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButton: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    left: 40.0,
                    bottom: 70.sp
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Bounce(
                      child: Container(
                        width: 430.w,
                        height: 50.h,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Center(
                          child: Text(
                            "Let's Play",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.sp,
                                fontStyle: FontStyle.italic
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      duration: Duration(milliseconds: 50),
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context){
                              return Scaffold(
                                backgroundColor: Colors.black.withOpacity(0.7),
                                appBar: AppBar(
                                  title: Text("Choose gamemode", style: TextStyle(color: Colors.white),),
                                  leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back, color: Colors.white,)),
                                  backgroundColor: Colors.black.withOpacity(0.7),
                                ),
                                body: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                                    child: Column(
                                      children: [
                                        Bounce(
                                          duration: Duration(milliseconds: 50),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pushNamed(context, "/beforeoyo");
                                          },
                                          child: Container(
                                            width: 430.w,
                                            height: 50.h,
                                            decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                                border: GradientBoxBorder(
                                                    gradient: LinearGradient(
                                                        colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow]
                                                    ),
                                                    width: 4
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      height: 32.sp,
                                                      width: 32.sp,
                                                      child: ShaderMask(
                                                          blendMode: BlendMode.srcIn,
                                                          shaderCallback: (Rect bounds){
                                                            return LinearGradient(
                                                              colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow],
                                                            ).createShader(bounds);
                                                          },
                                                          child: Image.asset("assets/exercise.png", scale: 32.sp ,fit: BoxFit.fill,)
                                                      ),
                                                    ),
                                                    ShaderMask(
                                                      blendMode: BlendMode.srcIn,
                                                      shaderCallback: (Rect bounds){
                                                        return const LinearGradient(
                                                          colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow],
                                                        ).createShader(bounds);
                                                      },
                                                      child: Text(
                                                        "On your own",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 22.sp,

                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 32.sp,
                                                      width: 32.sp,
                                                      child: ShaderMask(
                                                          blendMode: BlendMode.srcIn,
                                                          shaderCallback: (Rect bounds){
                                                            return LinearGradient(
                                                              colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow],
                                                            ).createShader(bounds);
                                                          },
                                                          child: Image.asset("assets/exercise.png", scale: 32.sp ,fit: BoxFit.fill,)
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20.h,),
                                        Bounce(
                                          duration: Duration(milliseconds: 50),
                                          onPressed: () {
                                            // Navigator.pop(context);
                                            // Navigator.pushNamed(context, "/queue");
                                          },
                                          child: Container(
                                            width: 430.w,
                                            height: 50.h,
                                            decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                                border: GradientBoxBorder(
                                                    gradient: LinearGradient(
                                                        colors: [Colors.grey, Colors.grey, Colors.grey]
                                                    ),
                                                    width: 4
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      height: 32.sp,
                                                      width: 32.sp,
                                                      child: ShaderMask(
                                                          blendMode: BlendMode.srcIn,
                                                          shaderCallback: (Rect bounds){
                                                            return LinearGradient(
                                                              colors: [Colors.grey, Colors.grey, Colors.grey],
                                                            ).createShader(bounds);
                                                          },
                                                          child: Image.asset("assets/swords.png", scale: 32.sp ,fit: BoxFit.fill,)
                                                      ),
                                                    ),
                                                    ShaderMask(
                                                      blendMode: BlendMode.srcIn,
                                                      shaderCallback: (Rect bounds){
                                                        return const LinearGradient(
                                                          colors: [Colors.grey, Colors.grey, Colors.grey],
                                                        ).createShader(bounds);
                                                      },
                                                      child: Text(
                                                        "Coming soon",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 22.sp,

                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 32.sp,
                                                      width: 32.sp,
                                                      child: ShaderMask(
                                                          blendMode: BlendMode.srcIn,
                                                          shaderCallback: (Rect bounds){
                                                            return LinearGradient(
                                                              colors: [Colors.grey, Colors.grey, Colors.grey],
                                                            ).createShader(bounds);
                                                          },
                                                          child: Image.asset("assets/swords.png", scale: 32.sp ,fit: BoxFit.fill,)
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        );
                      }
                  ),
                ),
              ),
            );},
        );
      },
      child: SizedBox(),
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
                    color: Colors.white
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
                  child: LinearProgressIndicator(
                    color: Colors.orange,
                    backgroundColor: Colors.white,
                    value: progress,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.0),
          Icon(
            progress < 1? Icons.check_box_outline_blank: Icons.check_box,
            size: 20.0,
            color: progress < 1? Colors.white:Colors.orange,
          ),
        ],
      ),
    );
  }
}
