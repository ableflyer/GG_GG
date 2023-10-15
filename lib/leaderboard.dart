import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'all time.dart';
import 'daily.dart';
import 'weekly.dart';

class leaderboard extends StatelessWidget {
  const leaderboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Text("Leaderboard", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Container(height: 50.h, child: Center(child: Text("Level", style: TextStyle(color: Colors.white),))),
              Container(height: 50.h, child: Center(child: Text("Streak Count", style: TextStyle(color: Colors.white),))),
            ],
          ),
        ),
        body: new TabBarView(
          children: [
            Level(),
            weekly(),
          ],
        ),
      ),
    );
  }
}
