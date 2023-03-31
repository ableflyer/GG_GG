import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class activate extends StatelessWidget {
  const activate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 430.w,
            height: 932.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow]
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 250.w),
            child: Container(
              height: 584.h, width: 1034.w,
              child: RotatedBox(
                child: Image.asset("assets/gg_gg_text.png", fit: BoxFit.cover,),
                quarterTurns: 1,
              ),
            ),
          ),
          Center(
            child: Container(
                height: 1000.h, width: 1000.w,
                child: Image.asset("assets/run.png", fit: BoxFit.cover,)
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              child: Container(
                height: 449.h,
                width: 430.w,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 40, sigmaY: 40
                      ),
                      child: Container(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                          border: Border.all(color: Colors.white.withOpacity(0.13)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.5),
                                Colors.white.withOpacity(0.35)
                              ]
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Activate the Pre-Season Workout Pass",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 34.sp,
                                ),
                              ),
                              SizedBox(height: 5.h,),
                              Text(
                                "What can you get the Pre-Season workout pass",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.redeem_outlined, size: 64.sp,color: Colors.yellow,),
                                    Text(
                                      "Get more In-game rewards\nas you level up",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.military_tech_outlined, size: 64.sp,color: Colors.yellow,),
                                    Text(
                                      "Activate the current and\nnext workout pass\n(preseason only)",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Center(
                            child: Container(
                              height: 60.h,
                              width: 230.w,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xB5FDD601),
                                        Color(0xFFFDD601),
                                        Color(0xC9FDD601)]
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Activate",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26.sp
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.fitness_center, color: Colors.white, size: 48.sp,),
                                        SizedBox(width: 5.w,),
                                        Text(
                                          "250",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26.sp
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 32.sp,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
