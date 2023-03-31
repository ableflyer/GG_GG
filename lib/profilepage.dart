import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {

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
    return FirebaseAuth.instance.currentUser != null? FutureBuilder(
      future: getPlayerData(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
      return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder(
                    future: getImage(snapshot.data["Card design"].toString()),
                    builder: (BuildContext context, AsyncSnapshot snap){
                      if(snap.hasData){
                        return Stack(
                          children: [
                            Center(
                              child: Container(
                                height: 300.h,
                                width: 150.w,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    image: DecorationImage(
                                        image: NetworkImage(snap.data.toString()),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                            ),
                            Center(child: SizedBox(height: 300.h, width: 150.w,child: Image.asset("assets/card_holder.png", fit: BoxFit.cover,)))
                          ],
                        );
                      }
                      return Container(
                        height: 300.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                            color: Colors.red
                        ),
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/login");
                                  },
                                  child: Text("Log in"),
                                ),
                                ElevatedButton(
                                  onPressed: () async{
                                    Navigator.pushNamed(context, "/signup");
                                    // await auth0.webAuthentication().login();
                                  },
                                  child: Text("Sign up"),
                                )
                              ],
                            )
                        ),
                      );},
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Level",
                        style: TextStyle(
                          fontSize: 28.sp
                        ),
                      ),
                      Text(
                        "80",
                        style: TextStyle(
                            fontSize: 48.sp
                        ),
                      ),
                      Text(
                        "MMR",
                        style: TextStyle(
                            fontSize: 28.sp
                        ),
                      ),
                      Text(
                        "1820",
                        style: TextStyle(
                            fontSize: 48.sp
                        ),
                      ),
                      Text(
                        "Worldwide rank",
                        style: TextStyle(
                            fontSize: 28.sp
                        ),
                      ),
                      Text(
                        "#16",
                        style: TextStyle(
                            fontSize: 48.sp
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.tune, color: Colors.black,),
              trailing: Text("Customize your looks", style: TextStyle(color: Colors.black),),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.black,),
              trailing: Text("Friends", style: TextStyle(color: Colors.black),),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black,),
              trailing: Text("Settings", style: TextStyle(color: Colors.black),),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red,),
              trailing: Text("Log out", style: TextStyle(color: Colors.red),),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Are you sure?"
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {Navigator.pop(context);},
                                    child: Text("No", style: TextStyle(color: Colors.black),),
                                  ),
                                  ElevatedButton(
                                    onLongPress: () async{
                                      Navigator.pop(context);
                                      log("Logged out");
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacementNamed(context, "/");
                                      },
                                    child: Text("Yes (Hold to log out)", style: TextStyle(color: Colors.white),),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red
                                    ), onPressed: () {},
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                );
              },
            ),
          ],
        ),
      );},
    ):Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login or signup to become unstoppable"),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
              child: Text("Log in"),
            ),
            ElevatedButton(
              onPressed: () async{
                Navigator.pushNamed(context, "/signup");
                // await auth0.webAuthentication().login();
              },
              child: Text("Sign up"),
            )
          ],
        ),
      ),
    );
  }
}
