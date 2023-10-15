import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class friends extends StatefulWidget {

  @override
  State<friends> createState() => _friendsState();
}

class _friendsState extends State<friends> {

  TextEditingController searchTEC = TextEditingController();
  bool search = false;

  Future<List> friendlist() async{
    List flist = [];
    await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("Friends").get().then((value){
      Map playerinfo = {};
      value.docs.forEach((element) {
        playerinfo["uid"] = element.data()["uid"];
        playerinfo["username"] = element.data()["username"];
        playerinfo["Card design"] = element.data()["Card design"];
      });
    });
    return flist;
  }
  Future<Map> getPlayerData(String id) async {
    Map x = {};
    Map y = {};
    String key = "";
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          if(search){
            setState(() {
              search = false;
            });
          }
          else{
            Navigator.pop(context);
          }
        }, icon: Icon(Icons.arrow_back)),
        elevation: 0,
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10, sigmaY: 10
            ),
            child: Container(color: Colors.transparent,),
          ),
        ),
        backgroundColor: Colors.transparent,
        title: !search? Text("Friends"):Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: TextField(
            autofocus: true,
            controller: searchTEC,
            style: TextStyle(
                color: Colors.black
            ),
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  color: Colors.grey
              ),
              labelText: "Search",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, "/search", arguments: {
                    "user": searchTEC.text
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        actions: [
          Visibility(
            visible: !search,
            child: IconButton(onPressed: () {
              setState(() {
                search = true;
              });
            }, icon: Icon(Icons.search)),
          ),
          Visibility(
            visible: !search,
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/addfriends");
                  }, icon: Icon(Icons.person_add_alt_1)
              )
          )
        ],
      ),
      body: SizedBox(
        height: 932.h,
        width: 432.w,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 150/300
            ),
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 300.h,
                width: 150.w,
                color: Colors.grey,
                child: Center(
                  child: Text(
                      "Friend ${index+1}"
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
