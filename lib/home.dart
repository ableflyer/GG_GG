import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'leaderboard.dart';
import 'playpage.dart';
import 'profilepage.dart';
import 'shoppage.dart';
import 'wpasspage.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int index = 0;
  final screens = [
    play(),
    // wpass(),
    // shop(),
    profile(),
    leaderboard()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.black.withOpacity(0.7),
            shadowColor: Colors.black,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 10, color: Colors.white)
            )
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            selectedIndex: index,
            onDestinationSelected: (index) => setState(() {
              this.index = index;
            }),
            destinations: [
              NavigationDestination(icon: Icon(Icons.sports_esports, color: Colors.white,), label: "Play"),
              // NavigationDestination(icon: Icon(Icons.military_tech, color: Colors.white,), label: "W Pass"),
              // NavigationDestination(icon: Icon(Icons.shopping_bag, color: Colors.white,), label: "Shop"),
              NavigationDestination(icon: Icon(Icons.person, color: Colors.white,), label: "You"),
              NavigationDestination(icon: Icon(Icons.leaderboard, color: Colors.white,), label: "Leaderboard"),
            ],
          ),
        ),
        body: screens[index]
      ),
    );
  }
}
