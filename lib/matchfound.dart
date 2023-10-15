import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class matchfound extends StatefulWidget {
  const matchfound({super.key});

  @override
  State<matchfound> createState() => _matchfoundState();
}

class _matchfoundState extends State<matchfound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 932.h,
        width: 430.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("M A T C H F O U N D", style: TextStyle(color: Colors.white, fontSize: 40.sp),),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300.h,
                  width: 150.w,
                  color: Colors.white,
                ),
                SizedBox(height: 20.h,),
                Text("V S", style: TextStyle(color: Colors.white, fontSize: 24.sp),),
                SizedBox(height: 20.h,),
                Container(
                  height: 300.h,
                  width: 150.w,
                  color: Colors.white,
                )
              ],
            ),
            Text("M A T C H F O U N D", style: TextStyle(color: Colors.white, fontSize: 40.sp),),
          ],
        ),
      ),
    );
  }
}

