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
    wpass(),
    shop(),
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
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 10)
            )
          ),
          child: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (index) => setState(() {
              this.index = index;
            }),
            destinations: [
              NavigationDestination(icon: Icon(Icons.sports_esports), label: "Play"),
              NavigationDestination(icon: Icon(Icons.military_tech), label: "W Pass"),
              NavigationDestination(icon: Icon(Icons.shopping_bag), label: "Shop"),
              NavigationDestination(icon: Icon(Icons.person), label: "You"),
              NavigationDestination(icon: Icon(Icons.leaderboard), label: "Leaderboard"),
            ],
          ),
        ),
        body: screens[index]
      ),
    );
  }
}
