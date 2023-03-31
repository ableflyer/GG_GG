import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class itemview extends StatelessWidget {
  const itemview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 430.w,
            height: 932.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/wardrobe.webp"),
                fit: BoxFit.cover
              )
            ),
          ),
          Container(
            width: 430.w,
            height: 932.h,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.42)
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 32.sp,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox()
                  ],
                ),
              ),
              Image.asset("assets/tshirt.webp", height: 544.h,width: 544.w,fit: BoxFit.cover,),
              ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                child: Container(
                  height: 314.h,
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
                                  Colors.white.withOpacity(0.15),
                                  Colors.white.withOpacity(0.05)
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
                                Align(
                                  child: Text(
                                    "Item name",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 34.sp,
                                    ),
                                  ),
                                  alignment: Alignment.topLeft,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Item description",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.sp
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 60.h,
                                width: 200.93.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF15FF00), Color(
                                        0xFF097401)]
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                child: Center(
                                  child: Text(
                                    "Claim",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26.sp
                                    ),
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
              )
            ],
          )
        ],
      ),
    );
  }
}
