import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_gg/page1.dart';
import 'package:gg_gg/page2.dart';
import 'package:gg_gg/page3.dart';
import 'package:gg_gg/page4.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gg_gg/cardGridView.dart';


class welcome extends StatefulWidget {
  const welcome({Key? key}) : super(key: key);

  @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {

  Future<List<String>> getImages() async{
    List<String> x = [];
    for(var i = 0; i<free_banners.length; i++){
      String url = await FirebaseStorage.instance.ref().child("calling_cards/").child(free_banners[i]).getDownloadURL();
      x.add(url);
    }
    return x;
  }
  final controller = PageController();
  List<String> free_banners = ["freebanner1.jpg", "freebanner2.jpg", "freebanner3.jpg", "uae.jpg", "usa.jpg"];
  int ind = 0;
  int inx = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: 60.h),
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              ind = index;
            });
          },
          children: [
            page1(),
            page2(),
        Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                    future: getImages(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: 300.h,
                                  width: 150.w,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      image: DecorationImage(
                                          image: NetworkImage(snapshot.data[inx].toString()),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                              ),
                              Center(child: SizedBox(height: 300.h, width: 150.w,child: Image.asset("assets/card_holder.png", fit: BoxFit.cover,)))
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async{
                              controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                            },
                            child: Text("Set Card"),
                          )
                        ],
                      );
                    }
                ),
                SizedBox(width: 30.w,),
                SizedBox(
                  height: 932.h,
                  width: 200.w,
                  child: FutureBuilder(
                      future: getImages(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return GridView.builder(
                          itemCount: free_banners.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 5
                          ),
                          itemBuilder: (BuildContext context, int index){
                            return cardGridView(
                              imageURL: snapshot.data[index].toString(),
                              onTap: (){
                                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                  setState(() {
                                    inx = index;
                                    print(inx.toString());
                                  });
                                });
                              },
                              selected: inx == index,
                            );
                          },
                        );
                      }
                  ),
                )
              ],
            ),
          ),
        ),
        FutureBuilder(
          future: getImages(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("voila, your calling card", style: TextStyle(color: Colors.white, fontSize: 28.sp),),
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 300.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                image: DecorationImage(
                                    image: NetworkImage(snapshot.data[inx].toString()),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ),
                        Center(child: SizedBox(height: 300.h, width: 150.w,child: Image.asset("assets/card_holder.png", fit: BoxFit.cover,)))
                      ],
                    ),
                    Text("And so your journey begins", style: TextStyle(color: Colors.white, fontSize: 28.sp),),
                  ],
                ),
              ),
            );
          },
        )
          ],
        ),
      ),
      bottomSheet: Container(
        color: ind != 3? Colors.white: Colors.green,
        height: 60.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: ind != 3? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TextButton(
              //   onPressed: () {},
              //   child: const Text("SKIP"),
              // ),
              ind != 2? SizedBox(width: 70.w,): SizedBox(),
              Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: 4
                ),
              ),
              ind != 2? TextButton(
                onPressed: () {
                  controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                },
                child: Text("NEXT"),
              ):SizedBox(),
            ],
          ):InkWell(
            onTap: () async{
              var gg = {
                "Level": 1,
                "MMR": 1000,
                "Card design": free_banners[inx],
                "XP": 0,
                "Dumbbells": 0
              };
              await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").add(gg);
              Navigator.pushReplacementNamed(context, "/home");
            },
            child: Container(
              color: Colors.green,
              height: 60.h,
              child: Center(child: Text("Let's go")),
            ),
          ),
        ),
      ),
    );
  }
}

