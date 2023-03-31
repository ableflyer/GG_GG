import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_gg/playpage.dart';

class challenges extends StatefulWidget {
  const challenges({Key? key}) : super(key: key);

  @override
  State<challenges> createState() => _challengesState();
}

class _challengesState extends State<challenges> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
        title: Text("Challenges"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               "Daily",
                style: TextStyle(
                  fontSize: 32.sp
                ),
              ),
              SizedBox(height: 25.h,),
              Center(
                child: Container(
                  height: 500.h,
                  width: 380.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50.h,),
              Text(
                "Weekly",
                style: TextStyle(
                    fontSize: 32.sp
                ),
              ),
              SizedBox(height: 25.h,),
              Center(
                child: Container(
                  height: 500.h,
                  width: 380.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50.h,),
              Text(
                "Seasonal",
                style: TextStyle(
                    fontSize: 32.sp
                ),
              ),
              SizedBox(height: 25.h,),
              Center(
                child: Container(
                  height: 500.h,
                  width: 380.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
