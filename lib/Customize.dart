import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class customize extends StatefulWidget {
  const customize({super.key});

  @override
  State<customize> createState() => _customizeState();
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

class _customizeState extends State<customize> {

  Map arg = {};
  String pic = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    arg = ModalRoute.of(context)?.settings.arguments as Map;
    print(pic);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Customize"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            FittedBox(
              fit: BoxFit.fill,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Username", style: TextStyle(fontSize: 16.sp),),
                      IconButton(onPressed: () async{
                        final result = await Navigator.pushNamed(context, "/usernamecustomize", arguments: {
                          "username": name == ""? "${FirebaseAuth.instance.currentUser?.displayName}": name
                        });
                        setState(() {
                          var args = result as Map<dynamic, dynamic>;
                          name = args["username"];
                        });
                      }, icon: Icon(Icons.edit, color: Colors.orange,))
                    ],
                  ),
                  Text("${FirebaseAuth.instance.currentUser?.displayName}", style: TextStyle(fontSize: 48.sp),)
                ],
              ),
            ),
            SizedBox(height: 20.h,),
            Divider(),
            SizedBox(height: 20.h,),
            Hero(
              tag: "Card",
              child: Center(
                child: FutureBuilder(
                  future: getImage(
                      pic == ""? arg["CardDesign"]:pic
                  ),
                  builder:
                      (BuildContext context, AsyncSnapshot snap) {
                    if (snap.hasData) {
                      return Center(
                        child: SizedBox(
                          height: 300.h,
                          child: Stack(
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
                                      ))),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Bounce(
                                    onPressed: () async{
                                      final result = await Navigator.pushNamed(context, "/cardcustomize", arguments: {
                                        "CardDesign": arg["CardDesign"]
                                      });
                                      setState(() {
                                        pic = result.toString();
                                        print(pic);
                                      });
                                    },
                                    duration: Duration(milliseconds: 50),
                                    child: Container(
                                      height: 53.h,
                                      width: 170.w,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Change Card design",
                                          style: TextStyle(color: Colors.black, fontSize: 16.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
            ),
          ],
        ),
      )
    );
  }
}
