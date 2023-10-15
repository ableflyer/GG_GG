import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class page1 extends StatelessWidget {
  const page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FirebaseAuth.instance.currentUser != null?Text("Hello ${FirebaseAuth.instance.currentUser?.displayName}\nwelcome to GG.GG", style: TextStyle(
                color: Colors.white,
                fontSize: 48.sp
            ),): Text("Hello user\nwelcome to GG.GG", style: TextStyle(
              color: Colors.white,
              fontSize: 48.sp
            ),),
            Text("click the next button below to continue", style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp
            ),),
            Image.asset("assets/new_gg_logo.png", scale: 7.sp,),
          ],
        ),
      ),
    );
  }
}
