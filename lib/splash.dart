import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_gg/home.dart';
import 'package:gg_gg/login.dart';
import 'package:gg_gg/signup.dart';
import 'package:route_transitions/route_transitions.dart';
class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> with TickerProviderStateMixin{
  late AnimationController _animationController;
  late Animation _animation;
  bool vb = false;
  late AnimationController blackcontroller;
  late Animation banim;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    blackcontroller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    banim = Tween(begin: 0.0).animate(blackcontroller);
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 1.5).animate(_animationController)..addListener(() {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    blackcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 932.h,
            width: 430.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: [_animation.value-0.5, _animation.value, _animation.value+0.5],
                begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF1100), Colors.orange, Colors.yellow]
              ),
            ),
          ),
          Center(
            child: FirebaseAuth.instance.currentUser != null? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/gg_new_logo.png"),
                ElevatedButton(
                  onPressed: () async{
                    vb = true;
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                      banim = Tween(begin: 0.0, end: 1.0).animate(blackcontroller);
                      blackcontroller.forward();
                    });
                    await Future.delayed(Duration(seconds: 1));
                    fadeWidget(newPage: home(), context: context);
                  },
                  child: Text("Play"),
                )
              ],
            ):Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/gg_new_logo.png"),
                ElevatedButton(
                  onPressed: () async{
                    vb = true;
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                      banim = Tween(begin: 0.0, end: 1.0).animate(blackcontroller);
                      blackcontroller.forward();
                    });
                    await Future.delayed(Duration(seconds: 1));
                    fadeWidget(newPage: login(), context: context);
                  },
                  child: Text("Login"),
                ),
                ElevatedButton(
                  onPressed: () async{
                    vb = true;
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                      banim = Tween(begin: 0.0, end: 1.0).animate(blackcontroller);
                      blackcontroller.forward();
                    });
                    await Future.delayed(Duration(seconds: 1));
                    fadeWidget(newPage: signup(), context: context);
                  },
                  child: Text("Signup"),
                )
              ],
            ),
          ),
          Visibility(
            visible: vb,
            child: Opacity(
              opacity: banim.value,
              child: Container(
                height: 932.h,
                width: 430.w,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
