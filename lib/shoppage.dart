import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

class shop extends StatelessWidget {
  const shop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds){
                return SweepGradient(
                  // begin: Alignment.center,
                  //   end: Alignment.bottomLeft,
                    colors: [Color(0xF309C9C3), Color(0xFF0056FF), Color(0xFFA100FF), Color(0xF309C9C3)]
                ).createShader(bounds);
              },
              child: Image.asset("assets/26378.png", height: 932.h, width: 430.w,fit: BoxFit.cover,)
          ),
          Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds){
                          return LinearGradient(
                              colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow],
                            stops: [0.1, 0.2, 0.3]
                          ).createShader(bounds);
                        },
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Featured",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 28.sp
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 400.h,
                      height: 400.h,
                      child: Row(
                        children: [
                          Container(
                            width: 200.h,
                            height: 400.h,
                            color: Colors.brown,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 200.h,
                                height: 200.h,
                                color: Colors.green,
                              ),
                              Container(
                                width: 200.h,
                                height: 200.h,
                                color: Colors.yellow,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Weekly dumbbell shop",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white,
                              fontSize: 28.sp
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 230.h,
                      width: 430.w,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        separatorBuilder: (context, index) {
                          return SizedBox(width: 15.w,);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              height: 200.h,
                              width: 150.w,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Image.asset("assets/tshirt.webp", fit: BoxFit.fill,),
                                  Text(
                                    "GG.GG T-shirt",
                                    style: TextStyle(
                                      fontSize: 20.sp
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        color: Colors.black,
                                        size: 32.sp,
                                      ),
                                      Text(
                                        "1000"
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Weekly Pi shop",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 230.h,
                      width: 430.w,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        separatorBuilder: (context, index) {
                          return SizedBox(width: 15.w,);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              height: 200.h,
                              width: 150.w,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Image.asset("assets/tshirt.webp", fit: BoxFit.fill,),
                                  Text(
                                    "GG.GG T-shirt",
                                    style: TextStyle(
                                        fontSize: 20.sp
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                          child: Image.asset("assets/pi.png", scale: 32.sp, fit: BoxFit.fill,),
                                        height: 32.sp,
                                        width: 32.sp,
                                      ),
                                      Text(
                                          "0.25"
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h,)
                  ],
                ),
              ),
              SizedBox(
                height: 121.h,
                child: ClipRect(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Stack(
                      children: [
                        BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 2, sigmaY: 2
                          ),
                          child: Container(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Shop",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 48.sp
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 38.h,
                                  width: 144.w,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        color: Colors.black,
                                        size: 32.sp,
                                      ),
                                      Text(
                                        "999k",
                                        style: TextStyle(
                                            fontSize: 20.sp
                                        ),
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 32.sp,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.h,),
                                Container(
                                  height: 38.h,
                                  width: 144.w,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                          child: Image.asset("assets/pi.png", scale: 32.sp,),
                                        height: 32.sp,
                                        width: 32.sp,
                                      ),
                                      Text(
                                        "999k",
                                        style: TextStyle(
                                            fontSize: 20.sp
                                        ),
                                      ),
                                      SizedBox(width: 32.sp,)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
