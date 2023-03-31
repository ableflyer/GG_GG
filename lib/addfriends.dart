import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class addfriends extends StatefulWidget {

  @override
  State<addfriends> createState() => _addfriendsState();
}

class _addfriendsState extends State<addfriends> {

  Future<List> getRequests() async{
    List x = [];
    List val = [];
    await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("Friend Requests").get().then((value) async{
      for(var i in value.docs) {
        val.add(i.data()["uid"]);
        val.add(i.data()["username"]);
        await FirebaseFirestore.instance.collection("Users").doc("${i.data()["uid"]}").collection("GG.GG").get().then((v){
          for(var element in v.docs){
            val.add(element.data()["Card design"]);
          }
        });
        val.add(i.id);
        x.add(val);
        val = [];
      }
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

  TextEditingController searchTEC = TextEditingController();
  bool search = false;

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
        title: !search? Text("Friend requests"):Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: TextField(
            onSubmitted: (txt) {
              setState(() {
                search = false;
              });
              Navigator.pushNamed(context, "/search", arguments: {"user": txt});
            },
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
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
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
        ],
      ),
      body: FutureBuilder(
        future: getRequests(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return SizedBox(
            height: 932.h,
            width: 432.w,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 150/350
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                    future: getImage(snapshot.data[index][2].toString()),
                    builder: (BuildContext context, AsyncSnapshot snap){
                      return Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 300.h,
                                width: 150.w,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(snap.data.toString()),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              SizedBox(height: 300.h, width: 150.w,child: Image.asset("assets/card_holder.png", fit: BoxFit.cover,)),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ElevatedButton(
                                    onPressed: () async{
                                      await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("Friend Requests").doc("${snapshot.data[index][3]}").delete();
                                      await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("Friends").add({
                                        "username": snapshot.data[index][1],
                                        "uid": snapshot.data[index][0]
                                      });
                                      await FirebaseFirestore.instance.collection("Users").doc("${snapshot.data[index][0]}").collection("Friends").add({
                                        "username": FirebaseAuth.instance.currentUser?.displayName,
                                        "uid": FirebaseAuth.instance.currentUser?.uid
                                      });
                                    },
                                    child: Text("Accept", style: TextStyle(fontSize: 14.sp),),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text("${snapshot.data[index][1]}")
                        ],
                      );
                    },
                  );
                }
            ),
          );
        },
      ),
    );
  }
}
