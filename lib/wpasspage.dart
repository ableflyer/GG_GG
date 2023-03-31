import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class wpass extends StatelessWidget {
  const wpass({Key? key}) : super(key: key);

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
          SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                  child: Container(
                    width: 430.w,
                    height: 91.h,
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
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Workout Pass",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "alexandria",
                                  fontSize: 24.sp
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 30.h,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                          color: Colors.black
                                        ),
                                        child: Center(
                                          child: Text("1", style: TextStyle(color: Colors.white),)
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            width: 128.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                                              color: Colors.grey
                                            ),
                                          ),
                                          Container(
                                            width: 108.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                                              gradient: LinearGradient(
                                                  colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow]
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    child: Container(
                                      width: 140.w,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        gradient: LinearGradient(
                                            colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow]
                                        ),
                                      ),
                                      child: Center(
                                        child: Text("Activate", style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, "/activate");
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 752.h,
                  width: 430.w,
                  child: ListView.separated(
                    itemCount: 20,
                    separatorBuilder: (context, index) {
                      return Divider(thickness: 0,);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, "/view");
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 140.w,
                                  height: 140.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 120.w,
                                      height: 120.h,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 45.w,
                            height: 70.h,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Center(
                              child: Text(
                                "${index+1}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.sp
                                ),
                              )
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, "/view");
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 140.w,
                                  height: 140.h,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 120.w,
                                      height: 120.h,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },

                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
