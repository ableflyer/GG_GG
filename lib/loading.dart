import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gg_gg/home.dart';
import 'package:gg_gg/welcome.dart';
import 'package:route_transitions/route_transitions.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late Timer timer;
  late bool ischecking = false;
  @override
  void didChangeDependencies() {
    if(!ischecking){
      ischecking = true;
    timer = Timer(Duration(seconds: 1), () {
      FirebaseFirestore.instance.collection("Users").doc("${FirebaseAuth.instance.currentUser?.uid}").collection("GG.GG").get().then(
          (value){
            if(value.size > 0){
              fadeWidget(newPage: home(), context: context);
            }
            else if(FirebaseAuth.instance.currentUser?.displayName == null){
              fadeWidget(newPage: home(), context: context);
            }
            else{
              fadeWidget(newPage: welcome(), context: context);
            }
          }
      );
    });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment.bottomRight,
        child: SpinKitRotatingPlain(
          color: Colors.white,
        ),
      ),
    );
  }
}
