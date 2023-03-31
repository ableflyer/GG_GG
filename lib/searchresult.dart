import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class searchresult extends StatefulWidget {

  @override
  State<searchresult> createState() => _searchresultState();
}

class _searchresultState extends State<searchresult> {

  TextEditingController searchTEC = TextEditingController();
  bool search = false;

  Future<List> getUsers(String data) async{
    List x = [];
    List val = [];
    await FirebaseFirestore.instance.collection("Users").where("name").get().then((value) async{
      for (var element in value.docs) {
        if(element.data()["name"].toString().contains(data)){
          val.add(element.id.toString());
          val.add(element.data()["name"].toString());
          await FirebaseFirestore.instance.collection("Users").doc(element.id.toString()).collection("GG.GG").where("Card design").get().then((value) {
            value.docs.forEach((e) {
              val.add(e.data());
            });
          });
        }
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

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        title: !search? Text("Search for '${args["user"]}'"):Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: getUsers(args["user"]),
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
                    future: getImage(snapshot.data[index][2]["Card design"].toString()),
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
                                      await FirebaseFirestore.instance.collection("Users").doc(snapshot.data[index][0].toString()).collection("Friend Requests").add({
                                        "username": FirebaseAuth.instance.currentUser?.displayName,
                                        "uid": FirebaseAuth.instance.currentUser?.uid,
                                      });
                                    },
                                    child: Text("Send request", style: TextStyle(fontSize: 14.sp),),
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
