import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gg_gg/home.dart';
import 'package:gg_gg/loading.dart';
import 'package:gg_gg/login.dart';
import 'package:gg_gg/signup.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:soundpool/soundpool.dart';
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
    Soundpool pool = Soundpool.fromOptions();
    return OfflineBuilder(
      connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
          ){
        final bool connected = connectivity != ConnectivityResult.none;
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
              InkWell(
                onTap: () async{
                  vb = true;
                  int? soundID = await rootBundle.load("assets/beep.mp3").then((value){
                    return pool.load(value);
                  });
                  pool.play(soundID!);
                  WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                    banim = Tween(begin: 0.0, end: 1.0).animate(blackcontroller);
                    blackcontroller.forward();
                  });
                  await Future.delayed(Duration(seconds: 1));
                  fadeWidget(newPage: connected? Loading():home(), context: context);
                },
                child: SizedBox(
                    width: 430.w,
                    height: 932.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Image.asset(
                            "assets/new_gg_logo.png",
                            height: 140.h,
                            width: 300.w,
                          ),
                          height: 140.h,
                          width: 300.w,
                        ),
                        SizedBox(height: 5.h,),
                        Text("Press anywhere to start", style: TextStyle(color: Colors.white, fontSize: 32.sp),),
                      ],
                    )
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
      },
      child: SizedBox(),
    );

  }
}
