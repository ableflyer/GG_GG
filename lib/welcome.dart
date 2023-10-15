import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_gg/page1.dart';
import 'package:gg_gg/page2.dart';
import 'package:gg_gg/page3.dart';
import 'package:gg_gg/page4.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';
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
  List<String> free_banners = ["freebanner1.jpg", "freebanner2.jpg", "freebanner3.jpg", "uae.jpg", "usa.jpg", "earlyaccess.jpg"];
  int ind = 0;
  int inx = 0;
  TextEditingController dateTEC = TextEditingController();
  TextEditingController genderTEC = TextEditingController();
  TextEditingController weightTEC = TextEditingController();
  TextEditingController heightTEC = TextEditingController();
  int exercise = 1;

  Widget BottomSheetWidget(int ind){
    if(ind == 0){
      return InkWell(
        onTap: () async{
          controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        },
        child: Container(
          color: Colors.green,
          height: 60.h,
          child: Center(child: Text("Get Started")),
        ),
      );
    }
    else if(ind == 4){
      return InkWell(
        onTap: () async{
          var gg = {
            "Level": 1,
            "Streaks": 0,
            "Banners": free_banners,
            "MMR": 1000,
            "Card design": free_banners[inx],
            "XP": 0,
            "Dumbbells": 0,
            "Last Exercised": DateTime.now().subtract(Duration(days:1)),
            "LastReset": DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
            "StreakCap": 7,
            "StreakHigh": 0,
            "BirthDate": dateTEC.text.toString(),
            "Gender": genderTEC.text.toString(),
            "weight": weightTEC.text.toString(),
            "height": heightTEC.text.toString(),
            "exercise": exercise == 1? "<1":exercise == 2? "2<x<4": "5+"
          };
          await FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").add(gg);
          Navigator.pushReplacementNamed(context, "/home");
        },
        child: Container(
          color: Colors.green,
          height: 60.h,
          child: Center(child: Text("Let's go")),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // TextButton(
        //   onPressed: () {},
        //   child: const Text("SKIP"),
        // ),
        ind != 3? SizedBox(width: 70.w,): SizedBox(),
        Center(
            child: Text("${ind}/3", style: TextStyle(color: Colors.white, fontSize: 24.sp),)
          // SmoothPageIndicator(
          //   controller: controller,
          //   count: 5
          // ),
        ),
        ind != 3? TextButton(
          onPressed: () {
            if(ind == 1){
              if(dateTEC.text.isNotEmpty && genderTEC.text.isNotEmpty && weightTEC.text.isNotEmpty && heightTEC.text.isNotEmpty){
                controller.nextPage(duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              }
            }
            else {
              controller.nextPage(duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            }
          },
          child: Text("NEXT"),
        ):SizedBox(),
      ],
    );
  }
  
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
            Scaffold(
              backgroundColor: Colors.black,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Put your information in", style: TextStyle(color: Colors.white, fontSize: 32.sp),),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            onTap: ()async{
                              DateTime? pickedDate = await showDatePicker(
                                  context: context, initialDate: DateTime.now(),
                                  firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101)
                              );

                              if(pickedDate != null ){
                                print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  dateTEC.text = formattedDate; //set output date to TextField value.
                                });
                              }else{
                                print("Date is not selected");
                              }
                            },
                            controller: dateTEC,
                            style: TextStyle(
                                color: Colors.white
                            ),
                            decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Colors.grey
                                ),
                                labelText: "Birth date",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)
                                ),
                                prefixIcon: Icon(Icons.date_range, color: Colors.white,),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            onTap: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return Dialog(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ElevatedButton(onPressed: () {genderTEC.text = "Male";Navigator.pop(context);}, child: Text("Male")),
                                        ElevatedButton(onPressed: () {genderTEC.text = "Female";Navigator.pop(context);}, child: Text("Female"))
                                      ],
                                    ),
                                  );
                                }
                              );
                            },
                            controller: genderTEC,
                            style: TextStyle(
                                color: Colors.white
                            ),
                            decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Colors.grey
                                ),
                                labelText: "Gender",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                prefixIcon: Icon(Icons.person, color: Colors.white,),

                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 146.h,
                      child: Column(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: weightTEC,
                              style: TextStyle(
                                  color: Colors.white
                              ),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Colors.grey
                                ),
                                labelText: "Weight (In kg)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                prefixIcon: Icon(Icons.monitor_weight, color: Colors.white,),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: heightTEC,
                              style: TextStyle(
                                  color: Colors.white
                              ),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Colors.grey
                                ),
                                labelText: "Height (In cm)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                prefixIcon: Icon(Icons.height, color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 120.h,),
                    Text("How often do you exercise", style: TextStyle(color: Colors.white, fontSize: 32.sp),),
                    SizedBox(height: 10.h,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Bounce(
                            onPressed: () {
                              setState(() {
                                exercise = 1;
                              });
                            },
                            duration: Duration(milliseconds: 50),
                            child: Container(
                              height: 100.h,
                              width: 430.w,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.directions_run, color: Colors.white, size: 64.sp,),
                                    Text("1 or less per week", style: TextStyle(color: Colors.white, fontSize: 28.sp),)
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                border: GradientBoxBorder(
                                  gradient: LinearGradient(colors: exercise == 1? [Color(0xFFFF1100), Colors.orange, Colors.yellow]:[Colors.white, Colors.white])
                                )
                              ),
                            ),
                          ),
                          Bounce(
                            onPressed: () {
                              setState(() {
                                exercise = 2;
                              });
                            },
                            duration: Duration(milliseconds: 50),
                            child: Container(
                              height: 100.h,
                              width: 430.w,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.sports_martial_arts, color: Colors.white, size: 64.sp,),
                                    Text("2 to 4 per week", style: TextStyle(color: Colors.white, fontSize: 28.sp),)
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  border: GradientBoxBorder(
                                      gradient: LinearGradient(colors: exercise == 2? [Color(0xFFFF1100), Colors.orange, Colors.yellow]:[Colors.white, Colors.white])
                                  )
                              ),
                            ),
                          ),
                          Bounce(
                            onPressed: () {
                              setState(() {
                                exercise = 3;
                              });
                            },
                            duration: Duration(milliseconds: 50),
                            child: Container(
                              height: 100.h,
                              width: 430.w,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.sports_mma, color: Colors.white, size: 64.sp,),
                                    Text("5 or more per week", style: TextStyle(color: Colors.white, fontSize: 28.sp),)
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  border: GradientBoxBorder(
                                      gradient: LinearGradient(colors: exercise == 3? [Color(0xFFFF1100), Colors.orange, Colors.yellow]:[Colors.white, Colors.white])
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
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
        color: ind != 4 || ind != 0? Colors.black: Colors.green,
        height: 60.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: BottomSheetWidget(ind)
        ),
      ),
    );
  }
}

