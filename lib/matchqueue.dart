import 'dart:async';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:text_scroll/text_scroll.dart';

class matchqueue extends StatefulWidget {
  const matchqueue({Key? key}) : super(key: key);

  @override
  State<matchqueue> createState() => _matchqueueState();
}

class _matchqueueState extends State<matchqueue> {
  int seconds = 0;
  late Timer timer;
  bool found = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startServer();
    startTimer();
  }

  void startServer() async{
    await FirebaseFirestore.instance.collection("GG.GG server").where("full", isEqualTo: false).get().then((value) async{
      for(var val in value.docs){
        print(val.data());
        print(val.id);
        if(val.data()["full"] == false){
          await FirebaseFirestore.instance.collection("GG.GG server").doc(val.id).set({
            "full": true,
            FirebaseAuth.instance.currentUser!.uid.toString(): FirebaseAuth.instance.currentUser!.uid.toString()
          }, SetOptions(merge: true));
          found = true;
        }
      }
    });
    if(!found) {
      await FirebaseFirestore.instance.collection("GG.GG server").add({
        "full": false,
        FirebaseAuth.instance.currentUser!.uid.toString(): FirebaseAuth.instance
            .currentUser!.uid.toString()
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async{
      final snapshot = await FirebaseFirestore.instance.collection("GG.GG server").where(FirebaseAuth.instance.currentUser!.uid.toString(), isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString()).get();
      if(snapshot.docs.first.data()["full"] == true){
        timer.cancel();
        Navigator.pushReplacementNamed(context, "/matchfound");
      }
      else{
        print(snapshot.docs.first.data());
      }
    });

  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextScroll(
            "Q U E U E F O R M A T C H",
            mode: TextScrollMode.endless,
            velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
            style: TextStyle(color: Colors.white, fontSize: 40.sp),
          ),
          Column(
            children: [
              Text(
                "Searching for a match",
                style: TextStyle(fontSize: 32.sp, color: Colors.white),
              ),
              SizedBox(height: 20.h,),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              )
            ],
          ),
          TextScroll(
            "Q U E U E F O R M A T C H",
            mode: TextScrollMode.endless,
            velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
            style: TextStyle(color: Colors.white, fontSize: 40.sp),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
