import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class page2 extends StatelessWidget {
  const page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("That's your calling card\nbut it's boring", style: TextStyle(
                color: Colors.white,
                fontSize: 48.sp
            ),textAlign: TextAlign.center,),
            Icon(Icons.arrow_downward, size: 48.sp, color: Colors.white,),
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 300.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                        color: Colors.red
                    ),
                  ),
                ),
                Center(child: SizedBox(height: 300.h, width: 150.w,child: Image.asset("assets/card_holder.png", fit: BoxFit.cover,)))
              ],
            ),
            Text("Let's make it fun", style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp
            ),),
          ],
        ),
      ),
    );
  }
}
