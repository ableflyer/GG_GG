import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  TextEditingController emailTEC = TextEditingController();

  TextEditingController passTEC = TextEditingController();

  String email = "";

  String pass = "";

  bool hide = false;

  Icon visibility = Icon(Icons.visibility_off, color: Colors.black,);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 32.sp,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/newlogo.png", scale: 10.sp,fit: BoxFit.contain,),
                SizedBox(height: 50.h,),
                Text(
                  "Log in",
                  style: TextStyle(
                      fontSize: 32.sp
                  ),
                ),
                SizedBox(height: 20.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: TextField(
                    controller: emailTEC,
                    style: TextStyle(
                        color: Colors.black
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.grey
                      ),
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h,),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    child: TextField(
                      controller: passTEC,
                      style: TextStyle(
                          color: Colors.black
                      ),
                      decoration: InputDecoration(
                          labelStyle: TextStyle(
                              color: Colors.grey
                          ),
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          prefixIcon: Icon(Icons.key, color: Colors.black,),
                          suffixIcon: IconButton(
                            icon: visibility,
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                hide = !hide;
                                visibility = hide == true ? Icon(Icons.visibility, color: Colors.black,):Icon(Icons.visibility_off, color: Colors.black,);
                              });
                            },
                          )
                      ),
                      obscureText: !hide,
                    )
                ),
                ElevatedButton(
                    onPressed: () async{
                      Future<bool> check() async{
                        if(emailTEC.text.toString().isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("email is empty"))
                          );
                          return false;
                        }
                        if(passTEC.text.toString().isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("password is empty"))
                          );
                          return false;
                        }
                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailTEC.text.toString(), password: passTEC.text.toString());
                        Navigator.pushReplacementNamed(context, "/home");
                        return true;
                      }
                      await check();
                    },
                    child: Text("Log in")
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text(
                            "Forgot password"
                        ),
                    ),
                    Text("-"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/signup");
                      },
                      child: Text(
                          "Go to Sign up"
                      ),
                    ),
                    SizedBox(width: 25.w,)
                  ],
                ),
                // InkWell(
                //   onTap: () async{
                //     log("Hello");
                //     await AuthService().sugoogle();
                //   },
                //   child: Stack(
                //     children: [
                //       Center(
                //         child: Container(
                //           height: 75.h,
                //           width: 300.w,
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.all(Radius.circular(10)),
                //               gradient: SweepGradient(
                //                   stops: [0.15, 0.35, 0.65, 0.9],
                //                   colors: [Color(0xFFDB3C2A), Color(0xFFE8AE01), Color(
                //                       0xFF2A9A49), Color(0xFF3878E4)]
                //               )
                //           ),
                //         ),
                //       ),
                //       Positioned.fill(
                //         child: Center(
                //           child: Container(
                //             height: 65.h,
                //             width: 285.w,
                //             decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.all(Radius.circular(10)),
                //                 color: Colors.white
                //             ),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 Image.asset("assets/g.png", scale: 75.sp,),
                //                 Text("Sign in with google")
                //               ],
                //             ),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
